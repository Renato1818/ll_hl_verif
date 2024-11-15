module bit2_adder (
        input wire clk,
        input wire rstn,
        input wire Cin,
        input wire A1,
        input wire A2,
        input wire B1,
        input wire B2,
        output wire S1,
        output wire S2,
        output wire Cout
    );

    //Auxiliar variables to ha1 and fa1
    reg s11, c11, cin_1d;
    reg s1, c1;

    //Auxiliar variables to ha2 and fa2
    reg s21, c21, c1_1d;
    reg s2, c2;

    //Delay 2nd Inputs
    reg a2_1d, a2_2d, b2_1d, b2_2d;
    //Delay 1st Output
    reg s1_1d, s1_2d;


    // Thread-local variables ha_1
    wire s11_next, c11_next;

    // Thread-local variables fa_1
    wire s1_next, c1_next;

    // Thread-local variables ha_2
    wire s21_next, c21_next;

    // Clocked THREAD: fa_2 
    reg s2_next, c2_next;

    assign s11_next = (!(A1 && B1)) && (A1 || B1);
    assign c11_next = A1 && B1;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_1_ff
        if ( ~rstn ) begin
            s11    <= 1'd0;
            c11    <= 1'd0;
            cin_1d <= 1'd0;

            a2_1d  <= 1'd0;
            b2_1d  <= 1'd0;
        end else begin
            s11 <= s11_next;
            c11 <= c11_next;
            cin_1d <= Cin;

            //Delay 2nd inputs
            a2_1d <= A2;
            b2_1d <= B2;
        end
    end


    assign s1_next = (!(s11 && cin_1d)) && (s11 || cin_1d);
    assign c1_next = c11 || (s11 && cin_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_1_ff
        if ( ~rstn ) begin
            s1    <= 1'd0;
            c1    <= 1'd0;
            a2_2d <= 1'd0;
            b2_2d <= 1'd0;
        end else begin
            s1 <= s1_next;
            c1 <= c1_next;

            //Delay 2nd inputs
            a2_2d <= a2_1d;
            b2_2d <= b2_1d;
        end
    end


    assign s21_next = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
    assign c21_next = a2_2d && b2_2d;

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : ha_2_ff
        if ( ~rstn ) begin
            s21   <= 1'd0;
            c21   <= 1'd0;
            c1_1d <= 1'd0;
            s1_1d <= 1'd0;
        end else begin
            s21 <= s21_next;
            c21 <= c21_next;
            c1_1d <= c1;

            //Delay 1st Output
            s1_1d <= s1;
        end
    end


    assign s2_next = (!(s21 && c1_1d)) && (s21 || c1_1d);
    assign c2_next = c21 || (s21 && c1_1d);

    // Synchronous register update
    always_ff @(posedge clk or negedge rstn) begin : fa_2_ff
        if ( ~rstn ) begin
            s2    <= 1'd0;
            c2    <= 1'd0;
            s1_2d <= 1'd0;
        end else begin
            s2 <= s2_next;
            c2 <= c2_next;

            //Delay 1st Output
            s1_2d <= s1_1d;
        end
    end

    //Final Outputs
    assign S1 = s1_2d;
    assign S2 = s2;
    assign Cout = c2;


    `ifdef FORMAL
        reg f_A1_1d, f_A1_2d, f_A1_3d, f_A1_4d; 
        reg f_A2_1d, f_A2_2d, f_A2_3d, f_A2_4d; 

        reg f_B1_1d, f_B1_2d, f_B1_3d, f_B1_4d; 
        reg f_B2_1d, f_B2_2d, f_B2_3d, f_B2_4d;  

		reg f_Cin_1d, F_Cin_2d, f_Cin_3d, F_Cin_4d;

        reg [2:0] f_carry1;
        reg [2:0] f_add;
        
        //The resut is delay in 4 cicle
        reg f_valid_1d = 1'b0;
        reg f_valid_2d = 1'b0;
        reg f_valid_3d = 1'b0;
        reg f_valid_4d = 1'b0;

        assign f_carry1 = f_A1_4d  + f_B1_4d + f_Cin_4d;
        assign f_add = f_A2_4d + f_B2_4d + ( (f_carry1 >= 2) ? 1 : 0 );

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_valid_1d <= 1'd0;
				f_valid_2d <= 1'd0;
				f_valid_3d <= 1'd0;
				f_valid_4d <= 1'd0;
			end else begin
				f_A1_1d <= A1;		
				f_A1_2d <= f_A1_1d;
				f_A1_3d <= f_A1_2d;
				f_A1_4d <= f_A1_3d;

				f_A2_1d <= A2;		
				f_A2_2d <= f_A2_1d;
				f_A2_3d <= f_A2_2d;
				f_A2_4d <= f_A2_3d;

				f_B1_1d <= B1;	
				f_B1_2d <= f_B1_1d;	
				f_B1_3d <= f_B1_2d;	
				f_B1_4d <= f_B1_3d;	

				f_B2_1d <= B2;	
				f_B2_2d <= f_B2_1d;	
				f_B2_3d <= f_B2_2d;	
				f_B2_4d <= f_B2_3d;	

				f_Cin_1d <= Cin;
				f_Cin_2d <= f_Cin_1d;
				f_Cin_3d <= f_Cin_2d;
				f_Cin_4d <= f_Cin_3d;

				if (f_valid_1d) begin
                    if (f_valid_2d) begin
                        if (f_valid_3d) begin
                            f_valid_4d <= 1'd1;
                        end
					    f_valid_3d <= 1'd1;
				    end
					f_valid_2d <= 1'd1;
				end
				f_valid_1d <= 1'd1;
			end
		end


        always @(posedge clk) begin
            if (!rstn) begin //reset on	
                assert_sum1_reset: assert (!S1);
                assert_sum2_reset: assert (!S2);
                assert_carry_reset: assert (!Cout);
            end else begin
				if (f_valid_4d) begin	
                    //S1
					assert_sum1_00: assert (!(!f_A1_4d && !f_B1_4d && !f_Cin_4d) || (!S1));
					assert_sum1_01: assert (!(!f_A1_4d && !f_B1_4d &&  f_Cin_4d) || ( S1));
					assert_sum1_02: assert (!(!f_A1_4d &&  f_B1_4d && !f_Cin_4d) || ( S1));
					assert_sum1_03: assert (!(!f_A1_4d &&  f_B1_4d &&  f_Cin_4d) || (!S1));
					assert_sum1_04: assert (!( f_A1_4d && !f_B1_4d && !f_Cin_4d) || ( S1));
					assert_sum1_05: assert (!( f_A1_4d && !f_B1_4d &&  f_Cin_4d) || (!S1));
					assert_sum1_06: assert (!( f_A1_4d &&  f_B1_4d && !f_Cin_4d) || (!S1));
					assert_sum1_07: assert (!( f_A1_4d &&  f_B1_4d &&  f_Cin_4d) || ( S1));
                    
                    //S2
                    assert_sum2_1: assert ( !( f_add == 0 ) || (!S2) );
                    assert_sum2_2: assert ( !( f_add == 1 ) || ( S2) );
                    assert_sum2_3: assert ( !( f_add == 2 ) || (!S2) );
                    assert_sum2_4: assert ( !( f_add == 3 ) || ( S2) );

                    //Cout 
                    assert_cout_1: assert ( !( f_add == 0 ) || (!Cout) );
                    assert_cout_2: assert ( !( f_add == 1 ) || (!Cout) );
                    assert_cout_3: assert ( !( f_add == 2 ) || ( Cout) );
                    assert_cout_4: assert ( !( f_add == 3 ) || ( Cout) );

				end
            end 
        end
    `endif

endmodule


