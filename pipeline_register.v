module pipeline_register #(parameter DATA_SIZE = 32)
(
	input wire 				   clk,
	input wire 				   rst,
	input wire 				   Hold_data,
	input wire [DATA_SIZE-1:0] data_in,
	output reg [DATA_SIZE-1:0] data_out
);

	always @(posedge clk or posedge rst) begin
		if (rst) 
			data_out <= 'b0;

		else if (~Hold_data) 
				data_out <= data_in;
	end


endmodule