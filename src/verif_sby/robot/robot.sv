module robot #(
			parameter DATA_IN_WIDTH       = 16,
			parameter MIN_DIST            = 16'd50
	  )
	(
			input wire clk,
			input wire rstn,
			input wire [DATA_IN_WIDTH-1:0] dist_v,
			output wire alarm_flag,
			output wire obs_detected_out
	);

	reg obs_detected;
	reg out_alarm_flag;
	reg [DATA_IN_WIDTH-1:0] buff_dist_v;
	
	reg obs_detected_next;
	reg alarm_flag_next;
	
	assign buff_dist_v = dist_v;
	assign obs_detected_out = obs_detected;
	
		
	assign obs_detected_next = (buff_dist_v < MIN_DIST) ? 1'd1 : 1'd0;
	
	always @(posedge clk or negedge rstn) begin : sensor_ff
		if ( !rstn ) begin
			obs_detected <= 1'd0;
		end else begin
			obs_detected <= obs_detected_next;
		end
	end
	
	
	assign alarm_flag_next = obs_detected ? 1'd1 : 1'd0;	
	
	always @(posedge clk or negedge rstn) begin : controller_ff
		if ( !rstn ) begin
			out_alarm_flag <= 1'd0;
		end else begin
			out_alarm_flag <= alarm_flag_next;
		end
	end
	
	assign alarm_flag = out_alarm_flag;



	`ifdef FORMAL
        logic f_obs;
		logic f_obs_d1;
		logic f_obs_d2;

		//logic f_obs_res;
		//logic f_alarm_res;

		//Declare when verifications is valid
        reg f_valid_1d = 1'b0;
        reg f_valid_2d = 1'b0;

		assign f_obs = (dist_v < MIN_DIST) ? 1'd1 : 1'd0;
		//assign f_obs_res = f_obs_d1 ^ obs_detected_out;
		//assign f_alarm_res = f_obs_d2 ^ alarm_flag;

		always @(posedge clk or negedge rstn) begin 
			if ( !rstn ) begin
				f_obs_d1 <= 1'd0;		
				f_obs_d2 <= 1'd0;
				f_valid_1d <= 1'd0;	
			end else begin
				f_obs_d1 <= f_obs;		
				f_obs_d2 <= f_obs_d1;	
				if (f_valid_1d) begin
					f_valid_2d <= 1'b1;
				end
				f_valid_1d <= 1'b1;
			end
		end
		

        always @(posedge clk) begin			
			if (~rstn) begin				
                assert_obs_detected_reset: assert (!obs_detected_out);                 
                assert_alarm_false_reset: assert (!alarm_flag);
            end else begin  		
				if (f_valid_1d) begin										
					//assert_obs_detected: assert ( !f_obs_res );	
					assert_obs_detected1: assert ( !( f_obs_d1) ||  obs_detected_out );
					assert_obs_detected2: assert ( !(!f_obs_d1) || !obs_detected_out );
				end 	
				if (f_valid_2d) begin					
					//assert_alarm: assert ( !f_alarm_res );
					assert_alarm1: assert ( !( f_obs_d2) ||  alarm_flag );
					assert_alarm2: assert ( !(!f_obs_d2) || !alarm_flag );
				end
            end 

			//COVER	
			//cov_dist_zero: cover ( dist_v == 16'h0000);
			//cov_dist_one:  cover ( dist_v == 16'h7FFF); 
			//
			//cov_obs_detected_out_zero: cover (obs_detected_out); 
			//cov_obs_detected_out_one:  cover (!obs_detected_out);
			//
			//cov_alarm_zero: cover (alarm_flag); 
			//cov_alarm_one:  cover (!alarm_flag);
			
        end

    `endif 

endmodule

