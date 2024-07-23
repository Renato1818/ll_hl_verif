//==============================================================================
//
// The code is generated by Intel Compiler for SystemC, version 1.6.3
// see more information at https://github.com/intel/systemc-compiler
//
//==============================================================================

//==============================================================================
//
// Module: Robot ()
//
module Robot // "tb.dut_inst"
(
    input logic clk,
    input logic rstn,
    input logic [15:0] dist_v,
    output logic alarm_flag
);

// Variables generated for SystemC signals
logic obs_detected;

//------------------------------------------------------------------------------
// Clocked THREAD: sensor (Robot.h:34:2) 

// Thread-local variables
logic [1:0] sensor_WAIT_N_COUNTER;
logic [1:0] sensor_WAIT_N_COUNTER_next;
logic obs_detected_next;
logic sensor_PROC_STATE;
logic sensor_PROC_STATE_next;

// Next-state combinational logic
always_comb begin : sensor_comb     // Robot.h:34:2
    sensor_func;
end
function void sensor_func;
    obs_detected_next = obs_detected;
    sensor_WAIT_N_COUNTER_next = sensor_WAIT_N_COUNTER;
    sensor_PROC_STATE_next = sensor_PROC_STATE;
    
    case (sensor_PROC_STATE)
        0: begin
            sensor_WAIT_N_COUNTER_next = 2;
            sensor_PROC_STATE_next = 1; return;    // Robot.h:39:8;
        end
        1: begin
            if (sensor_WAIT_N_COUNTER != 1) begin
                sensor_WAIT_N_COUNTER_next = sensor_WAIT_N_COUNTER - 1;
                sensor_PROC_STATE_next = 1; return;    // Robot.h:39:8;
            end;
            if (dist_v < 16'd50)
            begin
                obs_detected_next = 1;
            end else begin
                obs_detected_next = 0;
            end
            sensor_WAIT_N_COUNTER_next = 2;
            sensor_PROC_STATE_next = 1; return;    // Robot.h:39:8;
        end
    endcase
endfunction

// Synchronous register update
always_ff @(posedge clk or negedge rstn) 
begin : sensor_ff
    if ( ~rstn ) begin
        obs_detected <= 0;
        sensor_PROC_STATE <= 0;    // Robot.h:37:4;
        sensor_WAIT_N_COUNTER <= 0;
    end
    else begin
        sensor_WAIT_N_COUNTER <= sensor_WAIT_N_COUNTER_next;
        obs_detected <= obs_detected_next;
        sensor_PROC_STATE <= sensor_PROC_STATE_next;
    end
end

//------------------------------------------------------------------------------
// Clocked THREAD: controller (Robot.h:54:2) 

// Thread-local variables
logic alarm_flag_next;
logic controller_PROC_STATE;
logic controller_PROC_STATE_next;

// Next-state combinational logic
always_comb begin : controller_comb     // Robot.h:54:2
    controller_func;
end
function void controller_func;
    alarm_flag_next = alarm_flag;
    controller_PROC_STATE_next = controller_PROC_STATE;
    
    case (controller_PROC_STATE)
        0: begin
            sensor_WAIT_N_COUNTER_next = 1;
            controller_PROC_STATE_next = 1; return;    // Robot.h:59:6;
        end
        1: begin
            if (sensor_WAIT_N_COUNTER != 1) begin
                sensor_WAIT_N_COUNTER_next = sensor_WAIT_N_COUNTER - 1;
                controller_PROC_STATE_next = 1; return;    // Robot.h:59:6;
            end;
            if (obs_detected)
            begin
                alarm_flag_next = 1;
            end
            sensor_WAIT_N_COUNTER_next = 1;
            controller_PROC_STATE_next = 1; return;    // Robot.h:59:6;
        end
    endcase
endfunction

// Synchronous register update
always_ff @(posedge clk or negedge rstn) 
begin : controller_ff
    if ( ~rstn ) begin
        alarm_flag <= 0;
        controller_PROC_STATE <= 0;    // Robot.h:56:4;
    end
    else begin
        alarm_flag <= alarm_flag_next;
        controller_PROC_STATE <= controller_PROC_STATE_next;
    end
end

endmodule

