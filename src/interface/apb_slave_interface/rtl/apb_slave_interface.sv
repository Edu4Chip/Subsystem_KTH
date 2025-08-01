module apb_slave_interface #(
    // APB parameters
    parameter APB_AW,
    parameter APB_DW,

    // DRRA parameters
    parameter ROWS,
    parameter COLS,
    parameter INSTR_DATA_WIDTH,
    parameter INSTR_ADDR_WIDTH,   
    parameter INSTR_HOPS_WIDTH,
    parameter IO_ADDR_WIDTH,      
    parameter IO_DATA_WIDTH,

    // Memory mapping parameters
    parameter INSTR_BASE_ADDR,    
    parameter INSTR_SIZE_BYTES,    
    parameter DATA_IN_BASE_ADDR, 
    parameter DATA_IN_SIZE_BYTES,   
    parameter DATA_OUT_BASE_ADDR,
    parameter DATA_OUT_SIZE_BYTES,
    parameter CTRL_BASE_ADDR,
    parameter CTRL_SIZE_BYTES    
) (
    input  logic clk,
    input  logic rst_n,
    
    // APB ports - based on AMBA 3 APB Protocol Specification
    input  logic PSEL,
    input  logic PENABLE,
    input  logic PWRITE,
    input  logic [APB_AW-1:0] PADDR,
    input  logic [APB_DW-1:0] PWDATA,
    output logic [APB_DW-1:0] PRDATA,
    output logic PREADY,        
    output logic PSLVERR,

    // DRRA ports
    output logic [ROWS-1:0] call,
    input  logic [ROWS-1:0] ret,

    input  logic [COLS-1:0] io_en_in,                          
    input  logic [COLS-1:0][IO_ADDR_WIDTH-1:0] io_addr_in,     
    output logic [COLS-1:0][IO_DATA_WIDTH-1:0] io_data_in,
    input  logic [COLS-1:0] io_en_out,                          
    input  logic [COLS-1:0][IO_ADDR_WIDTH-1:0] io_addr_out,     
    input  logic [COLS-1:0][IO_DATA_WIDTH-1:0] io_data_out,
    
    output logic [ROWS-1:0][INSTR_DATA_WIDTH-1:0] instr_data_in,
    output logic [ROWS-1:0][INSTR_ADDR_WIDTH-1:0] instr_addr_in,
    output logic [ROWS-1:0][INSTR_HOPS_WIDTH-1:0] instr_hops_in,
    output logic [ROWS-1:0] instr_en_in,
    input  logic [ROWS-1:0][INSTR_DATA_WIDTH-1:0] instr_data_out,
    input  logic [ROWS-1:0][INSTR_ADDR_WIDTH-1:0] instr_addr_out,
    input  logic [ROWS-1:0][INSTR_HOPS_WIDTH-1:0] instr_hops_out,
    input  logic [ROWS-1:0] instr_en_out
    );
    
    function logic in_range (input logic [APB_AW-1:0] address, input logic [APB_AW-1:0] base_address, input integer size_bytes);
        return (address >= base_address) && (address < base_address + size_bytes);
    endfunction

    localparam NUM_CHUNKS = IO_DATA_WIDTH / APB_DW;
    
    
    logic [APB_AW-1:0]               control_reg;
    logic [APB_DW-1:0]               ret_reg;
    logic [15:0]                     row_index;
    logic [15:0]                     col_index;
    logic                            input_buffer_wen;
    logic                            input_buffer_ren;
    logic [IO_ADDR_WIDTH-1:0]        input_buffer_addr;
    logic [IO_DATA_WIDTH-1:0]        input_buffer_data_in;
    logic [IO_DATA_WIDTH-1:0]        input_buffer_data_out;
    logic [IO_ADDR_WIDTH-1:0]        addr_mmio_ib;
    logic [IO_DATA_WIDTH-1:0]        assembler_mmio_ib;
    logic                            en_mmio_ib;
    logic [($clog2(NUM_CHUNKS))-1:0] chunck_counter_ib;
    logic                            output_buffer_wen;
    logic                            output_buffer_ren;
    logic [IO_ADDR_WIDTH-1:0]        output_buffer_addr;
    logic [IO_DATA_WIDTH-1:0]        output_buffer_data_in;
    logic [IO_DATA_WIDTH-1:0]        output_buffer_data_out;
    logic [IO_ADDR_WIDTH-1:0]        addr_mmio_ob;
    logic [APB_DW-1:0]               disassembler_mmio_ob;
    logic                            en_mmio_ob;
    logic [($clog2(NUM_CHUNKS))-1:0] chunck_counter_ob;
    logic                            apb_write;
    logic                            apb_read;
    logic                            sel_instr_region; 
    logic                            sel_data_in_region;
    logic                            sel_data_out_region;
    logic                            sel_ctrl_region;
    
    assign apb_write = PSEL && PENABLE &&  PWRITE && !PSLVERR;
    assign apb_read  = PSEL && PENABLE && !PWRITE && !PSLVERR;

    // APB address decoding
    assign sel_instr_region    = in_range(PADDR, INSTR_BASE_ADDR, INSTR_SIZE_BYTES);
    assign sel_data_in_region  = in_range(PADDR, DATA_IN_BASE_ADDR, DATA_IN_SIZE_BYTES);
    assign sel_data_out_region = in_range(PADDR, DATA_OUT_BASE_ADDR, DATA_OUT_SIZE_BYTES);
    assign sel_ctrl_region     = in_range(PADDR, CTRL_BASE_ADDR, CTRL_SIZE_BYTES);
    
    assign row_index = control_reg[(APB_AW/2)-1:0];
    assign col_index = control_reg[APB_AW-1:APB_AW/2];

    io_buffer #(
        .ADDR_WIDTH(IO_ADDR_WIDTH),
        .DATA_WIDTH(IO_DATA_WIDTH)
    ) input_buffer_inst (
        .clk(clk),
        .rst_n(rst_n),
        .write_enable(input_buffer_wen),
        .read_enable(input_buffer_ren),
        .addr(input_buffer_addr),
        .data_in(input_buffer_data_in),
        .data_out(input_buffer_data_out)
    );

    assign input_buffer_wen  = en_mmio_ib;
    assign input_buffer_ren  = io_en_in[col_index];
    assign input_buffer_addr = input_buffer_wen ? addr_mmio_ib : 
                               input_buffer_ren ? io_addr_in[col_index] : {IO_ADDR_WIDTH{1'bx}};
    
    // input buffer: read by drra
    always_comb begin
        for (int i = 0; i < COLS; i++) begin
            io_data_in[i] = (i == col_index) ? input_buffer_data_out : 0;
        end
    end
    
    // input buffer: written by riscv (MMIO)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_mmio_ib <= 1'b0;
            addr_mmio_ib <= 0;
            assembler_mmio_ib <= 0;
        end else if (apb_write && sel_data_in_region) begin
            en_mmio_ib <= (&chunck_counter_ib) ? 1'b1 : 1'b0;
            addr_mmio_ib <= {{IO_ADDR_WIDTH{1'b0}}, PADDR[($clog2(DATA_IN_SIZE_BYTES/COLS))-1: ($clog2(NUM_CHUNKS)) + 2]};
            assembler_mmio_ib[chunck_counter_ib * 32 +: 32] <= PWDATA;
        end else begin
            en_mmio_ib <= 1'b0;
        end
    end

    always_ff @(posedge clk, negedge rst_n) begin : CHUNK_COUNTER_IB
        if (!rst_n) begin
            chunck_counter_ib <= 0;
        end else if (apb_write && sel_data_in_region) begin
            if (chunck_counter_ib < NUM_CHUNKS - 1) begin
                chunck_counter_ib <= chunck_counter_ib + 1'b1;
            end
            else begin
                chunck_counter_ib <= 0;
            end
        end
    end

    assign input_buffer_data_in = input_buffer_wen ? assembler_mmio_ib : 0;


    io_buffer #(
        .ADDR_WIDTH(IO_ADDR_WIDTH),
        .DATA_WIDTH(IO_DATA_WIDTH)
    ) output_buffer_inst (
        .clk(clk),
        .rst_n(rst_n),
        .write_enable(output_buffer_wen),
        .read_enable(output_buffer_ren),
        .addr(output_buffer_addr),
        .data_in(output_buffer_data_in),
        .data_out(output_buffer_data_out)
    );

    assign output_buffer_wen  = io_en_out[col_index];
    assign output_buffer_ren  = en_mmio_ob;
    assign output_buffer_addr = output_buffer_wen ? io_addr_out[col_index] : 
                                output_buffer_ren ? addr_mmio_ob : {IO_ADDR_WIDTH{1'bx}};
    
    // output buffer: written by drra
    assign output_buffer_data_in = io_data_out[col_index];

    // output buffer: read by riscv (MMIO)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_mmio_ob <= 1'b0;
            addr_mmio_ob <= 0;
        end else if (apb_read && sel_data_out_region) begin
            en_mmio_ob <= 1'b1;
            addr_mmio_ob <= {{IO_ADDR_WIDTH{1'b0}}, PADDR[($clog2(DATA_OUT_SIZE_BYTES/COLS))-1: ($clog2(NUM_CHUNKS)) + 2]};
        end else begin
            en_mmio_ob <= 1'b0;
        end
    end
    
    always_ff @(posedge clk, negedge rst_n) begin : CHUNK_COUNTER_OB
        if (!rst_n) begin
            chunck_counter_ob <= 0;
        end else if (en_mmio_ob) begin
            if (chunck_counter_ob < NUM_CHUNKS - 1) begin
                chunck_counter_ob <= chunck_counter_ob + 1'b1;
            end else begin
                chunck_counter_ob <= 0;
            end
        end
    end

    assign disassembler_mmio_ob = output_buffer_data_out[chunck_counter_ob * 32 +: 32];

  
    // instruction loader: written by riscv (MMIO)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int r = 0; r < ROWS; r++) begin
                instr_en_in  [r] <= 0;
                instr_addr_in[r] <= 0;
                instr_data_in[r] <= 0;
                instr_hops_in[r] <= 0;
            end
        end else if (apb_write && sel_instr_region) begin
            for (int r = 0; r < ROWS; r++) begin
                instr_en_in  [r] <= (r == row_index) ? 1'b1 : 1'b0;
                instr_addr_in[r] <= (r == row_index) ? PADDR[($clog2(INSTR_SIZE_BYTES/ROWS))-1:2] : 0;   // PADDR[7:2];
                instr_data_in[r] <= (r == row_index) ? PWDATA : 0;
                instr_hops_in[r] <= (r == row_index) ? col_index : 0; 
            end
        end else begin
            instr_en_in[ROWS-1] <= 1'b0;
        end
    end


    // control and status registers: written by riscv (MMIO)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control_reg <= 0;
        end else if (apb_write) begin
            if (PADDR == CTRL_BASE_ADDR) begin
                control_reg <= PWDATA[ROWS-1:0];
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            call <= 0;
        end else if (apb_write) begin
            if (PADDR == CTRL_BASE_ADDR + 32'h4) begin
                for (int r = 0; r < ROWS; r++) begin
                    call[r] <= PWDATA[0];
                end
            end 
        end else begin
            call <= 0;
        end 
    end


    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ret_reg <= 0;
        end else if (apb_read) begin
            if (PADDR == CTRL_BASE_ADDR + 32'h8) begin
                for (int r = 0; r < ROWS; r++) begin
                    ret_reg[r] <= ret[r];
                end
                ret_reg[APB_DW-ROWS-2: ROWS] <= {(APB_DW - ROWS){1'b0}};
                ret_reg[APB_DW-ROWS-1] <= 1'b1;   // MSB is used to indicate valid data
            end
            else 
                ret_reg[APB_DW-ROWS-1] <= 1'b0;
        end
    end

    assign PRDATA = ret_reg[APB_DW-ROWS-1] ? {1'b0, ret_reg[APB_DW-ROWS-2:0]} :
                   (en_mmio_ob) ? disassembler_mmio_ob : {{APB_DW{1'bx}}};

    // Always ready for single-cycle response
    assign PREADY = 1'b1; 
    
    // Error Logic (address checks) 
    // assign PSLVERR = 1'b0;
    always_comb begin
        PSLVERR = 1'b0;

        if (PSEL && PENABLE) begin
            if (sel_instr_region) begin
                if (PADDR[($clog2(INSTR_SIZE_BYTES/ROWS))-1:2] >= (INSTR_SIZE_BYTES/4))  
                    PSLVERR = 1'b1;
            end else if (sel_data_in_region) begin
                if (PADDR[($clog2(DATA_IN_SIZE_BYTES/COLS))-1:2] >= (DATA_IN_SIZE_BYTES/4))
                    PSLVERR = 1'b1;
            end else if (sel_data_out_region) begin
                if (PADDR[($clog2(DATA_OUT_SIZE_BYTES/COLS))-1:2] >= (DATA_OUT_SIZE_BYTES/4))
                    PSLVERR = 1'b1;
            end else if (sel_ctrl_region) begin
                if (PADDR[($clog2(CTRL_SIZE_BYTES/COLS))-1:2] >= (CTRL_SIZE_BYTES/4))
                    PSLVERR = 1'b1;
            end else begin
                PSLVERR = 1'b1; // invalid region
            end
        end
    end

endmodule

