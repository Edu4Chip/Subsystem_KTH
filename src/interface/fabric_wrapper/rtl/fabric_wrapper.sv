module fabric_wrapper #(
    // APB parameters
    parameter APB_AW = 32,
    parameter APB_DW = 32,

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
)  (
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
    output logic PSLVERR
);

    logic [ROWS-1:0] call_net;
    logic [ROWS-1:0] ret_net;
    logic [COLS-1:0] io_en_in_net;
    logic [COLS-1:0][IO_ADDR_WIDTH-1:0] io_addr_in_net;
    logic [COLS-1:0][IO_DATA_WIDTH-1:0] io_data_in_net;
    logic [COLS-1:0] io_en_out_net;
    logic [COLS-1:0][IO_ADDR_WIDTH-1:0] io_addr_out_net;
    logic [COLS-1:0][IO_DATA_WIDTH-1:0] io_data_out_net;
    logic [ROWS-1:0][INSTR_DATA_WIDTH-1:0] instr_data_in_net;
    logic [ROWS-1:0][INSTR_ADDR_WIDTH-1:0] instr_addr_in_net;
    logic [ROWS-1:0][INSTR_HOPS_WIDTH-1:0] instr_hops_in_net;
    logic [ROWS-1:0] instr_en_in_net;
    logic [ROWS-1:0][INSTR_DATA_WIDTH-1:0] instr_data_out_net;
    logic [ROWS-1:0][INSTR_ADDR_WIDTH-1:0] instr_addr_out_net;
    logic [ROWS-1:0][INSTR_HOPS_WIDTH-1:0] instr_hops_out_net;
    logic [ROWS-1:0] instr_en_out_net;

    fabric fabric_inst (
        .clk(clk),
        .rst_n(rst_n),
        .call(call_net),
        .ret(ret_net),
        .io_en_in(io_en_in_net),
        .io_addr_in(io_addr_in_net),
        .io_data_in(io_data_in_net),
        .io_en_out(io_en_out_net),
        .io_addr_out(io_addr_out_net),
        .io_data_out(io_data_out_net),
        .instr_data_in(instr_data_in_net),
        .instr_addr_in(instr_addr_in_net),
        .instr_hops_in(instr_hops_in_net),
        .instr_en_in(instr_en_in_net),
        .instr_data_out(instr_data_out_net),
        .instr_addr_out(instr_addr_out_net),
        .instr_hops_out(instr_hops_out_net),
        .instr_en_out(instr_en_out_net)
    );

    apb_slave_interface #(
        .APB_AW(APB_AW),
        .APB_DW(APB_DW),
        .ROWS(ROWS),
        .COLS(COLS),
        .INSTR_DATA_WIDTH(INSTR_DATA_WIDTH),
        .INSTR_ADDR_WIDTH(INSTR_ADDR_WIDTH),
        .INSTR_HOPS_WIDTH(INSTR_HOPS_WIDTH),
        .IO_ADDR_WIDTH(IO_ADDR_WIDTH),
        .IO_DATA_WIDTH(IO_DATA_WIDTH),
        .INSTR_BASE_ADDR(INSTR_BASE_ADDR),
        .INSTR_SIZE_BYTES(INSTR_SIZE_BYTES),
        .DATA_IN_BASE_ADDR(DATA_IN_BASE_ADDR),
        .DATA_IN_SIZE_BYTES(DATA_IN_SIZE_BYTES),
        .DATA_OUT_BASE_ADDR(DATA_OUT_BASE_ADDR),
        .DATA_OUT_SIZE_BYTES(DATA_OUT_SIZE_BYTES),
        .CTRL_BASE_ADDR(CTRL_BASE_ADDR),
        .CTRL_SIZE_BYTES(CTRL_SIZE_BYTES)
    ) apb_slave_interface_inst (
        .clk(clk),
        .rst_n(rst_n),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),        
        .PSLVERR(PSLVERR),
        .call(call_net),
        .ret(ret_net),
        .io_en_in(io_en_in_net),
        .io_addr_in(io_addr_in_net),
        .io_data_in(io_data_in_net),
        .io_en_out(io_en_out_net),
        .io_addr_out(io_addr_out_net),
        .io_data_out(io_data_out_net),
        .instr_data_in(instr_data_in_net),
        .instr_addr_in(instr_addr_in_net),
        .instr_hops_in(instr_hops_in_net),
        .instr_en_in(instr_en_in_net),
        .instr_data_out(instr_data_out_net),
        .instr_addr_out(instr_addr_out_net),
        .instr_hops_out(instr_hops_out_net),
        .instr_en_out(instr_en_out_net)
    );

endmodule
