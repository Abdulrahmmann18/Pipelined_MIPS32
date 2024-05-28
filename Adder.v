module Adder #(parameter WIDTH = 32)
(
	input wire  [WIDTH-1:0] operand1,
	input wire  [WIDTH-1:0] operand2,
	output wire [WIDTH-1:0] result
);

	assign result = operand1 + operand2 ;


endmodule