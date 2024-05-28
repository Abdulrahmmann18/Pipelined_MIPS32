module ALU #(parameter DATA_WIDTH = 32)
(
	input wire [DATA_WIDTH-1:0] Src1,
	input wire [DATA_WIDTH-1:0] Src2,
	input wire [3:0]  			ALU_control,
	output reg [DATA_WIDTH-1:0] ALU_result,
	output wire 				Zero_flag
);

	always @(*) begin
		ALU_result = 'b0; // invalid
		case(ALU_control)
			4'b0000 : ALU_result = Src1 & Src2;  				// AND operation
			4'b0001 : ALU_result = Src1 | Src2;  				// OR operation
			4'b0010 : ALU_result = Src1 + Src2;  				// ADD operation
			4'b0110 : ALU_result = Src1 - Src2;  				// SUB operation
			4'b0111 : ALU_result = (Src1 < Src2) ? 'b1 : 'b0 ;  // SET-ON-LESS-THAN operation
			4'b1100 : ALU_result = ~(Src1 | Src2);				// NOR operation
			default : ALU_result = 'b0; 						// invalid
		endcase
	end
	assign Zero_flag = (Src1 == Src2) ? 1'b1 : 1'b0 ;
	
endmodule