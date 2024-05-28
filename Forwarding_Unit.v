module Forwarding_Unit 
(
	input wire 		 EX_MEM_RegWrite,
	input wire 		 MEM_WB_RegWrite,
	input wire [4:0] ID_EX_RS_field,
	input wire [4:0] ID_EX_RT_field,
	input wire [4:0] EX_MEM_RD_field,
	input wire [4:0] MEM_WB_RD_field,
	output reg [1:0] ForwardA,
	output reg [1:0] ForwardB
);

	// always block for ForwardA
	always @(*) begin
		if ( (EX_MEM_RegWrite) && (EX_MEM_RD_field != 5'd0) && (EX_MEM_RD_field == ID_EX_RS_field) ) begin
			ForwardA = 2'b10;
		end
		else if ( (MEM_WB_RegWrite) && (MEM_WB_RD_field != 5'd0) && (MEM_WB_RD_field == ID_EX_RS_field) ) begin
			ForwardA = 2'b01;
		end
		else begin
			ForwardA = 2'b00;
		end
	end

	// always block for ForwardB
	always @(*) begin
		if ( (EX_MEM_RegWrite) && (EX_MEM_RD_field != 5'd0) && (EX_MEM_RD_field == ID_EX_RT_field) ) begin
			ForwardB = 2'b10;
		end
		else if ( (MEM_WB_RegWrite) && (MEM_WB_RD_field != 5'd0) && (MEM_WB_RD_field == ID_EX_RT_field) ) begin
			ForwardB = 2'b01;
		end
		else begin
			ForwardB = 2'b00;
		end
	end

endmodule