`timescale 1ns / 1ps

module dsp_interface(
    input wire clk,  // Clock for the operation (presumably the upsampling clock)
    input wire rst_n,  // Active-low reset
    input wire [3:0] data_in,
   // input wire [3:0] I,
  // input wire [3:0] Q,
 // input wire [11:0] I_filter,  // Filtered I-channel data
   // input wire [11:0] Q_filter,  // Filtered Q-channel data
   // input wire valid_data,  // Signal indicating data validity from the filter
   // input wire [8:0] upsampling_rate,  // Upsampling rate, affects packet size
    output reg [9:0] I_out,  // Validated I-channel output to DAC
    output reg [9:0] Q_out,  // Validated Q-channel output to DAC
 //   input wire spi_read,  // SPI read signal for reading stored samples
  //  input wire [7:0] spi_address,  // SPI address for accessing specific samples
    output reg [8:0] spi_data_out  // Data output for SPI interface
//output reg [11:0] filtered_output  // Declare filtered_output as an output
);


    // Instantiate Upsampler
    upsampler upsamp_inst(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(upsampled_data)
    );

    // Instantiate FIR Filter
    FIRFilter fir_filter_inst(
        .clk(clk),
        .x_n(upsampled_data),
        .write_en(write_en),
        .coefficient(coefficient),
        .addr(addr), 
        .y_n(filtered_output)
    );


// Instantiate storage and validator
OutputStorageAndValidation output_storage_inst (
	.clk(clk),
	.rst_n(rst),
	.I_filter(I_filter),
	.Q_filter(Q_filter),
	.valid_data(valid_data),
	.upsampling_rate(upsampling_rate),
	.I_out(I_out),
	.Q_out(Q_out),
	.spi_read(spi_read),
	.spi_address(spi_address),
	.spi_data_out(spi_out_data)
);

endmodule
