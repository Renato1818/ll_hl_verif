module full_adder (
    input wire clk,
    input wire rstn,
    input wire a,
    input wire b,
    input wire carry_in,
	
    output reg sum,
    output reg carry_out
	);

	reg s1;
	reg c1;
	reg c_in;
	reg c1_past;
	reg s2;
	reg c2;
	
	reg carry_out_next;
	reg sum_next;
	reg s1_next;
	reg c_in_next;
	reg c1_past_next;
	reg c1_next;
	reg s2_next;
	reg c2_next;
	
			
			
	always @(*) begin : prc_half_adder_1_comb
		wire s_nand;
		wire s_or;
		
		s_nand = !(a && b);
		s_or = a || b;
		s1_next = s_nand && s_or; 

	    c1_next = a && b;
		c_in_next = carry_in;
	end
	
	
	always_ff @(posedge clk or negedge rstn) begin : prc_half_adder_1_ff
	    if ( ~rstn ) begin
			s1 <= 1'd0;
			c1 <= 1'd0;
			c_in <= 1'd0;
	    end
	    else begin
	        s1 <= s1_next;
	        c1 <= c1_next;
			c_in <= c_in_next;
	    end
	end
		

	always @(*) begin : prc_half_adder_2_comb 
		wire s_nand;
		wire s_or;
		
		s_nand = !(s1 && c_in);
		s_or = s1 || c_in;
		s2_next = s_nand && s_or;	

	    c2_next = s1 && c_in;
		c1_past_next = c1;
	end
	
	
	always_ff @(posedge clk or negedge rstn) begin : prc_half_adder_2_ff
	    if ( ~rstn ) begin
			s2 <= 1'd0;
			c2 <= 1'd0;
			c1_past <= 1'd0;
	    end
	    else begin
	        s2 <= s2_next;
	        c2 <= c2_next;
			c1_past <= c1_past_next;
	    end
	end
		
	
	always @(*) begin : prc_or_comb   
		carry_out_next = c1_past || c2;
		sum_next = s2;
	end
	
	
	always_ff @(posedge clk or negedge rstn) begin : prc_or_ff
		if ( ~rstn ) begin
			carry_out <= 1'd0;
			sum <= 1'd0;
		end
		else begin
			carry_out <= carry_out_next;
			sum <= sum_next;
		end
	end
	

    `ifdef FORMAL
        reg f_a = 1'b0;
        reg f_b = 1'b0;  
		reg f_carry_in = 1'b0;

		reg f_s1;		
		reg f_s2;		
		reg f_s3;

		reg f_c1;		
		reg f_c2;

		reg f_sum;
		reg f_carry_out;
        
        //The resut is delay in 3 cicle
        reg f_past_valid = 1'b0;
        reg f_past_2_valid = 1'b0;
        reg f_past_3_valid = 1'b0;

		assign f_s1 = (f_a ^ f_b) ^ f_carry_in;
		assign f_sum = (f_s3) ^ sum;

		assign f_c1 = ((f_a ^ f_b) && f_carry_in) || (f_a && f_b);
		assign f_carry = ((f_c3)) ^ carry_out;

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_a <= 1'd0;		
				f_b <= 1'd0;	
				f_carry_in <= 1'd0;

				f_s2 <= 1'd0;
				f_s3 <= 1'd0;
				f_c2 <= 1'd0;
				f_c3 <= 1'd0;

				f_past_valid <= 1'd0;
				f_past_2_valid <= 1'd0;
				f_past_3_valid <= 1'd0;
			end else begin
				f_a <= a;		
				f_b <= b;	
				f_carry_in <= carry_in;

				f_s2 <= f_s1;
				f_s3 <= f_s2;
				f_c2 <= f_c1;
				f_c3 <= f_c2;

				if (f_past_valid) begin
					if (f_past_2_valid) begin
						f_past_3_valid <= 1'd1;
					end
					f_past_2_valid <= 1'd1;
				end
				f_past_valid <= 1'd1;
			end
		end

        always @(posedge clk) begin
            if (!rstn) begin //reset on	
                assert_sum_reset: assert (!sum);
                assert_carry_reset: assert (!carry_out);
            end else begin
				if (f_past_3_valid) begin	
                    assert_sum_: assert ( !f_sum );
                    assert_carry: assert ( !f_carry);
				end
            end //

            //COVER
            cov_sum_true:  cover (sum); 
            cov_sum_false: cover (!sum);	
            
            cov_carry_true:  cover (carry_out); 
            cov_carry_false: cover (!carry_out); 
        
            cover_input0: cover ((!a && !b && !carry_in));
            cover_input1: cover ((!a && !b &&  carry_in));
            cover_input2: cover ((!a &&  b && !carry_in));
            cover_input3: cover ((!a &&  b &&  carry_in));
            cover_input4: cover (( a && !b && !carry_in));
            cover_input5: cover (( a && !b &&  carry_in)); 
            cover_input6: cover (( a &&  b && !carry_in));
            cover_input7: cover (( a &&  b &&  carry_in)); 
        end

    `endif

endmodule

