module ALU_Control_Unit
(
	input wire [1:0] ALUOp, 
	input wire [5:0] Function_field, 
	output reg [3:0] ALU_control
);
	

	always @(*) begin
		ALU_control = 4'b1111;  // invalid
		case (ALUOp)
			2'b00 : // LW and SW instructions
			begin
				ALU_control = 4'b0010; // add operation to add (base address + offset) 
			end
			2'b01 : // beq instruction
			begin
				ALU_control = 4'b0110; // subtract operation to subtract the two registers and branch if zero flag goes high
			end
			2'b10 : // R-type instructions 
			begin
				case (Function_field)
					6'b100000 : ALU_control = 4'b0010; // add
					6'b100010 : ALU_control = 4'b0110; // sub
					6'b100100 : ALU_control = 4'b0000; // AND
					6'b100101 : ALU_control = 4'b0001; // OR
					6'b101010 : ALU_control = 4'b0111; // slt
					6'b100111 : ALU_control = 4'b1100; // NOR
					default   : ALU_control = 4'b1111; // invalid
				endcase
			end
			default :
			begin
				ALU_control = 4'b1111;  // invalid
			end
		endcase
	end

endmodule