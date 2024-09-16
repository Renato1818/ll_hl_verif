module alu #(
		parameter OPCODE_WIDTH       = 2,
		parameter DATA_WIDTH         = 61
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
			
		end

	`endif

endmodule