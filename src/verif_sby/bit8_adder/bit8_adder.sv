module bit8_adder (
        input logic clk,
        input logic rstn,
        input logic Cin,
        input logic A1,
        input logic A2,
        input logic A3,
        input logic A4,
        input logic A5,
        input logic A6,
        input logic A7,
        input logic A8,
        input logic B1,
        input logic B2,
        input logic B3,
        input logic B4,
        input logic B5,
        input logic B6,
        input logic B7,
        input logic B8,
        output logic S1,
        output logic S2,
        output logic S3,
        output logic S4,
        output logic S5,
        output logic S6,
        output logic S7,
        output logic S8,
        output logic Cout
    );

    //Auxiliar variables to ha1 and fa1
    reg s11, c11, cin_1d;
    reg s1, c1;

    //Auxiliar variables to ha2 and fa2
    reg s21, c21, c1_1d;
    reg s2, c2;

    //Auxiliar variables to ha3 and fa3
    reg s31, c31, c2_1d;
    reg s3, c3;
    
    //Auxiliar variables to ha4 and fa4
    reg s41, c41, c3_1d;
    reg s4, c4;

    //Auxiliar variables to ha5 and fa5
    reg s51, c51, c4_1d;
    reg s5, c5;

    //Auxiliar variables to ha6 and fa6
    reg s61, c61, c5_1d;
    reg s6, c6;

    //Auxiliar variables to ha7 and fa7
    reg s71, c71, c6_1d;
    reg s7, c7;

    //Auxiliar variables to ha8 and fa8
    reg s81, c81, c7_1d;
    reg s8, c8;
    
    //Delay Inputs to prevent miss match
    reg a2_1d, a2_2d;
    reg b2_1d, b2_2d;
    reg a3_1d, a3_2d, a3_3d, a3_4d;
    reg b3_1d, b3_2d, b3_3d, b3_4d;
    reg a4_1d, a4_2d, a4_3d, a4_4d, a4_5d, a4_6d;
    reg b4_1d, b4_2d, b4_3d, b4_4d, b4_5d, b4_6d;
    reg a5_1d, a5_2d, a5_3d, a5_4d, a5_5d, a5_6d, a5_7d, a5_8d;
    reg b5_1d, b5_2d, b5_3d, b5_4d, b5_5d, b5_6d, b5_7d, b5_8d;
    reg a6_1d, a6_2d, a6_3d, a6_4d, a6_5d, a6_6d, a6_7d, a6_8d, a6_9d, a6_10d;
    reg b6_1d, b6_2d, b6_3d, b6_4d, b6_5d, b6_6d, b6_7d, b6_8d, b6_9d, b6_10d;
    reg a7_1d, a7_2d, a7_3d, a7_4d, a7_5d, a7_6d, a7_7d, a7_8d, a7_9d, a7_10d, a7_11d, a7_12d;
    reg b7_1d, b7_2d, b7_3d, b7_4d, b7_5d, b7_6d, b7_7d, b7_8d, b7_9d, b7_10d, b7_11d, b7_12d;
    reg a8_1d, a8_2d, a8_3d, a8_4d, a8_5d, a8_6d, a8_7d, a8_8d, a8_9d, a8_10d, a8_11d, a8_12d, a8_13d, a8_14d;
    reg b8_1d, b8_2d, b8_3d, b8_4d, b8_5d, b8_6d, b8_7d, b8_8d, b8_9d, b8_10d, b8_11d, b8_12d, b8_13d, b8_14d;

    //Delay Outputs
    reg s1_1d, s1_2d, s1_3d, s1_4d, s1_5d, s1_6d, s1_7d, s1_8d, s1_9d, s1_10d, s1_11d, s1_12d, s1_13d, s1_14d;
    reg s2_1d, s2_2d, s2_3d, s2_4d, s2_5d, s2_6d, s2_7d, s2_8d, s2_9d, s2_10d, s2_11d, s2_12d;
    reg s3_1d, s3_2d, s3_3d, s3_4d, s3_5d, s3_6d, s3_7d, s3_8d, s3_9d, s3_10d;
    reg s4_1d, s4_2d, s4_3d, s4_4d, s4_5d, s4_6d, s4_7d, s4_8d;
    reg s5_1d, s5_2d, s5_3d, s5_4d, s5_5d, s5_6d;
    reg s6_1d, s6_2d, s6_3d, s6_4d;
    reg s7_1d, s7_2d;

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_1 

    // Thread-local variables
    wire s11_next, c11_next;

    assign s11_next = (!(A1 && B1)) && (A1 || B1);
    assign c11_next = A1 && B1;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_1_ff
        if ( ~rstn ) begin
            s11 <= 1'd0;
            c11 <= 1'd0;            
            cin_1d <= 1'd0;

            a2_1d <= 1'd0;
            b2_1d <= 1'd0;
            a3_1d <= 1'd0;
            b3_1d <= 1'd0;
            a4_1d <= 1'd0;
            b4_1d <= 1'd0;
            b5_1d <= 1'd0;
            a5_1d <= 1'd0;
            b6_1d <= 1'd0;
            a6_1d <= 1'd0;
            b7_1d <= 1'd0;
            a7_1d <= 1'd0;
            b8_1d <= 1'd0;
            a8_1d <= 1'd0;
        end else begin
            s11 <= s11_next;
            c11 <= c11_next;
            cin_1d <= Cin;

            //Delay Inputs
            a2_1d <= A2;
            b2_1d <= B2;
            a3_1d <= A3;
            b3_1d <= B3;
            a4_1d <= A4;
            b4_1d <= B4;
            b5_1d <= B5;
            a5_1d <= A5;
            b6_1d <= B6;
            a6_1d <= A6;
            b7_1d <= B7;
            a7_1d <= A7;
            b8_1d <= B8;
            a8_1d <= A8;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_1 

    
    // Thread-local variables
    wire s1_next, c1_next;

    assign s1_next = (!(s11 && cin_1d)) && (s11 || cin_1d);
    assign c1_next = c11 || (s11 && cin_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_1_ff
        if ( ~rstn ) begin
            s1 <= 1'd0;
            c1 <= 1'd0;

            a2_2d <= 1'd0;
            b2_2d <= 1'd0;
            a3_2d <= 1'd0;
            b3_2d <= 1'd0;
            a4_2d <= 1'd0;
            b4_2d <= 1'd0;
            a5_2d <= 1'd0;
            b5_2d <= 1'd0;
            a6_2d <= 1'd0;
            b6_2d <= 1'd0;
            a7_2d <= 1'd0;
            b7_2d <= 1'd0;
            a8_2d <= 1'd0;
            b8_2d <= 1'd0;
        end else begin
            s1 <= s1_next;
            c1 <= c1_next;  
            
            //Delay Inputs
            a2_2d <= a2_1d;
            b2_2d <= b2_1d;
            a3_2d <= a3_1d;
            b3_2d <= b3_1d;
            a4_2d <= a4_1d;
            b4_2d <= b4_1d;
            a5_2d <= a5_1d;
            b5_2d <= b5_1d;
            a6_2d <= a6_1d;
            b6_2d <= b6_1d;
            a7_2d <= a7_1d;
            b7_2d <= b7_1d;
            a8_2d <= a8_1d;
            b8_2d <= b8_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_2 

    // Thread-local variables
    wire s21_next, c21_next;

    assign s21_next = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
    assign c21_next = a2_2d && b2_2d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) 
    begin : ha_2_ff
        if ( ~rstn ) begin
            s21 <= 1'd0;
            c21 <= 1'd0;
            c1_1d <= 1'd0;

            a3_3d <= 1'd0;
            b3_3d <= 1'd0;
            a4_3d <= 1'd0;
            b4_3d <= 1'd0;
            a5_3d <= 1'd0;
            b5_3d <= 1'd0;
            a6_3d <= 1'd0;
            b6_3d <= 1'd0;
            a7_3d <= 1'd0;
            b7_3d <= 1'd0;
            a8_3d <= 1'd0;
            b8_3d <= 1'd0;
            s1_1d <= 1'd0;
        end else begin
            s21 <= s21_next;
            c21 <= c21_next;
            c1_1d <= c1;

            //Delay Inputs
            a3_3d <= a3_2d;
            b3_3d <= b3_2d;
            a4_3d <= a4_2d;
            b4_3d <= b4_2d;
            a5_3d <= a5_2d;
            b5_3d <= b5_2d;
            a6_3d <= a6_2d;
            b6_3d <= b6_2d;
            a7_3d <= a7_2d;
            b7_3d <= b7_2d;
            a8_3d <= a8_2d;
            b8_3d <= b8_2d;
            
            //Delay Outputs
            s1_1d <= s1;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_2 

    // Thread-local variables
    wire s2_next, c2_next;

    assign s2_next = (!(s21 && c1_1d)) && (s21 || c1_1d);
    assign c2_next = c21 || (s21 && c1_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_2_ff
        if ( ~rstn ) begin
            s2 <= 1'd0;
            c2 <= 1'd0;
            
            a3_4d <= 1'd0;
            b3_4d <= 1'd0;
            a4_4d <= 1'd0;
            b4_4d <= 1'd0;
            a5_4d <= 1'd0;
            b5_4d <= 1'd0;
            a6_4d <= 1'd0;
            b6_4d <= 1'd0;
            a7_4d <= 1'd0;
            b7_4d <= 1'd0;
            a8_4d <= 1'd0;
            b8_4d <= 1'd0;
            s1_2d <= 1'd0;
        end else begin
            s2 <= s2_next;
            c2 <= c2_next;
            
            //Delay Inputs
            a3_4d <= a3_3d;
            b3_4d <= b3_3d;
            a4_4d <= a4_3d;
            b4_4d <= b4_3d;
            a5_4d <= a5_3d;
            b5_4d <= b5_3d;
            a6_4d <= a6_3d;
            b6_4d <= b6_3d;
            a7_4d <= a7_3d;
            b7_4d <= b7_3d;
            a8_4d <= a8_3d;
            b8_4d <= b8_3d;

            //Delay Outputs
            s1_2d <= s1_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_3 

    // Thread-local variables
    wire s31_next, c31_next;

    assign s31_next = (!(a3_4d && b3_4d)) && (a3_4d || b3_4d);
    assign c31_next = a3_4d && b3_4d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_3_ff
        if ( ~rstn ) begin
            s31 <= 1'd0;
            c31 <= 1'd0;
            c2_1d <= 1'd0;

            a4_5d <= 1'd0;
            b4_5d <= 1'd0;
            a5_5d <= 1'd0;
            b5_5d <= 1'd0;
            a6_5d <= 1'd0;
            b6_5d <= 1'd0;
            a7_5d <= 1'd0;
            b7_5d <= 1'd0;
            a8_5d <= 1'd0;
            b8_5d <= 1'd0;
            s1_3d <= 1'd0;
            s2_1d <= 1'd0;
        end else begin
            s31 <= s31_next;
            c31 <= c31_next;
            c2_1d <= c2;

            //Delay Inputs
            a4_5d <= a4_4d;
            b4_5d <= b4_4d;
            a5_5d <= a5_4d;
            b5_5d <= b5_4d;
            a6_5d <= a6_4d;
            b6_5d <= b6_4d;
            a7_5d <= a7_4d;
            b7_5d <= b7_4d;
            a8_5d <= a8_4d;
            b8_5d <= b8_4d;

            //Delay Outputs
            s1_3d <= s1_2d;
            s2_1d <= s2;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_3 

    // Thread-local variables
    wire s3_next, c3_next;
    
    assign s3_next = (!(s31 && c2_1d)) && (s31 || c2_1d);
    assign c3_next = c31 || (s31 && c2_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_3_ff
        if ( ~rstn ) begin
            s3 <= 1'd0;
            c3 <= 1'd0;

            a4_6d <= 1'd0;
            b4_6d <= 1'd0;
            a5_6d <= 1'd0;
            b5_6d <= 1'd0;
            a6_6d <= 1'd0;
            b6_6d <= 1'd0;
            a7_6d <= 1'd0;
            b7_6d <= 1'd0;
            a8_6d <= 1'd0;
            b8_6d <= 1'd0;
            s1_4d <= 1'd0;
            s2_2d <= 1'd0;
        end else begin
            s3 <= s3_next;
            c3 <= c3_next;

            //Delay Inputs
            a4_6d <= a4_5d;
            b4_6d <= b4_5d;
            a5_6d <= a5_5d;
            b5_6d <= b5_5d;
            a6_6d <= a6_5d;
            b6_6d <= b6_5d;
            a7_6d <= a7_5d;
            b7_6d <= b7_5d;
            a8_6d <= a8_5d;
            b8_6d <= b8_5d;

            //Delay Outputs
            s1_4d <= s1_3d;
            s2_2d <= s2_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_4  

    // Thread-local variables
    wire s41_next, c41_next;
    
    assign s41_next = (!(a4_6d && b4_6d)) && (a4_6d || b4_6d);
    assign c41_next = a4_6d && b4_6d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_4_ff
        if ( ~rstn ) begin
            s41 <= 1'd0;
            c41 <= 1'd0;
            c3_1d <= 1'd0;
            a5_7d <= 1'd0;
            b5_7d <= 1'd0;
            a6_7d <= 1'd0;
            b6_7d <= 1'd0;
            a7_7d <= 1'd0;
            b7_7d <= 1'd0;
            a8_7d <= 1'd0;
            b8_7d <= 1'd0;
            s1_5d <= 1'd0;
            s2_3d <= 1'd0;
            s3_1d <= 1'd0;
        end else begin
            s41 <= s41_next;
            c41 <= c41_next;
            c3_1d <= c3;

            //Delay Inputs
            a5_7d <= a5_6d;
            b5_7d <= b5_6d;
            a6_7d <= a6_6d;
            b6_7d <= b6_6d;
            a7_7d <= a7_6d;
            b7_7d <= b7_6d;
            a8_7d <= a8_6d;
            b8_7d <= b8_6d;

            //Delay Outputs
            s1_5d <= s1_4d;
            s2_3d <= s2_2d;
            s3_1d <= s3;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_4 

    // Thread-local variables
    wire s4_next, c4_next;
    
    assign s4_next = (!(s41 && c3_1d)) && (s41 || c3_1d);
    assign c4_next = c41 || (s41 && c3_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) 
    begin : fa_4_ff
        if ( ~rstn ) begin
            s4 <= 1'd0;
            c4 <= 1'd0;
            a5_8d <= 1'd0;
            b5_8d <= 1'd0;
            a6_8d <= 1'd0;
            b6_8d <= 1'd0;
            a7_8d <= 1'd0;
            b7_8d <= 1'd0;
            a8_8d <= 1'd0;
            b8_8d <= 1'd0;
            s1_6d <= 1'd0;
            s2_4d <= 1'd0;
            s3_2d <= 1'd0;
        end
        else begin
            s4 <= s4_next;
            c4 <= c4_next;

            //Delay Inputs
            a5_8d <= a5_7d;
            b5_8d <= b5_7d;
            a6_8d <= a6_7d;
            b6_8d <= b6_7d;
            a7_8d <= a7_7d;
            b7_8d <= b7_7d;
            a8_8d <= a8_7d;
            b8_8d <= b8_7d;

            //Delay Outputs
            s1_6d <= s1_5d;
            s2_4d <= s2_3d;
            s3_2d <= s3_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_5 

    // Thread-local variables
    wire s51_next, c51_next;

    assign s51_next = (!(a5_8d && b5_8d)) && (a5_8d || b5_8d);
    assign c51_next = a5_8d && b5_8d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_5_ff
        if ( ~rstn ) begin
            s51 <= 1'd0;
            c51 <= 1'd0;
            c4_1d <= 1'd0;

            a6_9d <= 1'd0;
            b6_9d <= 1'd0;
            a7_9d <= 1'd0;
            b7_9d <= 1'd0;
            a8_9d <= 1'd0;
            b8_9d <= 1'd0;
            s1_7d <= 1'd0;
            s2_5d <= 1'd0;
            s3_3d <= 1'd0;
            s4_1d <= 1'd0;
        end else begin
            s51 <= s51_next;
            c51 <= c51_next;
            c4_1d <= c4;

            //Delay inputs
            a6_9d <= a6_8d;
            b6_9d <= b6_8d;
            a7_9d <= a7_8d;
            b7_9d <= b7_8d;
            a8_9d <= a8_8d;
            b8_9d <= b8_8d;

            //Delay outputs
            s1_7d <= s1_6d;
            s2_5d <= s2_4d;
            s3_3d <= s3_2d;
            s4_1d <= s4;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_5 

    // Thread-local variables
    wire s5_next, c5_next;

    assign s5_next = (!(s51 && c4_1d)) && (s51 || c4_1d);
    assign c5_next = c51 || (s51 && c4_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_5_ff
        if ( ~rstn ) begin
            s5 <= 1'd0;
            c5 <= 1'd0;

            a6_10d <= 1'd0;
            b6_10d <= 1'd0;
            a7_10d <= 1'd0;
            b7_10d <= 1'd0;
            a8_10d <= 1'd0;
            b8_10d <= 1'd0;
            s1_8d <= 1'd0;
            s2_6d <= 1'd0;
            s3_4d <= 1'd0;
            s4_2d <= 1'd0;
        end else begin
            s5 <= s5_next;
            c5 <= c5_next;
      
            //Delay inputs
            a6_10d <= a6_9d;
            b6_10d <= b6_9d;
            a7_10d <= a7_9d;
            b7_10d <= b7_9d;
            a8_10d <= a8_9d;
            b8_10d <= b8_9d;

            //Delay OUTputs
            s1_8d <= s1_7d;
            s2_6d <= s2_5d;
            s3_4d <= s3_3d;
            s4_2d <= s4_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_6  

    // Thread-local variables
    wire s61_next, c61_next;

    assign s61_next = (!(a6_10d && b6_10d)) && (a6_10d || b6_10d);
    assign c61_next = a6_10d && b6_10d;
        

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_6_ff
        if ( ~rstn ) begin
            s61 <= 1'd0;
            c61 <= 1'd0;
            c5_1d  <= 1'd0;

            a7_11d <= 1'd0;
            b7_11d <= 1'd0;
            a8_11d <= 1'd0;
            b8_11d <= 1'd0;
            s1_9d <= 1'd0;
            s2_7d <= 1'd0;
            s3_5d <= 1'd0;
            s4_3d <= 1'd0;
            s5_1d <= 1'd0;
        end else begin
            s61 <= s61_next;
            c61 <= c61_next;
            c5_1d <= c5;

            //Delay inputs
            a7_11d <= a7_10d;
            b7_11d <= b7_10d;
            a8_11d <= a8_10d;
            b8_11d <= b8_10d;

            //Delay output
            s1_9d <= s1_8d;
            s2_7d <= s2_6d;
            s3_5d <= s3_4d;
            s4_3d <= s4_2d;
            s5_1d <= s5;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_6  

    // Thread-local variables
    wire s6_next, c6_next;

    assign s6_next = (!(s61 && c5_1d)) && (s61 || c5_1d);
    assign c6_next = c61 || (s61 && c5_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_6_ff
        if ( ~rstn ) begin
            s6 <= 1'd0;
            c6 <= 1'd0;
            a7_12d <= 1'd0;
            b7_12d <= 1'd0;
            a8_12d <= 1'd0;
            b8_12d <= 1'd0;
            s1_10d <= 1'd0;
            s2_8d <= 1'd0;
            s3_6d <= 1'd0;
            s4_4d <= 1'd0;
            s5_2d <= 1'd0;
        end else begin
            s6 <= s6_next;
            c6 <= c6_next;

            //Delay inputs
            a7_12d <= a7_11d;
            b7_12d <= b7_11d;
            a8_12d <= a8_11d;
            b8_12d <= b8_11d;

            //Delay output
            s1_10d <= s1_9d;
            s2_8d  <= s2_7d;
            s3_6d  <= s3_5d;
            s4_4d  <= s4_3d;
            s5_2d  <= s5_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_7  

    // Thread-local variables
    wire s71_next, c71_next;
    
    assign s71_next = (!(a7_12d && b7_12d)) && (a7_12d || b7_12d);
    assign c71_next = a7_12d && b7_12d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_7_ff
        if ( ~rstn ) begin
            s71 <= 1'd0;
            c71 <= 1'd0;
            c6_1d <=  1'd0;
            a8_13d <= 1'd0;
            b8_13d <= 1'd0;
            s1_11d <= 1'd0;
            s2_9d <= 1'd0;
            s3_7d <= 1'd0;
            s4_5d <= 1'd0;
            s5_3d <= 1'd0;
            s6_1d <= 1'd0;
        end else begin
            s71 <= s71_next;
            c71 <= c71_next;
            c6_1d <= c6;

            //Delay inputs
            a8_13d <= a8_12d;
            b8_13d <= b8_12d;

            //Delay output
            s1_11d <= s1_10d;
            s2_9d  <= s2_8d;
            s3_7d  <= s3_6d;
            s4_5d  <= s4_4d;
            s5_3d  <= s5_2d;
            s6_1d  <= s6;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_7 

    // Thread-local variables
    wire s7_next, c7_next;

    assign s7_next = (!(s71 && c6_1d)) && (s71 || c6_1d);
    assign c7_next = c71 || (s71 && c6_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_7_ff
        if ( ~rstn ) begin
            s7 <= 1'd0;
            c7 <= 1'd0;
            a8_14d <= 1'd0;
            b8_14d <= 1'd0;
            s1_12d <= 1'd0;
            s2_10d <= 1'd0;
            s3_8d <= 1'd0;
            s4_6d <= 1'd0;
            s5_4d <= 1'd0;
            s6_2d <= 1'd0;
        end else begin
            s7 <= s7_next;
            c7 <= c7_next;

            //Delay inputs
            a8_14d <= a8_13d;
            b8_14d <= b8_13d;

            //Delay output
            s1_12d <= s1_11d;
            s2_10d <= s2_9d;
            s3_8d  <= s3_7d;
            s4_6d  <= s4_5d;
            s5_4d  <= s5_3d;
            s6_2d  <= s6_1d;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_8 

    // Thread-local variables
    wire s81_next, c81_next;

    assign s81_next = (!(a8_14d && b8_14d)) && (a8_14d || b8_14d);
    assign c81_next = a8_14d && b8_14d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_8_ff
        if ( ~rstn ) begin
            s81 <= 1'd0;
            c81 <= 1'd0;
            c7_1d <=  1'd0;
            s1_13d <= 1'd0;
            s2_11d <= 1'd0;
            s3_9d <= 1'd0;
            s4_7d <= 1'd0;
            s5_5d <= 1'd0;
            s6_3d <= 1'd0;
            s7_1d <= 1'd0;
        end else begin
            s81 <= s81_next;
            c81 <= c81_next;
            c7_1d <= c7;

            //Delay output
            s1_13d <= s1_12d;
            s2_11d <= s2_10d;
            s3_9d  <= s3_8d;
            s4_7d  <= s4_6d;
            s5_5d  <= s5_4d;
            s6_3d  <= s6_2d;
            s7_1d  <= s7;
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: fa_8 (bit8_adder.h:434:3) 

    // Thread-local variables
    wire s8_next, c8_next;

    assign s8_next = (!(s81 && c7_1d)) && (s81 || c7_1d);
    assign c8_next = c81 || (s81 && c7_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_8_ff
        if ( ~rstn ) begin
            s8 <= 1'd0;
            c8 <= 1'd0;

            s1_14d <= 1'd0;
            s2_12d <= 1'd0;
            s3_10d <= 1'd0;
            s4_8d <= 1'd0;
            s5_6d <= 1'd0;
            s6_4d <= 1'd0;
            s7_2d <= 1'd0;
        end else begin
            s8 <= s8_next;
            c8 <= c8_next;

            //Delay output
            s1_14d = s1_13d;
            s2_12d = s2_11d;
            s3_10d = s3_9d;
            s4_8d  = s4_7d;
            s5_6d  = s5_5d;
            s6_4d  = s6_3d;
            s7_2d  = s7_1d;
        end
    end

    assign S1 = s1_14d;
    assign S2 = s2_12d;
    assign S3 = s3_10d;
    assign S4 = s4_8d;
    assign S5 = s5_6d;
    assign S6 = s6_4d;
    assign S7 = s7_2d;
    assign S8 = s8;
    assign Cout = c8;
    
`ifdef FORMAL
        reg f_A1_1d, f_A1_2d, f_A1_3d, f_A1_4d, f_A1_5d, f_A1_6d, f_A1_7d, f_A1_8d, f_A1_9d, f_A1_10d, f_A1_11d, f_A1_12d, f_A1_13d, f_A1_14d, f_A1_15d, f_A1_16d; 
        reg f_A2_1d, f_A2_2d, f_A2_3d, f_A2_4d, f_A2_5d, f_A2_6d, f_A2_7d, f_A2_8d, f_A2_9d, f_A2_10d, f_A2_11d, f_A2_12d, f_A2_13d, f_A2_14d, f_A2_15d, f_A2_16d; 
        reg f_A3_1d, f_A3_2d, f_A3_3d, f_A3_4d, f_A3_5d, f_A3_6d, f_A3_7d, f_A3_8d, f_A3_9d, f_A3_10d, f_A3_11d, f_A3_12d, f_A3_13d, f_A3_14d, f_A3_15d, f_A3_16d; 
        reg f_A4_1d, f_A4_2d, f_A4_3d, f_A4_4d, f_A4_5d, f_A4_6d, f_A4_7d, f_A4_8d, f_A4_9d, f_A4_10d, f_A4_11d, f_A4_12d, f_A4_13d, f_A4_14d, f_A4_15d, f_A4_16d; 
        reg f_A5_1d, f_A5_2d, f_A5_3d, f_A5_4d, f_A5_5d, f_A5_6d, f_A5_7d, f_A5_8d, f_A5_9d, f_A5_10d, f_A5_11d, f_A5_12d, f_A5_13d, f_A5_14d, f_A5_15d, f_A5_16d; 
        reg f_A6_1d, f_A6_2d, f_A6_3d, f_A6_4d, f_A6_5d, f_A6_6d, f_A6_7d, f_A6_8d, f_A6_9d, f_A6_10d, f_A6_11d, f_A6_12d, f_A6_13d, f_A6_14d, f_A6_15d, f_A6_16d; 
        reg f_A7_1d, f_A7_2d, f_A7_3d, f_A7_4d, f_A7_5d, f_A7_6d, f_A7_7d, f_A7_8d, f_A7_9d, f_A7_10d, f_A7_11d, f_A7_12d, f_A7_13d, f_A7_14d, f_A7_15d, f_A7_16d; 
        reg f_A8_1d, f_A8_2d, f_A8_3d, f_A8_4d, f_A8_5d, f_A8_6d, f_A8_7d, f_A8_8d, f_A8_9d, f_A8_10d, f_A8_11d, f_A8_12d, f_A8_13d, f_A8_14d, f_A8_15d, f_A8_16d; 

        reg f_B1_1d, f_B1_2d, f_B1_3d, f_B1_4d, f_B1_5d, f_B1_6d, f_B1_7d, f_B1_8d, f_B1_9d, f_B1_10d, f_B1_11d, f_B1_12d, f_B1_13d, f_B1_14d, f_B1_15d, f_B1_16d; 
        reg f_B2_1d, f_B2_2d, f_B2_3d, f_B2_4d, f_B2_5d, f_B2_6d, f_B2_7d, f_B2_8d, f_B2_9d, f_B2_10d, f_B2_11d, f_B2_12d, f_B2_13d, f_B2_14d, f_B2_15d, f_B2_16d; 
        reg f_B3_1d, f_B3_2d, f_B3_3d, f_B3_4d, f_B3_5d, f_B3_6d, f_B3_7d, f_B3_8d, f_B3_9d, f_B3_10d, f_B3_11d, f_B3_12d, f_B3_13d, f_B3_14d, f_B3_15d, f_B3_16d; 
        reg f_B4_1d, f_B4_2d, f_B4_3d, f_B4_4d, f_B4_5d, f_B4_6d, f_B4_7d, f_B4_8d, f_B4_9d, f_B4_10d, f_B4_11d, f_B4_12d, f_B4_13d, f_B4_14d, f_B4_15d, f_B4_16d; 
        reg f_B5_1d, f_B5_2d, f_B5_3d, f_B5_4d, f_B5_5d, f_B5_6d, f_B5_7d, f_B5_8d, f_B5_9d, f_B5_10d, f_B5_11d, f_B5_12d, f_B5_13d, f_B5_14d, f_B5_15d, f_B5_16d; 
        reg f_B6_1d, f_B6_2d, f_B6_3d, f_B6_4d, f_B6_5d, f_B6_6d, f_B6_7d, f_B6_8d, f_B6_9d, f_B6_10d, f_B6_11d, f_B6_12d, f_B6_13d, f_B6_14d, f_B6_15d, f_B6_16d; 
        reg f_B7_1d, f_B7_2d, f_B7_3d, f_B7_4d, f_B7_5d, f_B7_6d, f_B7_7d, f_B7_8d, f_B7_9d, f_B7_10d, f_B7_11d, f_B7_12d, f_B7_13d, f_B7_14d, f_B7_15d, f_B7_16d; 
        reg f_B8_1d, f_B8_2d, f_B8_3d, f_B8_4d, f_B8_5d, f_B8_6d, f_B8_7d, f_B8_8d, f_B8_9d, f_B8_10d, f_B8_11d, f_B8_12d, f_B8_13d, f_B8_14d, f_B8_15d, f_B8_16d;   

		reg f_Cin_1d, F_Cin_2d, f_Cin_3d, F_Cin_4d, f_Cin_5d, F_Cin_6d, f_Cin_7d, F_Cin_8d, f_Cin_9d, F_Cin_10d, f_Cin_11d, F_Cin_12d, f_Cin_13d, F_Cin_14d, f_Cin_15d, f_Cin_16d;

        reg [2:0] f_sum1, f_sum2, f_sum3, f_sum4, f_sum5, f_sum6, f_sum7, f_sum8;

        reg [4:0] f_counter = 1'd0;
        
        //The resut is delay in 8 cicle
        reg f_valid_16d = 1'b0;

        assign f_sum1 = f_A1_16d + f_B1_16d + f_Cin_16d;
        assign f_sum2 = f_A2_16d + f_B2_16d + ( (f_sum1 >= 2) ? 1 : 0 );
        assign f_sum3 = f_A3_16d + f_B3_16d + ( (f_sum2 >= 2) ? 1 : 0 );
        assign f_sum4 = f_A4_16d + f_B4_16d + ( (f_sum3 >= 2) ? 1 : 0 );
        assign f_sum5 = f_A5_16d + f_B5_16d + ( (f_sum4 >= 2) ? 1 : 0 );
        assign f_sum6 = f_A6_16d + f_B6_16d + ( (f_sum5 >= 2) ? 1 : 0 );
        assign f_sum7 = f_A7_16d + f_B7_16d + ( (f_sum6 >= 2) ? 1 : 0 );
        assign f_sum8 = f_A8_16d + f_B8_16d + ( (f_sum7 >= 2) ? 1 : 0 );

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_valid_16d <= 1'd0;
                f_counter <= 1'd0;
			end else begin
				f_A1_1d  <=   A1    ;    f_A2_1d  <=   A2    ;     f_A3_1d  <=   A3    ;    f_A4_1d  <=   A4    ;  
				f_A1_2d  <= f_A1_1d ;    f_A2_2d  <= f_A2_1d ;     f_A3_2d  <= f_A3_1d ;    f_A4_2d  <= f_A4_1d ;   
				f_A1_3d  <= f_A1_2d ;    f_A2_3d  <= f_A2_2d ;     f_A3_3d  <= f_A3_2d ;    f_A4_3d  <= f_A4_2d ;   
				f_A1_4d  <= f_A1_3d ;    f_A2_4d  <= f_A2_3d ;     f_A3_4d  <= f_A3_3d ;    f_A4_4d  <= f_A4_3d ;   
				f_A1_5d  <= f_A1_4d ;    f_A2_5d  <= f_A2_4d ;     f_A3_5d  <= f_A3_4d ;    f_A4_5d  <= f_A4_4d ;   
				f_A1_6d  <= f_A1_5d ;    f_A2_6d  <= f_A2_5d ;     f_A3_6d  <= f_A3_5d ;    f_A4_6d  <= f_A4_5d ;   
				f_A1_7d  <= f_A1_6d ;    f_A2_7d  <= f_A2_6d ;     f_A3_7d  <= f_A3_6d ;    f_A4_7d  <= f_A4_6d ;   
				f_A1_8d  <= f_A1_7d ;    f_A2_8d  <= f_A2_7d ;     f_A3_8d  <= f_A3_7d ;    f_A4_8d  <= f_A4_7d ;   
                f_A1_9d  <= f_A1_8d ;    f_A2_9d  <= f_A2_8d ;     f_A3_9d  <= f_A3_8d ;    f_A4_9d  <= f_A4_8d ;  
                f_A1_10d <= f_A1_9d ;    f_A2_10d <= f_A2_9d ;     f_A3_10d <= f_A3_9d ;    f_A4_10d <= f_A4_9d ;  
                f_A1_11d <= f_A1_10d;    f_A2_11d <= f_A2_10d;     f_A3_11d <= f_A3_10d;    f_A4_11d <= f_A4_10d;  
                f_A1_12d <= f_A1_11d;    f_A2_12d <= f_A2_11d;     f_A3_12d <= f_A3_11d;    f_A4_12d <= f_A4_11d;  
                f_A1_13d <= f_A1_12d;    f_A2_13d <= f_A2_12d;     f_A3_13d <= f_A3_12d;    f_A4_13d <= f_A4_12d;  
                f_A1_14d <= f_A1_13d;    f_A2_14d <= f_A2_13d;     f_A3_14d <= f_A3_13d;    f_A4_14d <= f_A4_13d;  
                f_A1_15d <= f_A1_14d;    f_A2_15d <= f_A2_14d;     f_A3_15d <= f_A3_14d;    f_A4_15d <= f_A4_14d;  
                f_A1_16d <= f_A1_15d;    f_A2_16d <= f_A2_15d;     f_A3_16d <= f_A3_15d;    f_A4_16d <= f_A4_15d;  

				f_A5_1d  <=   A5    ;    f_A6_1d  <=   A6    ;     f_A7_1d  <=   A7    ;    f_A8_1d  <=   A8    ;  
				f_A5_2d  <= f_A5_1d ;    f_A6_2d  <= f_A6_1d ;     f_A7_2d  <= f_A7_1d ;    f_A8_2d  <= f_A8_1d ;   
				f_A5_3d  <= f_A5_2d ;    f_A6_3d  <= f_A6_2d ;     f_A7_3d  <= f_A7_2d ;    f_A8_3d  <= f_A8_2d ;   
				f_A5_4d  <= f_A5_3d ;    f_A6_4d  <= f_A6_3d ;     f_A7_4d  <= f_A7_3d ;    f_A8_4d  <= f_A8_3d ;   
				f_A5_5d  <= f_A5_4d ;    f_A6_5d  <= f_A6_4d ;     f_A7_5d  <= f_A7_4d ;    f_A8_5d  <= f_A8_4d ;   
				f_A5_6d  <= f_A5_5d ;    f_A6_6d  <= f_A6_5d ;     f_A7_6d  <= f_A7_5d ;    f_A8_6d  <= f_A8_5d ;   
				f_A5_7d  <= f_A5_6d ;    f_A6_7d  <= f_A6_6d ;     f_A7_7d  <= f_A7_6d ;    f_A8_7d  <= f_A8_6d ;   
				f_A5_8d  <= f_A5_7d ;    f_A6_8d  <= f_A6_7d ;     f_A7_8d  <= f_A7_7d ;    f_A8_8d  <= f_A8_7d ;   
                f_A5_9d  <= f_A5_8d ;    f_A6_9d  <= f_A6_8d ;     f_A7_9d  <= f_A7_8d ;    f_A8_9d  <= f_A8_8d ;  
                f_A5_10d <= f_A5_9d ;    f_A6_10d <= f_A6_9d ;     f_A7_10d <= f_A7_9d ;    f_A8_10d <= f_A8_9d ;  
                f_A5_11d <= f_A5_10d;    f_A6_11d <= f_A6_10d;     f_A7_11d <= f_A7_10d;    f_A8_11d <= f_A8_10d;  
                f_A5_12d <= f_A5_11d;    f_A6_12d <= f_A6_11d;     f_A7_12d <= f_A7_11d;    f_A8_12d <= f_A8_11d;  
                f_A5_13d <= f_A5_12d;    f_A6_13d <= f_A6_12d;     f_A7_13d <= f_A7_12d;    f_A8_13d <= f_A8_12d;  
                f_A5_14d <= f_A5_13d;    f_A6_14d <= f_A6_13d;     f_A7_14d <= f_A7_13d;    f_A8_14d <= f_A8_13d;  
                f_A5_15d <= f_A5_14d;    f_A6_15d <= f_A6_14d;     f_A7_15d <= f_A7_14d;    f_A8_15d <= f_A8_14d;  
                f_A5_16d <= f_A5_15d;    f_A6_16d <= f_A6_15d;     f_A7_16d <= f_A7_15d;    f_A8_16d <= f_A8_15d;  		
				
				f_B1_1d  <=   B1    ;    f_B2_1d  <=   B2    ;     f_B3_1d  <=   B3    ;    f_B4_1d  <=   B4    ;  
				f_B1_2d  <= f_B1_1d ;    f_B2_2d  <= f_B2_1d ;     f_B3_2d  <= f_B3_1d ;    f_B4_2d  <= f_B4_1d ;   
				f_B1_3d  <= f_B1_2d ;    f_B2_3d  <= f_B2_2d ;     f_B3_3d  <= f_B3_2d ;    f_B4_3d  <= f_B4_2d ;   
				f_B1_4d  <= f_B1_3d ;    f_B2_4d  <= f_B2_3d ;     f_B3_4d  <= f_B3_3d ;    f_B4_4d  <= f_B4_3d ;   
				f_B1_5d  <= f_B1_4d ;    f_B2_5d  <= f_B2_4d ;     f_B3_5d  <= f_B3_4d ;    f_B4_5d  <= f_B4_4d ;   
				f_B1_6d  <= f_B1_5d ;    f_B2_6d  <= f_B2_5d ;     f_B3_6d  <= f_B3_5d ;    f_B4_6d  <= f_B4_5d ;   
				f_B1_7d  <= f_B1_6d ;    f_B2_7d  <= f_B2_6d ;     f_B3_7d  <= f_B3_6d ;    f_B4_7d  <= f_B4_6d ;   
				f_B1_8d  <= f_B1_7d ;    f_B2_8d  <= f_B2_7d ;     f_B3_8d  <= f_B3_7d ;    f_B4_8d  <= f_B4_7d ;   
                f_B1_9d  <= f_B1_8d ;    f_B2_9d  <= f_B2_8d ;     f_B3_9d  <= f_B3_8d ;    f_B4_9d  <= f_B4_8d ;  
                f_B1_10d <= f_B1_9d ;    f_B2_10d <= f_B2_9d ;     f_B3_10d <= f_B3_9d ;    f_B4_10d <= f_B4_9d ;  
                f_B1_11d <= f_B1_10d;    f_B2_11d <= f_B2_10d;     f_B3_11d <= f_B3_10d;    f_B4_11d <= f_B4_10d;  
                f_B1_12d <= f_B1_11d;    f_B2_12d <= f_B2_11d;     f_B3_12d <= f_B3_11d;    f_B4_12d <= f_B4_11d;  
                f_B1_13d <= f_B1_12d;    f_B2_13d <= f_B2_12d;     f_B3_13d <= f_B3_12d;    f_B4_13d <= f_B4_12d;  
                f_B1_14d <= f_B1_13d;    f_B2_14d <= f_B2_13d;     f_B3_14d <= f_B3_13d;    f_B4_14d <= f_B4_13d;  
                f_B1_15d <= f_B1_14d;    f_B2_15d <= f_B2_14d;     f_B3_15d <= f_B3_14d;    f_B4_15d <= f_B4_14d;  
                f_B1_16d <= f_B1_15d;    f_B2_16d <= f_B2_15d;     f_B3_16d <= f_B3_15d;    f_B4_16d <= f_B4_15d;  

                f_B5_1d  <=   B5    ;    f_B6_1d  <=   B6    ;     f_B7_1d  <=   B7    ;    f_B8_1d  <=   B8    ;  
				f_B5_2d  <= f_B5_1d ;    f_B6_2d  <= f_B6_1d ;     f_B7_2d  <= f_B7_1d ;    f_B8_2d  <= f_B8_1d ;   
				f_B5_3d  <= f_B5_2d ;    f_B6_3d  <= f_B6_2d ;     f_B7_3d  <= f_B7_2d ;    f_B8_3d  <= f_B8_2d ;   
				f_B5_4d  <= f_B5_3d ;    f_B6_4d  <= f_B6_3d ;     f_B7_4d  <= f_B7_3d ;    f_B8_4d  <= f_B8_3d ;   
				f_B5_5d  <= f_B5_4d ;    f_B6_5d  <= f_B6_4d ;     f_B7_5d  <= f_B7_4d ;    f_B8_5d  <= f_B8_4d ;   
				f_B5_6d  <= f_B5_5d ;    f_B6_6d  <= f_B6_5d ;     f_B7_6d  <= f_B7_5d ;    f_B8_6d  <= f_B8_5d ;   
				f_B5_7d  <= f_B5_6d ;    f_B6_7d  <= f_B6_6d ;     f_B7_7d  <= f_B7_6d ;    f_B8_7d  <= f_B8_6d ;   
				f_B5_8d  <= f_B5_7d ;    f_B6_8d  <= f_B6_7d ;     f_B7_8d  <= f_B7_7d ;    f_B8_8d  <= f_B8_7d ;   
                f_B5_9d  <= f_B5_8d ;    f_B6_9d  <= f_B6_8d ;     f_B7_9d  <= f_B7_8d ;    f_B8_9d  <= f_B8_8d ;  
                f_B5_10d <= f_B5_9d ;    f_B6_10d <= f_B6_9d ;     f_B7_10d <= f_B7_9d ;    f_B8_10d <= f_B8_9d ;  
                f_B5_11d <= f_B5_10d;    f_B6_11d <= f_B6_10d;     f_B7_11d <= f_B7_10d;    f_B8_11d <= f_B8_10d;  
                f_B5_12d <= f_B5_11d;    f_B6_12d <= f_B6_11d;     f_B7_12d <= f_B7_11d;    f_B8_12d <= f_B8_11d;  
                f_B5_13d <= f_B5_12d;    f_B6_13d <= f_B6_12d;     f_B7_13d <= f_B7_12d;    f_B8_13d <= f_B8_12d;  
                f_B5_14d <= f_B5_13d;    f_B6_14d <= f_B6_13d;     f_B7_14d <= f_B7_13d;    f_B8_14d <= f_B8_13d;  
                f_B5_15d <= f_B5_14d;    f_B6_15d <= f_B6_14d;     f_B7_15d <= f_B7_14d;    f_B8_15d <= f_B8_14d;  
                f_B5_16d <= f_B5_15d;    f_B6_16d <= f_B6_15d;     f_B7_16d <= f_B7_15d;    f_B8_16d <= f_B8_15d;  	

				f_Cin_1d  <=   Cin    ;
                f_Cin_2d  <= f_Cin_1d ;
                f_Cin_3d  <= f_Cin_2d ;
                f_Cin_4d  <= f_Cin_3d ;
                f_Cin_5d  <= f_Cin_4d ;
                f_Cin_6d  <= f_Cin_5d ;
                f_Cin_7d  <= f_Cin_6d ;
                f_Cin_8d  <= f_Cin_7d ;
                f_Cin_9d  <= f_Cin_8d ;
                f_Cin_10d <= f_Cin_9d ;
                f_Cin_11d <= f_Cin_10d;
                f_Cin_12d <= f_Cin_11d;
                f_Cin_13d <= f_Cin_12d;
                f_Cin_14d <= f_Cin_13d;
                f_Cin_15d <= f_Cin_14d;
                f_Cin_16d <= f_Cin_15d;

				if (f_counter == 16) begin
					f_valid_16d <= 1'd1;
				end
                f_counter = f_counter + 1;
			end
		end


        always @(posedge clk) begin
            if (!rstn) begin //reset on	
                assert_sum1_reset: assert (!S1);
                assert_sum2_reset: assert (!S2);
                assert_sum3_reset: assert (!S3);
                assert_sum4_reset: assert (!S4);
                assert_sum5_reset: assert (!S5);
                assert_sum6_reset: assert (!S6);
                assert_sum7_reset: assert (!S7);
                assert_sum8_reset: assert (!S8);
                assert_cout_reset: assert (!Cout);
            end else begin
				if (f_valid_16d) begin	
                    //S1
					assert_sum1_00: assert (!(!f_A1_16d && !f_B1_16d && !f_Cin_16d) || (!S1));
					assert_sum1_01: assert (!(!f_A1_16d && !f_B1_16d &&  f_Cin_16d) || ( S1));
					assert_sum1_02: assert (!(!f_A1_16d &&  f_B1_16d && !f_Cin_16d) || ( S1));
					assert_sum1_03: assert (!(!f_A1_16d &&  f_B1_16d &&  f_Cin_16d) || (!S1));
					assert_sum1_04: assert (!( f_A1_16d && !f_B1_16d && !f_Cin_16d) || ( S1));
					assert_sum1_05: assert (!( f_A1_16d && !f_B1_16d &&  f_Cin_16d) || (!S1));
					assert_sum1_06: assert (!( f_A1_16d &&  f_B1_16d && !f_Cin_16d) || (!S1));
					assert_sum1_07: assert (!( f_A1_16d &&  f_B1_16d &&  f_Cin_16d) || ( S1));
                    
                    //S2
                    assert_sum2_1: assert ( !( f_sum2 == 0 ) || (!S2) );
                    assert_sum2_2: assert ( !( f_sum2 == 1 ) || ( S2) );
                    assert_sum2_3: assert ( !( f_sum2 == 2 ) || (!S2) );
                    assert_sum2_4: assert ( !( f_sum2 == 3 ) || ( S2) );

                    //S3
                    assert_sum3_1: assert ( !( f_sum3 == 0 ) || (!S3) );
                    assert_sum3_2: assert ( !( f_sum3 == 1 ) || ( S3) );
                    assert_sum3_3: assert ( !( f_sum3 == 2 ) || (!S3) );
                    assert_sum3_4: assert ( !( f_sum3 == 3 ) || ( S3) );
                    
                    //S4
                    assert_sum4_1: assert ( !( f_sum4 == 0 ) || (!S4) );
                    assert_sum4_2: assert ( !( f_sum4 == 1 ) || ( S4) );
                    assert_sum4_3: assert ( !( f_sum4 == 2 ) || (!S4) );
                    assert_sum4_4: assert ( !( f_sum4 == 3 ) || ( S4) );
					
                    //S5
                    assert_sum5_1: assert ( !( f_sum5 == 0 ) || (!S5) );
                    assert_sum5_2: assert ( !( f_sum5 == 1 ) || ( S5) );
                    assert_sum5_3: assert ( !( f_sum5 == 2 ) || (!S5) );
                    assert_sum5_4: assert ( !( f_sum5 == 3 ) || ( S5) );

                    //S6
                    assert_sum6_1: assert ( !( f_sum6 == 0 ) || (!S6) );
                    assert_sum6_2: assert ( !( f_sum6 == 1 ) || ( S6) );
                    assert_sum6_3: assert ( !( f_sum6 == 2 ) || (!S6) );
                    assert_sum6_4: assert ( !( f_sum6 == 3 ) || ( S6) );
                    
                    //S7
                    assert_sum7_1: assert ( !( f_sum7 == 0 ) || (!S7) );
                    assert_sum7_2: assert ( !( f_sum7 == 1 ) || ( S7) );
                    assert_sum7_3: assert ( !( f_sum7 == 2 ) || (!S7) );
                    assert_sum7_4: assert ( !( f_sum7 == 3 ) || ( S7) );

                    //S8
                    assert_sum8_1: assert ( !( f_sum8 == 0 ) || (!S8) );
                    assert_sum8_2: assert ( !( f_sum8 == 1 ) || ( S8) );
                    assert_sum8_3: assert ( !( f_sum8 == 2 ) || (!S8) );
                    assert_sum8_4: assert ( !( f_sum8 == 3 ) || ( S8) );

                    //Cout 
                    assert_cout_1: assert ( !( f_sum8 == 0 ) || (!Cout) );
                    assert_cout_2: assert ( !( f_sum8 == 1 ) || (!Cout) );
                    assert_cout_3: assert ( !( f_sum8 == 2 ) || ( Cout) );
                    assert_cout_4: assert ( !( f_sum8 == 3 ) || ( Cout) );
				end
            end 
        end
    `endif

endmodule

