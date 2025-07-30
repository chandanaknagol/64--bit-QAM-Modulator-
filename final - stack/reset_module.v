module reset_module(
     input wire rst_n,
	 input wire  spi_clk,
	 input wire  data_clk,
	 input wire  dsp_clk,
	 output reg  rst_spi,
	 output reg  rst_data,
	 output reg  rst_dsp
	 );
	 
	 wire spi_reset;
	 wire data_reset;
	 wire dsp_reset;
	 
	 always @(*) begin
	 rst_spi = spi_reset;
	 rst_data = data_reset;
	 rst_dsp = dsp_reset;
	 end
	 
	 
	 
    ff_synchoniser_1bit ff_spi(rst_n,spi_clk,1'b1,spi_reset);
    ff_synchoniser_1bit ff_data(rst_n & rst_spi,data_clk,1'b1,data_reset);
    ff_synchoniser_1bit ff_dsp(rst_n & rst_data,dsp_clk,1'b1,dsp_reset);

    
  
 endmodule 
