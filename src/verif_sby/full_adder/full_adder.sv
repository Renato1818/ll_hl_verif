module full_adder (
    input wire clk,
    input wire rstn,
    input wire A1,
    input wire B1,
    input wire Cin,
	output reg S1,
    output reg Cout
	);
	
	reg s11, c11, cin_1d;
	reg s11_next, c11_next;

	reg s1_next, cout_next;


	assign s11_next = (!(A1 && B1)) && (A1 || B1);
	assign c11_next = A1 && B1;
	
	// Synchronous register update
	always_ff @(posedge clk or negedge rstn) begin : ha_11_ff
	    if ( ~rstn ) begin
			s11 <= 1'd0;
			c11 <= 1'd0;
	    end
	    else begin
			s11 <= s11_next;
			c11 <= c11_next;
			cin_1d <= Cin;
	    end
	end
		
	assign s1_next = (!(s11 && cin_1d)) && (s11 || cin_1d);
	assign cout_next = c11 || (s11 && cin_1d);
	
	// Synchronous register update
	always_ff @(posedge clk or negedge rstn) begin : fa_1_ff
		if ( ~rstn ) begin
			S1   <= 1'd0;
			Cout <= 1'd0;
		end
		else begin
			S1 <= s1_next;
			Cout <= cout_next;
		end
	end
	

    `ifdef FORMAL
        reg f_a_1d = 1'b0;
        reg f_a_2d = 1'b0;

        reg f_b_1d = 1'b0; 
        reg f_b_2d = 1'b0; 

		reg f_cin_1d = 1'b0;
		reg f_cin_2d = 1'b0;
        
        //The resut is delay in 2 cicle
        reg f_valid_1d = 1'b0;
        reg f_valid_2d = 1'b0;

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_a_1d <= 1'd0;	
				f_a_2d <= 1'd0;	

				f_b_1d <= 1'd0;	
				f_b_2d <= 1'd0;	

				f_cin_1d <= 1'd0;
				f_cin_2d <= 1'd0;

				f_valid_1d <= 1'd0;
				f_valid_2d <= 1'd0;
			end else begin
				f_a_1d <= A1;		
				f_a_2d <= f_a_1d;

				f_b_1d <= B1;	
				f_b_2d <= f_b_1d;	

				f_cin_1d <= Cin;
				f_cin_2d <= f_cin_1d;

				if (f_valid_1d) begin
					f_valid_2d <= 1'd1;
				end
				f_valid_1d <= 1'd1;
			end
		end

        always @(posedge clk) begin
            if (!rstn) begin //reset on	
                assert_sum_reset: assert (!S1);
                assert_carry_reset: assert (!Cout);
            end else begin
				if (f_valid_2d) begin	
					assert_sum0: assert (!(!f_a_2d && !f_b_2d && !f_cin_2d) || (!S1));
					assert_sum1: assert (!(!f_a_2d && !f_b_2d &&  f_cin_2d) || ( S1));
					assert_sum2: assert (!(!f_a_2d &&  f_b_2d && !f_cin_2d) || ( S1));
					assert_sum3: assert (!(!f_a_2d &&  f_b_2d &&  f_cin_2d) || (!S1));
					assert_sum4: assert (!( f_a_2d && !f_b_2d && !f_cin_2d) || ( S1));
					assert_sum5: assert (!( f_a_2d && !f_b_2d &&  f_cin_2d) || (!S1));
					assert_sum6: assert (!( f_a_2d &&  f_b_2d && !f_cin_2d) || (!S1));
					assert_sum7: assert (!( f_a_2d &&  f_b_2d &&  f_cin_2d) || ( S1));

					assert_cout0: assert (!(!f_a_2d && !f_b_2d && !f_cin_2d) || (!Cout));
					assert_cout1: assert (!(!f_a_2d && !f_b_2d &&  f_cin_2d) || (!Cout));
					assert_cout2: assert (!(!f_a_2d &&  f_b_2d && !f_cin_2d) || (!Cout));
					assert_cout3: assert (!(!f_a_2d &&  f_b_2d &&  f_cin_2d) || ( Cout));
					assert_cout4: assert (!( f_a_2d && !f_b_2d && !f_cin_2d) || (!Cout));
					assert_cout5: assert (!( f_a_2d && !f_b_2d &&  f_cin_2d) || ( Cout));
					assert_cout6: assert (!( f_a_2d &&  f_b_2d && !f_cin_2d) || ( Cout));
					assert_cout7: assert (!( f_a_2d &&  f_b_2d &&  f_cin_2d) || ( Cout));
				end
            end //

            //COVER
              //cov_sum_true:  cover (S1); 
              //cov_sum_false: cover (!S1);	
              //
              //cov_carry_true:  cover (Cout); 
              //cov_carry_false: cover (!Cout); 
              //
              //cover_input0: cover ((!a && !b && !carry_in));
              //cover_input1: cover ((!a && !b &&  carry_in));
              //cover_input2: cover ((!a &&  b && !carry_in));
              //cover_input3: cover ((!a &&  b &&  carry_in));
              //cover_input4: cover (( a && !b && !carry_in));
              //cover_input5: cover (( a && !b &&  carry_in)); 
              //cover_input6: cover (( a &&  b && !carry_in));
              //cover_input7: cover (( a &&  b &&  carry_in)); 
        end

    `endif

endmodule

