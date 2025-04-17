`define complex_dpu_impl _uvcilbfxawa
`define complex_dpu_impl_pkg _uvcilbfxawa_pkg

package _uvcilbfxawa_pkg;
    parameter BULK_BITWIDTH = 256;
    parameter RESOURCE_INSTR_WIDTH = 27;
    parameter WORD_BITWIDTH = 32;

    typedef struct packed {
        logic [1:0] _option;
        logic [4:0] _mode;
        logic [15:0] _immediate;
    } dpu_t;

    function static dpu_t unpack_dpu;
        input logic [23:0] instr;
        dpu_t _dpu;
        _dpu._option  = instr[23:22];
        _dpu._mode  = instr[21:17];
        _dpu._immediate  = instr[16:1];
        return _dpu;
    endfunction

    function static logic [23:0] pack_dpu;
        input dpu_t _dpu;
        logic [23:0] instr;

        instr[23:22] = _dpu._option;
        instr[21:17] = _dpu._mode;
        instr[16:1] = _dpu._immediate;
        return instr;
    endfunction
    typedef struct packed {
        logic [1:0] _port;
        logic [3:0] _level;
        logic [5:0] _iter;
        logic [5:0] _step;
        logic [5:0] _delay;
    } rep_t;

    function static rep_t unpack_rep;
        input logic [23:0] instr;
        rep_t _rep;
        _rep._port  = instr[23:22];
        _rep._level  = instr[21:18];
        _rep._iter  = instr[17:12];
        _rep._step  = instr[11:6];
        _rep._delay  = instr[5:0];
        return _rep;
    endfunction

    function static logic [23:0] pack_rep;
        input rep_t _rep;
        logic [23:0] instr;

        instr[23:22] = _rep._port;
        instr[21:18] = _rep._level;
        instr[17:12] = _rep._iter;
        instr[11:6] = _rep._step;
        instr[5:0] = _rep._delay;
        return instr;
    endfunction
    typedef struct packed {
        logic [1:0] _port;
        logic [3:0] _level;
        logic [5:0] _iter;
        logic [5:0] _step;
        logic [5:0] _delay;
    } repx_t;

    function static repx_t unpack_repx;
        input logic [23:0] instr;
        repx_t _repx;
        _repx._port  = instr[23:22];
        _repx._level  = instr[21:18];
        _repx._iter  = instr[17:12];
        _repx._step  = instr[11:6];
        _repx._delay  = instr[5:0];
        return _repx;
    endfunction

    function static logic [23:0] pack_repx;
        input repx_t _repx;
        logic [23:0] instr;

        instr[23:22] = _repx._port;
        instr[21:18] = _repx._level;
        instr[17:12] = _repx._iter;
        instr[11:6] = _repx._step;
        instr[5:0] = _repx._delay;
        return instr;
    endfunction
    typedef struct packed {
        logic [1:0] _port;
        logic [6:0] _delay_0;
        logic [6:0] _delay_1;
        logic [6:0] _delay_2;
    } fsm_t;

    function static fsm_t unpack_fsm;
        input logic [23:0] instr;
        fsm_t _fsm;
        _fsm._port  = instr[23:22];
        _fsm._delay_0  = instr[21:15];
        _fsm._delay_1  = instr[14:8];
        _fsm._delay_2  = instr[7:1];
        return _fsm;
    endfunction

    function static logic [23:0] pack_fsm;
        input fsm_t _fsm;
        logic [23:0] instr;

        instr[23:22] = _fsm._port;
        instr[21:15] = _fsm._delay_0;
        instr[14:8] = _fsm._delay_1;
        instr[7:1] = _fsm._delay_2;
        return instr;
    endfunction

  parameter FSM_MAX_STATES = 4;
  parameter FSM_DELAY_WIDTH = 3;
  parameter DPU_MODE_WIDTH = 6;
  parameter DPU_IMMEDIATE_WIDTH = 8;
  parameter OPCODE_WIDTH = 4;
  parameter BITWIDTH = 16;
  parameter INSTRUCTION_PAYLOAD_WIDTH = 27;
  parameter OPCODE_H = 26;
  parameter OPCODE_L = 24;
  parameter OPCODE_DPU = 3;
  parameter OPCODE_FSM = 2;
  parameter DPU_MODE_ADD = 1;
  parameter DPU_MODE_MUL = 7;
  parameter DPU_MODE_MAC = 10;

