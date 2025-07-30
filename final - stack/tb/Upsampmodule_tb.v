/*`timescale 1ns / 1ps

module Upsampmodule_tb;

    reg clk;
    reg rst;
    reg [3:0] data_in;
  //  reg [3:0] I;
  //  reg [3:0] Q;
    reg valid_data;
    reg [8:0] upsampling_rate;
    wire [9:0] I_out;
  //  wire [9:0] Q_out;
  //  reg spi_read;
  //  reg [7:0] spi_address;
  //  wire [11:0] spi_data_out;

    // Instantiate the top module
    Upsampmodule dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
      //  .valid_data(valid_data),
      //  .upsampling_rate(upsampling_rate),
        .I_out(I_out)
      //  .Q_out(Q_out)
       //.spi_read(spi_read),
       // .spi_address(spi_address),
     //   .spi_data_out(spi_data_out)
    );


    always #5 clk = ~clk;

    initial begin

        rst = 1;
        clk = 0;
        data_in = 0;
        valid_data = 0;
        upsampling_rate = 9'b0;
     //   spi_read = 0;
     //   spi_address = 8'b0; 
        #20 rst = 0;  
        #10 data_in = 4'b1010; 
        #10 valid_data = 1;
        #10 data_in = 4'b0101;
       #10 valid_data = 1; 

        #10 $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("At time %t, I_out = %b", $time, I_out);
    end

endmodule

*/

`timescale 1ns / 1ps

module Upsampmodule_tb;

    // Declare signals
    reg clk;
    reg rst;
    reg [3:0] data_in;
    reg signed [6:0] addr;
    reg signed [7:0] coefficient;
    reg write_en;
    reg valid_data;
    reg [8:0] upsampling_rate;
    wire [9:0] I_out;
    wire [11:0] filtered_output;

integer i;

    // Instantiate the DUT 
    Upsampmodule dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .addr(addr),
        .coefficient(coefficient),
        .write_en(write_en),
        .valid_data(valid_data),
        .upsampling_rate(upsampling_rate),
        .I_out(I_out),
        .filtered_output(filtered_output)
    );

// Instantiate the OutputStorageAndValidation module
    OutputStorageAndValidation validation (
        .clk(clk),
        .rst(rst),
        .data_filter(filtered_output), // Connect filtered output to data_filter
        .valid_data(valid_data),
        .upsampling_rate(upsampling_rate),
        .I_out(I_out)
);
    // Clock generation
    always #5 clk = ~clk;

    // Initialize signals
    initial begin
        clk = 0;
        rst = 1;
        data_in = 4'b0000;
        addr = 7'b0000000;
for (i=0; i <=70; i = i+1) begin
	 write_en = 1'b1;
         addr  = i;
         coefficient   = i;
	 @(negedge clk);	 
      end
	
      write_en = 1'b0;

        valid_data = 0;
        upsampling_rate = 9'b000000000;

        // Release reset after 20ns
        #20 rst = 0;

        // Test scenario
        // Your test scenario here
        // For example:
        #30 data_in = 4'b1010;
        #30 valid_data = 1;
        #100 data_in = 4'b0101;
        #100 valid_data = 1;
        #100 write_en = 1;
        #200 write_en = 0;

        // End test
        #100 $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("At time %t, I_out = %b, filtered_output = %b", $time, I_out, filtered_output);
    end

endmodule
