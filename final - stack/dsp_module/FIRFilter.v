`timescale 1ns / 1ps

module FIRFilter(
    input wire clk,
    input wire rst_n,
    input wire [3:0] x_n,  // 4-bit input data for the entire filter
    output wire [11:0] y_n  // 12-bit output data from the last DSP slice
);

parameter N = 71;  // Number of DSP slices / coefficients
integer j;

// Wires for chaining DSP slices
wire [3:0] x_out_wires[N:0];
wire [11:0] acc_out_wires[N:0];

// Coefficients are stored here once loaded
reg [7:0] coefficients[N-1:0];
reg coeff_loaded = 0;  // Flag to indicate all coefficients are loaded
reg signal;

// Address and data wires for CoeffRegisterArray
wire [7:0] coeff_out;
reg [6:0] coeff_addr;

reg [7:0] coeff_out_next;
reg [6:0] coeff_addr_next;
//reg load_coeffs = 1'b0;  // Control signal to start loading coefficients



// State machine to load coefficients from CoeffRegisterArray
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        coeff_addr <= 0;
        coeff_addr_next <= 0;
        coeff_out_next <= 0;
        coeff_loaded <= 0;
        signal <= 0;
        for(j=0;j<N;j++)
           coefficients[j] <= 1'b1;
    end else begin
        if (coeff_addr < N ) begin
            //coefficients[coeff_addr] <= coeff_out_next;
            coeff_addr <= coeff_addr_next;
        end else begin
            coeff_loaded <= 1;  // Signal that loading is complete
        end
    end
end

always @(*) begin
    if(rst_n && !signal) begin
        coeff_addr_next = coeff_addr + 1'b1;
    end
 end


genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin : dslice
        DSPSlice slice (
            .clk(clk),
            .rst_n(rst_n),
            .x_n( (i == 0) ? x_n : x_out_wires[i-1]),
            .coefficient(coefficients[i]),
            .acc_in((i == 0) ? 12'b0 : acc_out_wires[i-1]),
            .x_out(x_out_wires[i]),
            .acc_out(acc_out_wires[i])
        );
    end
endgenerate

// Output assignment
assign y_n = x_out_wires[N-1];  // The output from the last DSP slice

endmodule