endpackage

module _uvcilbfxawa
import _uvcilbfxawa_pkg::*;
(
    input  logic clk_0,
    input  logic rst_n_0,
    input  logic instr_en_0,
    input  logic [RESOURCE_INSTR_WIDTH-1:0] instr_0,
    input  logic [3:0] activate_0,
    input  logic [WORD_BITWIDTH-1:0] word_data_in_0,
    output logic [WORD_BITWIDTH-1:0] word_data_out_0,
    input  logic [BULK_BITWIDTH-1:0] bulk_data_in_0,
    output logic [BULK_BITWIDTH-1:0] bulk_data_out_0,
    input  logic clk_1,
    input  logic rst_n_1,
    input  logic instr_en_1,
    input  logic [RESOURCE_INSTR_WIDTH-1:0] instr_1,
    input  logic [3:0] activate_1,
    input  logic [WORD_BITWIDTH-1:0] word_data_in_1,
    output logic [WORD_BITWIDTH-1:0] word_data_out_1,
    input  logic [BULK_BITWIDTH-1:0] bulk_data_in_1,
    output logic [BULK_BITWIDTH-1:0] bulk_data_out_1
);

    logic clk, rst_n, instruction_valid, activate;
    logic [RESOURCE_INSTR_WIDTH-1:0] instruction;
    assign clk = clk_0;
    assign rst_n = rst_n_0;
    assign instruction_valid = instr_en_0;
    assign activate = activate_0[0];
    assign instruction = instr_0;

    // useless output
    assign word_data_out_1 = 0;
    assign bulk_data_out_0 = 0;
    assign bulk_data_out_1 = 0;

    // register inputs
    logic [WORD_BITWIDTH-1:0] in0, in1, out0;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in0 <= 0;
            in1 <= 0;
        end else begin
            in0 <= word_data_in_0;
            in1 <= word_data_in_1;
        end
    end

    logic [$clog2(FSM_MAX_STATES)-1:0][DPU_MODE_WIDTH-1:0] mode_memory;
    logic [$clog2(FSM_MAX_STATES)-1:0][DPU_IMMEDIATE_WIDTH-1:0] immediate_memory;
    logic [$clog2(FSM_MAX_STATES)-1:0] fsm_option;
    logic [DPU_IMMEDIATE_WIDTH-1:0] immediate;
    logic [DPU_MODE_WIDTH-1:0] mode;
    logic [OPCODE_WIDTH-1:0] opcode;
    logic dpu_valid;
    logic fsm_valid;

    dpu_t dpu;
    fsm_t fsm;

    fsm u_dpu_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .activate(|activate),
        .instruction_valid(instruction_valid),
        .instruction(instruction),
        .state(fsm_option)
    );

    assign opcode = instruction[OPCODE_H:OPCODE_L];
    assign dpu_valid = instruction_valid && (opcode == OPCODE_DPU);
    assign fsm_valid = instruction_valid && (opcode == OPCODE_FSM);
    assign dpu = dpu_valid ? unpack_dpu(
            instruction[INSTRUCTION_PAYLOAD_WIDTH-1:0]
        ) :
        '{default: 0};
    assign fsm = fsm_valid ? unpack_fsm(
            instruction[INSTRUCTION_PAYLOAD_WIDTH-1:0]
        ) :
        '{default: 0};
  
    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        immediate_memory <= '0;
      end else begin
        if (dpu_valid) begin
          mode_memory[dpu._option] <= dpu._mode;
          immediate_memory[dpu._option] <= dpu._immediate;
        end
      end
    end

    assign mode = mode_memory[fsm_option];
    assign immediate = immediate_memory[fsm_option];

    logic signed [WORD_BITWIDTH-1:0] adder_in0;
    logic signed [WORD_BITWIDTH-1:0] adder_in1;
    logic signed [WORD_BITWIDTH-1:0] adder_out;
    logic signed [WORD_BITWIDTH-1:0] mult_in0;
    logic signed [WORD_BITWIDTH-1:0] mult_in1;
    logic signed [WORD_BITWIDTH-1:0] mult_out;

    always_comb begin
        out0 = 0;
        adder_in0 = 0;
        adder_in1 = 0;
        mult_in0 = 0;
        mult_in1 = 0;

        case (mode)
            DPU_MODE_ADD: begin
                adder_in0 = in0;
                adder_in1 = in1;
                out0 = adder_out;
            end
            DPU_MODE_MUL: begin
                mult_in0 = in0;
                mult_in1 = in1;
                out0 = mult_out;
            end
        endcase
    end

    adder adder_inst (
        .data_in0(adder_in0),
        .data_in1(adder_in1),
        .data_out(adder_out)
    );

    multiplier mult_inst (
        .data_in0(mult_in0),
        .data_in1(mult_in1),
        .data_out(mult_out)
    );

    assign word_data_out_0 = out0;

