module alu #(
		parameter OPCODE_WIDTH       = 2,
		parameter DATA_WIDTH         = 127
	)(
		input wire clk,
		input wire rstn,
		input wire [OPCODE_WIDTH:0] OPCODE,
		input wire [DATA_WIDTH:0] OP1,
		input wire [DATA_WIDTH:0] OP2,
		output wire CARRY,
		output wire ZERO,
		output wire [DATA_WIDTH:0] RESULT
	);

//------------------------------------------------------------------------------
// Clocked THREAD: operate
	
	// Thread-local variables
	reg [DATA_WIDTH+1:0] result_next;
	reg [DATA_WIDTH:0] RESULT_next;
	reg [DATA_WIDTH:0] result;
	reg zero;
	reg ZERO_next;
	reg carry;
	reg CARRY_next;  
	reg [DATA_WIDTH:0] data1;
	reg [DATA_WIDTH:0] data2;
	reg [DATA_WIDTH+1:0] res;
		
	
	always @(*) begin: operate_comb  		
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
			default: begin				
				CARRY_next = 0;
				result_next = 0;
				ZERO_next = 0;
			end
		endcase

		RESULT_next = result_next[DATA_WIDTH:0];
		CARRY_next = result_next[DATA_WIDTH+1];
		
		if (result_next == 0) begin
			ZERO_next = 1'd1;
		end else begin
			ZERO_next = 1'd0;
		end
	end
	
	always_ff @(posedge clk or negedge rstn)  begin : operate_ff
		if ( !rstn ) begin
			zero <= 1'd0;
			result <= 1'd0;
			carry <= 1'd0;
		end else begin
			zero <= ZERO_next;
			result <= RESULT_next;
			carry <= CARRY_next;
		end
	end

	assign RESULT = result;
	assign ZERO = zero;
	assign CARRY = carry;
	
	`ifdef FORMAL	
		reg [DATA_WIDTH:0] f_op1;
		reg [DATA_WIDTH:0] f_op2;
		reg [OPCODE_WIDTH:0] f_opcode;

		reg [(DATA_WIDTH + 1):0] op_add  ;
		reg [(DATA_WIDTH + 1):0] op_sub  ;
		reg [(DATA_WIDTH + 1):0] op_incr ;  
		reg [(DATA_WIDTH + 1):0] op_decr ; 
		
		
		//Declare when verifications is valid
        reg f_past_valid = 1'b0;
        //always @($global_clock) f_past_valid <= 1'b1; //to use $past property
		//always @(negedge rstn) begin
		//	if ( !rstn ) begin
		//		f_past_valid <= 1'd0;
		//	end 
		//end


		assign op_add  =  (f_op1 + f_op2);
		assign op_sub  =  (f_op1 - f_op2);
		assign op_incr =   f_op1 + 1;
		assign op_decr =   f_op1 - 1;
					  

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin	
				f_op1 <= 1'd0;
				f_op2 <= 1'd0;
				f_opcode <= 1'd0;
				f_past_valid <= 1'd0;
			end else begin
				f_op1 <= OP1;
				f_op2 <= OP2;
				f_opcode <= OPCODE;
				f_past_valid <= 1'd1;
			end
		end


		always @(posedge clk) begin			

			if (!rstn) begin 
				assert_carry_reset: assert (!CARRY);	
				assert_zero_reset: assert (!ZERO);
				assert_zero_result: assert ((RESULT == 4'd0));

			end else begin 				
				if (f_past_valid) begin	 
					//zero
					assert_zero1: assert ( !((f_opcode == 0) &  op_add[(DATA_WIDTH+1)])  || CARRY); 
					assert_zero2: assert ( !((f_opcode == 1) &  op_sub[(DATA_WIDTH+1)])  || CARRY); 
					assert_zero3: assert ( !((f_opcode == 2) & op_incr[(DATA_WIDTH+1)])  || CARRY); 
					assert_zero4: assert ( !((f_opcode == 3) & op_decr[(DATA_WIDTH+1)])  || CARRY);

					//carry
					assert_carry0: assert ( !((f_opcode == 0) & ( op_add  == 0)) || ZERO );
					assert_carry1: assert ( !((f_opcode == 1) & ( op_sub  == 0)) || ZERO );
					assert_carry2: assert ( !((f_opcode == 3) & ( op_incr == 0)) || ZERO );
					assert_carry3: assert ( !((f_opcode == 3) & ( op_decr == 0)) || ZERO );

					//result
					assert_res0: assert ( !(f_opcode == 0) || RESULT == ( op_add[DATA_WIDTH:0]) );
					assert_res1: assert ( !(f_opcode == 1) || RESULT == ( op_sub[DATA_WIDTH:0]) );
					assert_res2: assert ( !(f_opcode == 2) || RESULT == (op_incr[DATA_WIDTH:0]) );
					assert_res3: assert ( !(f_opcode == 3) || RESULT == (op_decr[DATA_WIDTH:0]) );
				end
			end
			/*
			// cover
			//opcode op1 op2 cover
			cov_opcode_zero: cover (OPCODE == 3'd0);
			cov_opcode_one:  cover (OPCODE == 3'd7);
		
			cov_op1_zero: cover (OP1 == 4'd00);
			cov_op1_one:  cover (OP1 == 4'd15);
			cov_op2_zero: cover (OP2 == 4'd00);
			cov_op2_one:  cover (OP2 == 4'd15);

			//test carry
			cov_optest1: cover ((OPCODE == 0) && (OP1 == 4'd10) && (OP2 == 4'd10));
			//test !carry
			cov_optest2: cover ((OPCODE == 2) && (OP1 == 4'd08));
			//test zero
			cov_optest4: cover ((OPCODE == 0) && (OP1 == 4'd00) && (OP2 == 4'd00));
	
			
			//carry cover
			cov_carry_true:  cover (CARRY); 
			cov_carry_false: cover (!CARRY);
			
			//zero cover
			cov_zero_true:  cover (ZERO); 
			cov_zero_false: cover (!ZERO);	
			
			//Result cover	
			cov_result_zero: cover (RESULT == 4'd00);
			cov_result_one:  cover (RESULT == 4'd15);	

			case (OPCODE)
				0 : begin
					cover_res0: cover ( RESULT == (OP1 + OP2) );
				end				
				1: begin
					cover_res1: cover ( (RESULT == (OP1 - OP2)));
				end
				2: begin
					cover_res2: cover  ((RESULT == op_incr[3:0]));
				end
				3: begin
					cover_res3: cover  ((RESULT == (OP1 - 1)));
				end
				4: begin
					cover_res4: cover ((RESULT == (OP1 & OP2)));
				end
				5: begin
					cover_res5: cover ((RESULT == (OP1 | OP2)));
				end
				6: begin
					cover_res6: cover ((RESULT == ~(OP1 & OP2)));
				end
				7: begin
					cover_res7: cover ((RESULT == ~(OP1 | OP2)));
				end
			endcase */
		end

	`endif

endmodule