module final_modulator(
		input wire spi_clk,
		input wire data_clk,
		input wire dsp_clk,
		input wire MOSI,
		input wire CSN,
		input wire rst_n,
		input wire data_in,
		output reg	  MISO,
		output reg	  MISO_enable

    );

wire rst_spi;
wire rst_data;
wire rst_dsp;

wire map, syn_map;
wire enable, syn_enable;

wire [7:0] write_data;
wire  [9:0] write_addr;
wire  [9:0]  read_addr_out;
wire [7:0]  read_data_in;

wire [7:0] IQ_baseband;
wire [3:0] I_data;
wire [3:0] Q_data;

assign IQ_baseband = {I_data,Q_data};

wire  enable_write_addr, enable_read_addr, enable_data_dsp2spi, enable_data_spi2dsp;

spi_interface u_spi(
			   .SCLK(spi_clk),
		     .MOSI(MOSI),
		     .CSN(CSN),
		     .rst_n(rst_spi),
		     .reg_read_data(read_data_in),
		     .MISO(MISO),
		     .MISO_enable(MISO_enable),
		     .reg_addr(read_addr_out),
		    .enable(enable),
		    .mapping(syn_map),
			 .read_empty(),
			 .write_data(write_data),
			 .write_addr(write_addr),
			 .reg_read_enable(enable_data_dsp2spi),
            .reg_write_enable(enable_read_addr),
           .fifo_write_data_enable(enable_data_spi2dsp),
             .fifo_write_addr_enable(enable_write_addr)
             
			 );
			 
		
baseband u_mapping(
             .clk(data_clk),
		     .data_in(data_in),
		     .rst_n(rst_data),
		     .I_data(I_data),
		     .Q_data(Q_data),
		     .enable(syn_enable),
			 .mapping(map)
);


// writing data from spi to dsp
fifo_v2_8bit u_writedata_cdc_8bit(
	     .write_clk(spi_clk),
	    .write_rst_n(rst_spi),
		.read_clk(dsp_clk),
	    .read_rst_n(rst_dsp),
	    .data_in(write_data),
	    .write_enable(enable_data_spi2dsp),
	    .read_enable(),
	    .data_out(),
	    .full(),
	    .empty()
);

// reading data from dsp to spi
fifo_v2_8bit u_readdata_cdc_8bit(
	    .write_clk(dsp_clk),
	    .write_rst_n(rst_dsp),
		.read_clk(spi_clk),
	    .read_rst_n(rst_spi),
	    .data_in(),
	    .write_enable(),
	    .read_enable(enable_data_dsp2spi),
	    .data_out(read_data_in),
	    .full(),
	    .empty()
);

// writing write address from spi to dsp
fifo_v2_10bit u_writeaddr_cdc_10bit(
	    .write_clk(spi_clk),
	    .write_rst_n(rst_spi),
		.read_clk(dsp_clk),
	    .read_rst_n(rst_dsp),
	    .data_in(write_addr),
	    .write_enable(enable_write_addr),
	    .read_enable(),
	    .data_out(),
	    .full(),
	    .empty()
);

// writing read address from spi to dsp
fifo_v2_10bit u_readaddr_cdc_10bit(
	    .write_clk(spi_clk),
	    .write_rst_n(rst_spi),
		.read_clk(dsp_clk),
	    .read_rst_n(rst_dsp),
	    .data_in(read_addr_out),
	    .write_enable(enable_read_addr),
	    .read_enable(),
	    .data_out(),
	    .full(),
	    .empty()
);

fifo_v2_8bit u_baseband2dsp_cdc(
	    .write_clk(data_clk),
	    .write_rst_n(rst_data),
		.read_clk(dsp_clk),
	    .read_rst_n(rst_dsp),
	    .data_in(IQ_baseband),
	    .write_enable(enable_read_addr),
	    .read_enable(),
	    .data_out(),
	    .full(),
	    .empty()
); 

dsp_interface u_dsp();

ff_synchoniser_1bit sync_map(rst_data,data_clk,map,syn_map);

ff_synchoniser_1bit sync_enable(rst_spi,spi_clk,enable,syn_enable);

reset_module u_rst(
	    .rst_n(rst_n),
	 .spi_clk(spi_clk),
	 .data_clk(data_clk),
	 .dsp_clk(sym_clk),
	 .rst_spi(rst_spi),
	 .rst_data(rst_data),
	 .rst_dsp(rst_dsp)
);
	    
	    	 

endmodule