endmodule

module adder
import _uvcilbfxawa_pkg::*;
(
    input  logic signed [WORD_BITWIDTH-1:0] data_in0,
    input  logic signed [WORD_BITWIDTH-1:0] data_in1,
    output logic signed [WORD_BITWIDTH-1:0] data_out  
);

    // real and imag signals
    logic [WORD_BITWIDTH/2-1:0] data0_r;
    logic [WORD_BITWIDTH/2-1:0] data0_i;
    logic [WORD_BITWIDTH/2-1:0] data1_r;
    logic [WORD_BITWIDTH/2-1:0] data1_i;
    logic [WORD_BITWIDTH/2-1:0] add_out_r;
    logic [WORD_BITWIDTH/2-1:0] add_out_i;

    always_comb begin
        data0_r <= data_in0[WORD_BITWIDTH-1:WORD_BITWIDTH/2];
        data0_i <= data_in0[WORD_BITWIDTH/2-1:0];
        data1_r <= data_in1[WORD_BITWIDTH-1:WORD_BITWIDTH/2];
        data1_i <= data_in1[WORD_BITWIDTH/2-1:0];
    end

    parameter COMPLEX_BITWIDTH = WORD_BITWIDTH/2;

    assign add_out_r = COMPLEX_BITWIDTH'(data0_r + data1_r);
    assign add_out_i = COMPLEX_BITWIDTH'(data0_i + data1_i);

    assign data_out = {add_out_r, add_out_i};

endmodule

