module alu #(
		parameter OPCODE_WIDTH       = 2,
		parameter DATA_WIDTH         = 3
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

	function reg func_get_bit(reg [DATA_WIDTH:0] value, reg [DATA_WIDTH:0] pos);
		reg [DATA_WIDTH:0] divisor;
		reg [DATA_WIDTH:0] i;
		
		divisor = 1;
		res = 0;
		
		for (i = 0; i < pos; i = i+1) begin
			divisor = divisor * 2;
		end
		
		if (divisor != 0) begin
				res = (value / divisor) % 2;
		end
	endfunction
	
	function reg [DATA_WIDTH+1:0] func_set_bit(reg [DATA_WIDTH+1:0] value, reg [DATA_WIDTH:0] pos, reg bit_v);
		reg current_bit;
		reg [DATA_WIDTH:0] divisor;
		reg [DATA_WIDTH:0] i;
		
		current_bit = func_get_bit(value[DATA_WIDTH:0], pos);
		current_bit = res[0];

		divisor = 1;

		for (i = 0; i < pos; i = i+1) begin
			divisor = divisor * 2;
		end
		if (current_bit == bit_v) begin
			res = value;
		end else begin
			if (bit_v == 1) begin
				res = value + divisor;
			end else begin
				res = value + divisor;
			end
		end
	endfunction
	
	function reg [DATA_WIDTH+1:0] func_and(reg [DATA_WIDTH:0] data1, reg [DATA_WIDTH:0] data2);
		reg [DATA_WIDTH:0] i;
		reg bit_v;
		reg aux_0;
		reg aux_1;
		reg [DATA_WIDTH+1:0] aux_2;
		aux_2 = 0;
	
		for (i = 0; i < DATA_WIDTH+1; i=i+1) begin
			aux_0 = func_get_bit(data1, i);
			aux_0 = res[0];
			aux_1 = func_get_bit(data2, i);
			aux_1 = res[0];
			bit_v = aux_0 * aux_1;
			
			aux_2 = func_set_bit(aux_2, i, bit_v);
			aux_2 = res;
		end
	endfunction

	function reg [DATA_WIDTH+1:0] func_or(reg [DATA_WIDTH:0] data1, reg [DATA_WIDTH:0] data2);
		reg [DATA_WIDTH:0] i;
		reg [1:0] bit_v;
		reg bit_v_1;
		
		reg aux_0;
		reg aux_1;
		reg [DATA_WIDTH+1:0] aux_2;		
		aux_2 = 0;
		
		for (i = 0; i < DATA_WIDTH+1; i++) begin	
			aux_0 = func_get_bit(data1, i);	
			aux_0 = res[0];
			aux_1 = func_get_bit(data2, i);
			aux_1 = res[0];
			bit_v = aux_0 + aux_1;

			bit_v_1 = bit_v > 0 ? 1 : 0;
			aux_2 = func_set_bit(aux_2, i, bit_v_1);
			aux_2 = res;
		end
	endfunction
	
	function reg [DATA_WIDTH+1:0] func_nand(reg [DATA_WIDTH:0] data1, reg [DATA_WIDTH:0] data2);
		reg [DATA_WIDTH:0] i;
		reg bit_v;
		reg bit_v_1;
		
		reg aux_0;
		reg aux_1;
		reg [DATA_WIDTH+1:0] aux_2;
		bit_v_1 = 0;
		aux_2 = 0;
		
		for (i = 0; i < DATA_WIDTH+1; i++) begin		
			aux_0 = func_get_bit(data1, i);	
			aux_0 = res[0];
			aux_1 = func_get_bit(data2, i);
			aux_1 = res[0];
			bit_v = aux_0 * aux_1;

			bit_v_1 = (bit_v == 1) ? 0 : 1;			
			aux_2 = func_set_bit(aux_2, i, bit_v_1);
			aux_2 = res;
		end		
	endfunction
	
	function reg [DATA_WIDTH+1:0] func_xor(reg [DATA_WIDTH:0] data1, reg [DATA_WIDTH:0] data2);
		reg [DATA_WIDTH:0] i;
		reg [1:0] bit_v;
		reg bit_v_1;
		
		reg aux_0;
		reg aux_1;
		reg [DATA_WIDTH+1:0] aux_2;
		aux_2 = 0;
		
		for (i = 0; i < DATA_WIDTH+1; i++) begin		
			aux_0 = func_get_bit(data1, i);	
			aux_0 = res[0];
			aux_1 = func_get_bit(data2, i);
			aux_1 = res[0];
			bit_v = aux_0 + aux_1;
						
			bit_v_1 = (bit_v == 1) ? 1 : 0;	
			aux_2 = func_set_bit(aux_2, i, bit_v_1);
			aux_2 = res;
		end
	endfunction
	
	
	
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
			4 : begin //and
				result_next = func_and(data1, data2);
				result_next = res;
			end
			5 : begin //or
				result_next = func_or(data1, data2);
				result_next = res;				
			end
			6 : begin //nand
				result_next = func_nand(data1, data2);
				result_next = res;				
			end
			7 : begin //xor
				result_next = func_xor(data1, data2);
				result_next = res;				
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
		reg [DATA_WIDTH:0] op_and  ;
		reg [DATA_WIDTH:0] op_or   ;
		reg [DATA_WIDTH:0] op_nand ;
		reg [DATA_WIDTH:0] op_xor  ;
		
		
		//Declare when verifications is valid
        reg f_past_valid = 1'b0;

		assign op_add  =  (f_op1 + f_op2);
		assign op_sub  =  (f_op1 - f_op2);
		assign op_incr =   f_op1 + 1;
		assign op_decr =   f_op1 - 1;
		assign op_and  =   f_op1 & f_op2;
		assign op_or   =   f_op1 | f_op2;
		assign op_nand = ~(f_op1 & f_op2);
		assign op_xor  =   f_op1 ^ f_op2;
						  

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
				assert_zero_reset:  assert (!ZERO);
				assert_zero_result: assert ((RESULT == 4'd0));

			end else begin 				
				if (f_past_valid) begin	 
					//zero
					assert_zero1: assert ( !((f_opcode == 0) &  op_add[(DATA_WIDTH + 1)])  || CARRY); 
					assert_zero2: assert ( !((f_opcode == 1) &  op_sub[(DATA_WIDTH + 1)])  || CARRY); 
					assert_zero3: assert ( !((f_opcode == 2) & op_incr[(DATA_WIDTH + 1)]) || CARRY); 
					assert_zero4: assert ( !((f_opcode == 3) & op_decr[(DATA_WIDTH + 1)]) || CARRY);

					//carry
					assert_carry1: assert ( !((f_opcode == 0) & ( op_add  == 0)) || ZERO );
					assert_carry2: assert ( !((f_opcode == 1) & ( op_sub  == 0)) || ZERO );
					assert_carry3: assert ( !((f_opcode == 3) & ( op_decr == 0)) || ZERO );
					assert_carry4: assert ( !((f_opcode == 4) & ( op_and  == 0)) || ZERO );
					assert_carry5: assert ( !((f_opcode == 5) & ( op_or   == 0)) || ZERO );
					assert_carry6: assert ( !((f_opcode == 6) & ( op_nand == 0)) || ZERO );
					assert_carry7: assert ( !((f_opcode == 7) & ( op_xor  == 0)) || ZERO );

					//result
					assert_res0: assert ( !(f_opcode == 0) || RESULT == ( op_add[DATA_WIDTH:0]) );
					assert_res1: assert ( !(f_opcode == 1) || RESULT == ( op_sub[DATA_WIDTH:0]) );
					assert_res2: assert ( !(f_opcode == 2) || RESULT == (op_incr[DATA_WIDTH:0]) );
					assert_res3: assert ( !(f_opcode == 3) || RESULT == (op_decr[DATA_WIDTH:0]) );
					assert_res4: assert ( !(f_opcode == 4) || RESULT == op_and );
					assert_res5: assert ( !(f_opcode == 5) || RESULT == op_or );
					assert_res6: assert ( !(f_opcode == 6) || RESULT == op_nand );
					assert_res7: assert ( !(f_opcode == 7) || RESULT == op_xor );
				end
			end
		end
		
	`endif

endmodule