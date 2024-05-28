module Branch_predictor
(
	input wire		  branch,
	input wire [31:0] rd_reg1_data,
	input wire [31:0] rd_reg2_data,
	output wire		  Branch_taken
);

	
	assign Branch_taken = ((rd_reg1_data == rd_reg2_data) && branch) ? 1'b1 : 1'b0 ;

endmodule