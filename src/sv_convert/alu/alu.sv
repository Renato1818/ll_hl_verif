//==============================================================================
//
// The code is generated by Intel Compiler for SystemC, version 1.6.3
// see more information at https://github.com/intel/systemc-compiler
//
//==============================================================================

//==============================================================================
//
// Module: alu ()
//
module alu // "tb.dut_inst"
(
    input logic clk,
    input logic rstn,
    input logic [2:0] OPCODE,
    input logic [3:0] OP1,
    input logic [3:0] OP2,
    output logic CARRY,
    output logic ZERO,
    output logic [3:0] RESULT
);

//------------------------------------------------------------------------------
// Clocked THREAD: operate (alu.h:65:2) 

// Thread-local variables
logic [4:0] result;
logic [4:0] result_next;
logic ZERO_next;
logic [3:0] RESULT_next;
logic CARRY_next;
logic operate_PROC_STATE;
logic operate_PROC_STATE_next;

// Next-state combinational logic
always_comb begin : operate_comb     // alu.h:65:2
    operate_func;
end
function void operate_func;
    logic [3:0] data1;
    logic [3:0] data2;
    logic [3:0] i;
    logic [3:0] bit_v;
    logic [3:0] TMP_0;
    logic [3:0] value;
    logic [3:0] pos;
    logic [3:0] divisor;
    logic [3:0] i_1;
    logic [3:0] TMP_1;
    logic [4:0] TMP_2;
    logic [4:0] value_1;
    logic [3:0] pos_1;
    logic [3:0] bit_v_1;
    logic [3:0] TMP_3;
    logic [3:0] current_bit;
    logic [3:0] divisor_1;
    logic [3:0] i_2;
    logic [3:0] TMP_5;
    logic [3:0] TMP_6;
    logic [4:0] TMP_7;
    logic [3:0] TMP_8;
    logic [3:0] TMP_10;
    logic [3:0] TMP_11;
    logic [4:0] TMP_12;
    logic [3:0] TMP_13;
    logic [3:0] TMP_15;
    logic [3:0] TMP_16;
    logic [4:0] TMP_17;
    logic [3:0] TMP_18;
    TMP_0 = 0;
    value = 0;
    pos = 0;
    divisor = 0;
    i_1 = 0;
    TMP_1 = 0;
    TMP_2 = 0;
    value_1 = 0;
    pos_1 = 0;
    bit_v_1 = 0;
    TMP_3 = 0;
    current_bit = 0;
    divisor_1 = 0;
    i_2 = 0;
    TMP_5 = 0;
    TMP_6 = 0;
    TMP_7 = 0;
    TMP_8 = 0;
    TMP_10 = 0;
    TMP_11 = 0;
    TMP_12 = 0;
    TMP_13 = 0;
    TMP_15 = 0;
    TMP_16 = 0;
    TMP_17 = 0;
    TMP_18 = 0;
    CARRY_next = CARRY;
    RESULT_next = RESULT;
    ZERO_next = ZERO;
    result_next = result;
    operate_PROC_STATE_next = operate_PROC_STATE;
    
    case (operate_PROC_STATE)
        0: begin
            operate_PROC_STATE_next = 1; return;    // alu.h:84:4;
        end
        1: begin
            ZERO_next = 0;
            data1 = OP1;
            data2 = OP2;
            case (OPCODE)
            0 : begin
                result_next = data1 + data2;
            end
            1 : begin
                result_next = data1 - data2;
            end
            2 : begin
                result_next = data1 + 1;
            end
            3 : begin
                result_next = data1 - 1;
            end
            4 : begin
                for (i = 0; 1; i = 1 + 1)
                begin
                    value = data1; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_0 = (value / divisor) % 2;
                    // Call get_bit() end
                    value = data2; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_1 = (value / divisor) % 2;
                    // Call get_bit() end
                    bit_v = TMP_0 * TMP_1;
                    value_1 = result_next; pos_1 = i; bit_v_1 = bit_v;
                    // Call set_bit() begin
                    value = value_1; pos = pos_1;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_3 = (value / divisor) % 2;
                    // Call get_bit() end
                    current_bit = TMP_3;
                    divisor_1 = 1;
                    i_2 = 0;
                    for (i_2 = 0; i_2 < pos_1; i_2 = 1 + 1)
                    begin
                        divisor_1 = divisor_1 * 2;
                    end
                    if (current_bit == bit_v_1)
                    begin
                        TMP_2 = value_1;
                    end else begin
                        if (bit_v_1 == 1)
                        begin
                            TMP_2 = value_1 + divisor_1;
                        end else begin
                            TMP_2 = value_1 - divisor_1;
                        end
                    end
                    // Call set_bit() end
                    result_next = TMP_2;
                end
            end
            5 : begin
                for (i = 0; 1; i = 1 + 1)
                begin
                    value = data1; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_5 = (value / divisor) % 2;
                    // Call get_bit() end
                    value = data2; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_6 = (value / divisor) % 2;
                    // Call get_bit() end
                    bit_v = TMP_5 + TMP_6;
                    value_1 = result_next; pos_1 = i; bit_v_1 = bit_v > 0 ? 1 : 0;
                    // Call set_bit() begin
                    value = value_1; pos = pos_1;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_8 = (value / divisor) % 2;
                    // Call get_bit() end
                    current_bit = TMP_8;
                    divisor_1 = 1;
                    i_2 = 0;
                    for (i_2 = 0; i_2 < pos_1; i_2 = 1 + 1)
                    begin
                        divisor_1 = divisor_1 * 2;
                    end
                    if (current_bit == bit_v_1)
                    begin
                        TMP_7 = value_1;
                    end else begin
                        if (bit_v_1 == 1)
                        begin
                            TMP_7 = value_1 + divisor_1;
                        end else begin
                            TMP_7 = value_1 - divisor_1;
                        end
                    end
                    // Call set_bit() end
                    result_next = TMP_7;
                end
            end
            6 : begin
                for (i = 0; 1; i = 1 + 1)
                begin
                    value = data1; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_10 = (value / divisor) % 2;
                    // Call get_bit() end
                    value = data2; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_11 = (value / divisor) % 2;
                    // Call get_bit() end
                    bit_v = TMP_10 * TMP_11;
                    value_1 = result_next; pos_1 = i; bit_v_1 = |bit_v ? 0 : 1;
                    // Call set_bit() begin
                    value = value_1; pos = pos_1;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_13 = (value / divisor) % 2;
                    // Call get_bit() end
                    current_bit = TMP_13;
                    divisor_1 = 1;
                    i_2 = 0;
                    for (i_2 = 0; i_2 < pos_1; i_2 = 1 + 1)
                    begin
                        divisor_1 = divisor_1 * 2;
                    end
                    if (current_bit == bit_v_1)
                    begin
                        TMP_12 = value_1;
                    end else begin
                        if (bit_v_1 == 1)
                        begin
                            TMP_12 = value_1 + divisor_1;
                        end else begin
                            TMP_12 = value_1 - divisor_1;
                        end
                    end
                    // Call set_bit() end
                    result_next = TMP_12;
                end
            end
            7 : begin
                for (i = 0; 1; i = 1 + 1)
                begin
                    value = data1; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_15 = (value / divisor) % 2;
                    // Call get_bit() end
                    value = data2; pos = i;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_16 = (value / divisor) % 2;
                    // Call get_bit() end
                    bit_v = TMP_15 + TMP_16;
                    value_1 = result_next; pos_1 = i; bit_v_1 = bit_v == 1 ? 1 : 0;
                    // Call set_bit() begin
                    value = value_1; pos = pos_1;
                    // Call get_bit() begin
                    divisor = 1;
                    i_1 = 0;
                    for (i_1 = 0; i_1 < pos; i_1 = 1 + 1)
                    begin
                        divisor = divisor * 2;
                    end
                    TMP_18 = (value / divisor) % 2;
                    // Call get_bit() end
                    current_bit = TMP_18;
                    divisor_1 = 1;
                    i_2 = 0;
                    for (i_2 = 0; i_2 < pos_1; i_2 = 1 + 1)
                    begin
                        divisor_1 = divisor_1 * 2;
                    end
                    if (current_bit == bit_v_1)
                    begin
                        TMP_17 = value_1;
                    end else begin
                        if (bit_v_1 == 1)
                        begin
                            TMP_17 = value_1 + divisor_1;
                        end else begin
                            TMP_17 = value_1 - divisor_1;
                        end
                    end
                    // Call set_bit() end
                    result_next = TMP_17;
                end
            end
            endcase
            RESULT_next = result_next[3 : 0];
            CARRY_next = result_next[4];
            if (result_next == 0)
            begin
                ZERO_next = 1;
            end
            if (!rstn)
            begin
                RESULT_next = 0;
                CARRY_next = 0;
                ZERO_next = 0;
            end
            operate_PROC_STATE_next = 1; return;    // alu.h:84:4;
        end
    endcase
endfunction

// Synchronous register update
always_ff @(posedge clk) 
begin : operate_ff
    begin
        result <= result_next;
        ZERO <= ZERO_next;
        RESULT <= RESULT_next;
        CARRY <= CARRY_next;
        operate_PROC_STATE <= operate_PROC_STATE_next;
    end
end

endmodule


