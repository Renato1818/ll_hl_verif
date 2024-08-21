module bit4_adder (
        input logic clk,
        input logic rstn,
        input logic Cin,
        input logic A1,
        input logic A2,
        input logic A3,
        input logic A4,
        input logic B1,
        input logic B2,
        input logic B3,
        input logic B4,
        output logic S1,
        output logic S2,
        output logic S3,
        output logic S4,
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

    //Delay Inputs to prevent miss match
    reg a2_1d, a2_2d, b2_1d, b2_2d;
    reg a3_1d, a3_2d, a3_3d, a3_4d, b3_1d, b3_2d, b3_3d, b3_4d;
    reg a4_1d, a4_2d, a4_3d, a4_4d, a4_5d, a4_6d;
    reg b4_1d, b4_2d, b4_3d, b4_4d, b4_5d, b4_6d;

    //Delay Outputs
    reg s1_1d, s1_2d, s1_3d, s1_4d, s1_5d, s1_6d;
    reg s2_1d, s2_2d, s2_3d, s2_4d;
    reg s3_1d, s3_2d;

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
        end
    end

    //------------------------------------------------------------------------------
    // Clocked THREAD: ha_2 

    // Thread-local variables
    wire s21_next, c21_next;

    assign s21_next = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
    assign c21_next = a2_2d && b2_2d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_2_ff
        if ( ~rstn ) begin
            s21 <= 1'd0;
            c21 <= 1'd0;
            c1_1d <= 1'd0;

            a3_3d <= 1'd0;
            b3_3d <= 1'd0;
            a4_3d <= 1'd0;
            b4_3d <= 1'd0;
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
            s1_2d <= 1'd0;
        end else begin
            s2 <= s2_next;
            c2 <= c2_next;

            //Delay Inputs
            a3_4d <= a3_3d;
            b3_4d <= b3_3d;
            a4_4d <= a4_3d;
            b4_4d <= b4_3d;

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
            s1_3d <= 1'd0;
            s2_1d <= 1'd0;
        end else begin
            s31 <= s31_next;
            c31 <= c31_next;
            c2_1d <= c2;

            //Delay Inputs
            a4_5d <= a4_4d;
            b4_5d <= b4_4d;

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
            s1_4d <= 1'd0;
            s2_2d <= 1'd0;
        end else begin
            s3 <= s3_next;
            c3 <= c3_next;

            //Delay Inputs
            a4_6d <= a4_5d;
            b4_6d <= b4_5d;

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
            s1_5d <= 1'd0;
            s2_3d <= 1'd0;
            s3_1d <= 1'd0;
        end
        else begin
            s41 <= s41_next;
            c41 <= c41_next;
            c3_1d <= c3;

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
    always_ff @(posedge clk or negedge rstn) begin : fa_4_ff
        if ( ~rstn ) begin
            s4 <= 1'd0;
            c4 <= 1'd0;

            s1_6d <= 1'd0;
            s2_4d <= 1'd0;
            s3_2d <= 1'd0;
        end else begin
            s4 <= s4_next;
            c4 <= c4_next;

            //Delay Outputs
            s1_6d <= s1_5d;
            s2_4d <= s2_3d;
            s3_2d <= s3_1d;
        end
    end
    
    assign S1 = s1_6d;
    assign S2 = s2_4d;
    assign S3 = s3_2d;
    assign S4 = s4;
    assign Cout = c4;

    `ifdef FORMAL
        reg f_A1_1d, f_A1_2d, f_A1_3d, f_A1_4d, f_A1_5d, f_A1_6d, f_A1_7d, f_A1_8d; 
        reg f_A2_1d, f_A2_2d, f_A2_3d, f_A2_4d, f_A2_5d, f_A2_6d, f_A2_7d, f_A2_8d; 
        reg f_A3_1d, f_A3_2d, f_A3_3d, f_A3_4d, f_A3_5d, f_A3_6d, f_A3_7d, f_A3_8d; 
        reg f_A4_1d, f_A4_2d, f_A4_3d, f_A4_4d, f_A4_5d, f_A4_6d, f_A4_7d, f_A4_8d; 

        reg f_B1_1d, f_B1_2d, f_B1_3d, f_B1_4d, f_B1_5d, f_B1_6d, f_B1_7d, f_B1_8d; 
        reg f_B2_1d, f_B2_2d, f_B2_3d, f_B2_4d, f_B2_5d, f_B2_6d, f_B2_7d, f_B2_8d;  
        reg f_B3_1d, f_B3_2d, f_B3_3d, f_B3_4d, f_B3_5d, f_B3_6d, f_B3_7d, f_B3_8d; 
        reg f_B4_1d, f_B4_2d, f_B4_3d, f_B4_4d, f_B4_5d, f_B4_6d, f_B4_7d, f_B4_8d;  

		reg f_Cin_1d, F_Cin_2d, f_Cin_3d, F_Cin_4d, f_Cin_5d, F_Cin_6d, f_Cin_7d, F_Cin_8d;

        reg [2:0] f_sum1, f_sum2, f_sum3;
        reg [2:0] f_sum4;

        reg [3:0] f_counter = 1'd0;
        
        //The resut is delay in 8 cicle
        reg f_valid_8d = 1'b0;

        assign f_sum1 = f_A1_8d + f_B1_8d + f_Cin_8d;
        assign f_sum2 = f_A2_8d + f_B2_8d + ( (f_sum1 >= 2) ? 1 : 0 );
        assign f_sum3 = f_A3_8d + f_B3_8d + ( (f_sum2 >= 2) ? 1 : 0 );
        assign f_sum4 = f_A4_8d + f_B4_8d + ( (f_sum3 >= 2) ? 1 : 0 );

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_valid_8d <= 1'd0;
                f_counter <= 1'd0;
			end else begin
				f_A1_1d <= A1;		    f_A2_1d <= A2;		
				f_A1_2d <= f_A1_1d;     f_A2_2d <= f_A2_1d;
				f_A1_3d <= f_A1_2d;     f_A2_3d <= f_A2_2d;
				f_A1_4d <= f_A1_3d;     f_A2_4d <= f_A2_3d;
				f_A1_5d <= f_A1_4d;     f_A2_5d <= f_A2_4d;
				f_A1_6d <= f_A1_5d;     f_A2_6d <= f_A2_5d;
				f_A1_7d <= f_A1_6d;     f_A2_7d <= f_A2_6d;
				f_A1_8d <= f_A1_7d;     f_A2_8d <= f_A2_7d;

				f_A3_1d <= A3;		    f_A4_1d <= A4;		
				f_A3_2d <= f_A3_1d;     f_A4_2d <= f_A4_1d;
				f_A3_3d <= f_A3_2d;     f_A4_3d <= f_A4_2d;
				f_A3_4d <= f_A3_3d;     f_A4_4d <= f_A4_3d;
				f_A3_5d <= f_A3_4d;     f_A4_5d <= f_A4_4d;
				f_A3_6d <= f_A3_5d;     f_A4_6d <= f_A4_5d;
				f_A3_7d <= f_A3_6d;     f_A4_7d <= f_A4_6d;
				f_A3_8d <= f_A3_7d;     f_A4_8d <= f_A4_7d;			
				

				f_B1_1d <= B1;	        f_B2_1d <= B2;	    
				f_B1_2d <= f_B1_1d;	    f_B2_2d <= f_B2_1d;	
				f_B1_3d <= f_B1_2d;	    f_B2_3d <= f_B2_2d;	
				f_B1_4d <= f_B1_3d;	    f_B2_4d <= f_B2_3d;	
				f_B1_5d <= f_B1_4d;     f_B2_5d <= f_B2_4d; 
				f_B1_6d <= f_B1_5d;     f_B2_6d <= f_B2_5d; 
				f_B1_7d <= f_B1_6d;     f_B2_7d <= f_B2_6d; 
				f_B1_8d <= f_B1_7d;     f_B2_8d <= f_B2_7d; 

				f_B3_1d <= B3;	        f_B4_1d <= B4;	    
				f_B3_2d <= f_B3_1d;	    f_B4_2d <= f_B4_1d;	
				f_B3_3d <= f_B3_2d;	    f_B4_3d <= f_B4_2d;	
				f_B3_4d <= f_B3_3d;	    f_B4_4d <= f_B4_3d;	
				f_B3_5d <= f_B3_4d;     f_B4_5d <= f_B4_4d; 
				f_B3_6d <= f_B3_5d;     f_B4_6d <= f_B4_5d; 
				f_B3_7d <= f_B3_6d;     f_B4_7d <= f_B4_6d; 
				f_B3_8d <= f_B3_7d;     f_B4_8d <= f_B4_7d; 

				f_Cin_1d <= Cin;
				f_Cin_2d <= f_Cin_1d;
				f_Cin_3d <= f_Cin_2d;
				f_Cin_4d <= f_Cin_3d;
				f_Cin_5d <= f_Cin_4d;
				f_Cin_6d <= f_Cin_5d;
				f_Cin_7d <= f_Cin_6d;
				f_Cin_8d <= f_Cin_7d;

				if (f_counter == 8) begin
					f_valid_8d <= 1'd1;
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
                assert_cout_reset: assert (!Cout);
            end else begin
				if (f_valid_8d) begin	
                    //S1
					assert_sum1_00: assert (!(!f_A1_8d && !f_B1_8d && !f_Cin_8d) || (!S1));
					assert_sum1_01: assert (!(!f_A1_8d && !f_B1_8d &&  f_Cin_8d) || ( S1));
					assert_sum1_02: assert (!(!f_A1_8d &&  f_B1_8d && !f_Cin_8d) || ( S1));
					assert_sum1_03: assert (!(!f_A1_8d &&  f_B1_8d &&  f_Cin_8d) || (!S1));
					assert_sum1_04: assert (!( f_A1_8d && !f_B1_8d && !f_Cin_8d) || ( S1));
					assert_sum1_05: assert (!( f_A1_8d && !f_B1_8d &&  f_Cin_8d) || (!S1));
					assert_sum1_06: assert (!( f_A1_8d &&  f_B1_8d && !f_Cin_8d) || (!S1));
					assert_sum1_07: assert (!( f_A1_8d &&  f_B1_8d &&  f_Cin_8d) || ( S1));
                    
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
					
                    //Cout 
                    assert_cout_1: assert ( !( f_sum4 == 0 ) || (!Cout) );
                    assert_cout_2: assert ( !( f_sum4 == 1 ) || (!Cout) );
                    assert_cout_3: assert ( !( f_sum4 == 2 ) || ( Cout) );
                    assert_cout_4: assert ( !( f_sum4 == 3 ) || ( Cout) );
				end
            end 
        end
    `endif

endmodule

