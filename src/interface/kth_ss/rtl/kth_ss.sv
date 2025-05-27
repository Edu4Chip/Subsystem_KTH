//-----------------------------------------------------------------------------
// File          : Student_SS_3.v
// Creation date : 23.04.2024
// Creation time : 12:45:24
// Description   : 
// Created by    : 
// Tool : Kactus2 3.13.1 64-bit
// Plugin : Verilog generator 2.4
// This file was generated based on IP-XACT component tuni.fi:subsystem:Student_SS_3:1.0
// whose XML file is C:/Users/kayra/Documents/repos/didactic-soc/ipxact/tuni.fi/subsystem/Student_SS_3/1.0/Student_SS_3.1.0.xml
//-----------------------------------------------------------------------------

module kth_ss #(
    // APB parameters
    parameter APB_AW = 32,
    parameter APB_DW = 32,

    // DRRA parameters
    parameter ROWS = 1,
    parameter COLS = 1,
    parameter INSTR_DATA_WIDTH = 32,
    parameter INSTR_ADDR_WIDTH = 6,   
    parameter INSTR_HOPS_WIDTH = 1,
    parameter IO_ADDR_WIDTH = 2,      
    parameter IO_DATA_WIDTH = 256,

    // Memory mapping parameters
    parameter INSTR_BASE_ADDR     = 32'h0000_0000,
    parameter INSTR_SIZE_BYTES    = 256,    // 64 words × 4 bytes
    parameter DATA_IN_BASE_ADDR   = 32'h0000_1000,
    parameter DATA_IN_SIZE_BYTES  = 96,     // 40 words (input: 16, twiddle factor: 8) × 4 bytes
    parameter DATA_OUT_BASE_ADDR  = 32'h0000_2000,
    parameter DATA_OUT_SIZE_BYTES = 64,     // 16 words × 4 bytes
    parameter CTRL_BASE_ADDR      = 32'h0000_3000,
    parameter CTRL_SIZE_BYTES     = 12      // DRRA_cell & call & ret     

)(
    // Interface: APB
    input  logic [31:0] PADDR,
    input  logic        PENABLE,
    input  logic        PSEL,
    input  logic [31:0] PWDATA,
    input  logic        PWRITE,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic        PSLVERR,

    // Interface: Clock
    input  logic        clk_in,

    // Interface: high_speed_clock
    input  logic        high_speed_clk,             // unsed

    // Interface: IRQ
    output logic        irq_3,                      // unsed

    // Interface: Reset
    input  logic        reset_int,

    // Interface: SS_Ctrl
    input  logic        irq_en_3,                   // unsed
    input  logic [7:0]  ss_ctrl_3,                  // unsed
    
    //Interface: GPIO pmod 
    input  logic [15:0]  pmod_gpi,                  // unsed  
    output logic [15:0]  pmod_gpo,                  // unsed
    output logic [15:0]  pmod_gpio_oe               // unsed   
);

    fabric_wrapper #(
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
    ) fabric_wrapper_inst (
        .clk(clk_in),
        .rst_n(reset_int),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );
    
    // tieoff the unused output pots
    assign irq_3   = 'd0;
    assign pmod_gpo     = 'h0;
    assign pmod_gpio_oe = 'h0;

endmodule