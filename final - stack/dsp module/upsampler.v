module upsampler (
    input clk,         
    input rst,          
    input [3:0] data_in, 
	input [3:0] frequency, 
    output reg [3:0] data_out);

reg [3:0] upsample_rate;
reg [3:0] counter = 0; 

always @(*) begin
upsample_rate = frequency;
end

always @(posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        counter <= 0; 
        data_out <= 4'b0;
    end
    else 
    begin
        if (counter == 0) 
	begin
            data_out <= data_in;
        end 
	else 
	begin
            data_out <= 4'b0;
        end
        counter <= counter + 1;
        if (counter == upsample_rate - 1) 
	begin
            counter <= 0;
        end
    end
end

endmodule