module multiplier
import _uvcilbfxawa_pkg::*;
(
    input  logic signed [WORD_BITWIDTH-1:0] data_in0,
    input  logic signed [WORD_BITWIDTH-1:0] data_in1,
    output logic signed [WORD_BITWIDTH-1:0] data_out
);

    parameter COMPLEX_BITWIDTH = WORD_BITWIDTH/2;
    parameter FRAC_BITWIDTH = WORD_BITWIDTH/4;

    // real and imag signals
    logic [COMPLEX_BITWIDTH-1:0] data0_r;
    logic [COMPLEX_BITWIDTH-1:0] data0_i;
    logic [COMPLEX_BITWIDTH-1:0] data1_r;
    logic [COMPLEX_BITWIDTH-1:0] data1_i;
    logic [COMPLEX_BITWIDTH-1:0] mul_out1;
    logic [COMPLEX_BITWIDTH-1:0] mul_out2;
    logic [COMPLEX_BITWIDTH-1:0] mul_out2_neg;
    logic [COMPLEX_BITWIDTH-1:0] mul_out3;
    logic [COMPLEX_BITWIDTH-1:0] mul_out4;
    logic [COMPLEX_BITWIDTH-1:0] mul_out_r;
    logic [COMPLEX_BITWIDTH-1:0] mul_out_i;

    logic signed [COMPLEX_BITWIDTH-1:0] temp1, temp2, temp3, temp4;

    always_comb begin
        data0_r <= data_in0[WORD_BITWIDTH-1:WORD_BITWIDTH/2];
        data0_i <= data_in0[WORD_BITWIDTH/2-1:0];
        data1_r <= data_in1[WORD_BITWIDTH-1:WORD_BITWIDTH/2];
        data1_i <= data_in1[WORD_BITWIDTH/2-1:0];
    end

    always_comb begin
        temp1 = data0_r * data1_r;       // ac
        temp2 = data0_i * data1_i;       // bd
        temp3 = data0_r * data1_i;       // ad
        temp4 = data0_i * data1_r;       // bc
        // truncation and rounding
        mul_out1 = temp1 >>> FRAC_BITWIDTH;    
        mul_out2 = temp2 >>> FRAC_BITWIDTH;    
        mul_out3 = temp3 >>> FRAC_BITWIDTH;
        mul_out4 = temp4 >>> FRAC_BITWIDTH;    
        // bd sign conversion (2's complement)
        mul_out2_neg = (~mul_out2) + 1;
    end

    assign mul_out_r = COMPLEX_BITWIDTH'(mul_out1 + mul_out2_neg);  // ac + bd
    assign mul_out_i = COMPLEX_BITWIDTH'(mul_out3 + mul_out4);  // (ad + bc) i

    assign data_out = {mul_out_r, mul_out_i};

endmodule

module fsm
import _uvcilbfxawa_pkg::*;
(
    input logic clk,
    input logic rst_n,
    input logic activate,
    input logic instruction_valid,
    input logic [INSTRUCTION_PAYLOAD_WIDTH-1:0] instruction,
    output logic [$clog2(FSM_MAX_STATES)-1:0] state
);

  logic [INSTRUCTION_PAYLOAD_WIDTH-1:0] instruction_reg;
  logic [OPCODE_WIDTH-1:0] opcode;
  logic fsm_valid;
  logic [$clog2(FSM_MAX_STATES)-1:0] next_state;
  logic [FSM_MAX_STATES-2:0][FSM_DELAY_WIDTH-1:0] fsm_delays;
  logic [FSM_DELAY_WIDTH-1:0] delay_counter;
  logic [FSM_DELAY_WIDTH-1:0] delay_counter_next;

  fsm_t fsm;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      instruction_reg <= '0;
    end else begin
      if (instruction_valid) begin
        instruction_reg <= instruction;
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      delay_counter <= fsm_delays[0];
    end else begin
      delay_counter <= delay_counter_next;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fsm_delays = '0;
    end else begin
      fsm_delays[0] = fsm._delay_0;
      fsm_delays[1] = fsm._delay_1;
      fsm_delays[2] = fsm._delay_2;

    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 0;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = 0;
    delay_counter_next = 0;
    if (delay_counter == 0) begin
      if (state == FSM_MAX_STATES - 1) begin
        next_state = 0;
      end else begin
        next_state = state + 1;
        delay_counter_next = fsm_delays[state];
      end
    end else begin
      delay_counter_next = delay_counter - 1;
    end
  end

  assign opcode = instruction_reg[OPCODE_H:OPCODE_L];
  assign fsm_valid = instruction_valid && (opcode == OPCODE_FSM);
  assign fsm = fsm_valid ?
      '{default: 0}
      : unpack_fsm(
          instruction_reg[INSTRUCTION_PAYLOAD_WIDTH-1:0]
      );


endmodule

