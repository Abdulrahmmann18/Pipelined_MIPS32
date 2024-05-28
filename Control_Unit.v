module Control_Unit
(
	input wire [5:0] opcode,
	output reg 		 RegDst,
	output reg 		 Jump, 
	output reg 		 Branch, 
	output reg 		 MemRead, 
	output reg 		 MemToReg, 
	output reg [1:0] ALUOp, 
	output reg 		 MemWrite, 
	output reg 		 ALUSrc, 
	output reg 		 RegWrite
);

	always @(*) begin
		// default
		RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; MemToReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; ALUOp = 2'b00;
		case (opcode)
			6'b000000 : // R-type instruction
			begin
				RegDst = 1; Jump = 0; Branch = 0; MemRead = 0; MemToReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 1; ALUOp = 2'b10;
			end
			6'b100011 : // LW instruction
			begin
				RegDst = 0; Jump = 0; Branch = 0; MemRead = 1; MemToReg = 1; MemWrite = 0; ALUSrc = 1; RegWrite = 1; ALUOp = 2'b00;
			end
			6'b101011 : // SW instruction
			begin
				RegDst = 1'dx; Jump = 0; Branch = 0; MemRead = 0; MemToReg = 1'dx; MemWrite = 1; ALUSrc = 1; RegWrite = 0; ALUOp = 2'b00;
			end
			6'b000100 : // beq instruction
			begin
				RegDst = 1'dx; Jump = 0; Branch = 1; MemRead = 0; MemToReg = 1'dx; MemWrite = 0; ALUSrc = 0; RegWrite = 0; ALUOp = 2'b01;
			end
			6'b000010 : // jump instruction
			begin
				RegDst = 1'dx; Jump = 1; Branch = 0; MemRead = 0; MemToReg = 1'dx; MemWrite = 0; ALUSrc = 1'dx; RegWrite = 0; ALUOp = 2'dx;
			end
			default :  // invalid opcode
			begin
				RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; MemToReg = 0; MemWrite = 0; ALUSrc = 0; RegWrite = 0; ALUOp = 2'b00;
			end

		endcase
	end
endmodule