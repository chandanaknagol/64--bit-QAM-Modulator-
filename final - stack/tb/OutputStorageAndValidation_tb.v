`timescale 1ns / 1ps

module OutputStorageAndValidation_tb;

    // Inputs
    reg clk = 0;
    reg rst = 1;
    reg [11:0] data_filter;
    reg valid_data = 0;
    reg [8:0] upsampling_rate;

    // Outputs
    wire [9:0] I_out;

    // Instantiate the DUT
    OutputStorageAndValidation dut (
        .clk(clk),
        .rst(rst),
        .data_filter(data_filter),
        .valid_data(valid_data),
        .upsampling_rate(upsampling_rate),
        .I_out(I_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Reset
        rst = 0;
        #10 rst = 1;
data_filter = 12'h000;
        valid_data = 0;
        upsampling_rate = 9'b0;

        // Test case 1: Valid data
        data_filter = 12'b101010101010;
        valid_data = 1;
        #100;

        // Test case 2: Invalid data
        data_filter = 12'b010101010101;
        valid_data = 0;
        #100;

        // End simulation
        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("At time %t, I_out = %b", $time, I_out);
    end

endmodule
