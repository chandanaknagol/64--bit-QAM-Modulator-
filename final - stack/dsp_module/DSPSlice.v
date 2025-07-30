module DSPSlice(
    input wire clk,
    input wire rst_n,
    input wire [3:0] x_n, // 4-bit input data
    input wire [7:0] coefficient, // 8-bit coefficient
    input wire [11:0] acc_in, // 12-bit accumulator input, 0 for the first slice
    output reg [3:0] x_out, // 4-bit output for the next DSP slice
    output reg [11:0] acc_out // 12-bit accumulator output, delayed
);

// Corrected internal registers for delays
reg [3:0] x_n_delay1, x_n_delay2; // Delay registers for x[n]
reg [11:0] mult_result; // For storing the immediate multiplication result
reg [11:0] mult_result_delay; // Delayed multiplication result for simulation processing time
reg [11:0] acc_temp; // Temporary accumulator register for holding delayed acc_out


// Sequential logic for handling delays and updating outputs
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        // Reset all registers on reset
        x_n_delay1 <= 4'b0;
        mult_result_delay <= 12'b0;
        acc_temp <= 12'b0;
        acc_out <= 12'b0;
        x_out <= 4'b0;
    end else begin
        x_n_delay1 <= x_n;
		
        x_out <= x_n_delay1;
        
		mult_result_delay <= x_out * coefficient;

		acc_out <= mult_result_delay + acc_in;
    end
end

endmodule