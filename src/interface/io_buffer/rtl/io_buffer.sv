module io_buffer #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 256
) (
    input  logic clk,
    input  logic rst_n,
    
    input  logic write_enable,
    input  logic read_enable,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);
    
    logic [DATA_WIDTH-1:0] buffer [2**ADDR_WIDTH-1:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
                buffer[i] <= '0;
            end
        end else if (write_enable) begin
            buffer[addr] <= data_in;
        end 
    end

    assign data_out = (read_enable) ? buffer[addr] : {DATA_WIDTH{1'bz}};
endmodule
