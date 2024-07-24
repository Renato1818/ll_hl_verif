module half_adder (
    input  wire clk,
    input  wire rstn,
    input  wire a,
    input  wire b,
    output wire sum,
    output wire carry
    );

	reg sum_next;
	reg carry_next;
	reg sum_out;
	reg carry_out;
	
	
	always @(*) begin : prc_half_adder_comb     
		reg s_nand;
		reg s_or;
	
		carry_next = carry;
		sum_next = sum;
		s_nand = !(a && b);
		s_or = a || b;
	
		sum_next = s_nand && s_or;
		carry_next = a && b;
	end


	always_ff @(posedge clk or negedge rstn) begin : prc_half_adder_ff
		if ( ~rstn ) begin
			sum_out <= 1'd0;
			carry_out <= 1'd0;
		end else begin
			sum_out <= sum_next;
			carry_out <= carry_next;
		end
	end
	
	assign sum = sum_out;
	assign carry = carry_out;

    `ifdef FORMAL
        reg f_a;
        reg f_b;  

		reg f_sum;
		reg f_carry;
        
        //Declare when verifications is valid
        reg f_past_valid = 1'b0;

		assign f_sum = ((f_a) ^ (f_b)) ^ sum;
		assign f_carry = ((f_a) & (f_b)) ^ carry;

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_a <= 1'd0;		
				f_b <= 1'd0;	
				f_past_valid <= 1'd0;
			end else begin
				f_a <= a;		
				f_b <= b;	
				f_past_valid <= 1'd1;
			end
		end

        always @(posedge clk) begin
            if (!rstn) begin //reset on	
                assert_sum_reset: assert (!sum);
                assert_carry_reset: assert (!carry);
            end else begin
				if (f_past_valid) begin	
                    assert_sum_: assert ( !f_sum );
                    assert_carry: assert ( !f_carry);
				end
            end //

            //COVER
            cov_sum_true:  cover (sum); 
            cov_sum_false: cover (!sum);	
            
            cov_carry_true:  cover (carry); 
            cov_carry_false: cover (!carry); 
        
            cover_ab1: cover ((!a && !b));
            cover_ab2: cover ((!a &&  b));
            cover_ab3: cover (( a && !b));
            cover_ab4: cover (( a &&  b)); 
        end

    `endif
endmodule

