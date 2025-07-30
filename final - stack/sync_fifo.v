module ff_synchoniser_1bit(
     input wire rst_n,
	 input wire  clk,
	 input wire  data_in,
	 output reg  data_out
	 );
	 
	 reg 		     data_mid;

   // write sequential logic, active-low asynch reset
   always @(posedge clk or negedge rst_n)
     begin
	if (rst_n == 1'b0) begin
	   // reset all registers to default values
	   data_out <= 1'b0;
	   data_mid <= 1'b0;
	end else begin
	   data_out <= data_mid;
	   data_mid <= data_in;
	end 
  end
  
 endmodule 