module shift_circuit #(parameter DATA_WIDTH = 32, SHIFT_AMOUNT = 2, SHIFT_DIRECTION = "LEFT" /* "RIGHT" */)
(
	input wire  [DATA_WIDTH-1:0] shift_left_in,
	output wire [DATA_WIDTH-1:0] shift_left_out
);
	
	generate
		if (SHIFT_DIRECTION == "LEFT") begin
			assign shift_left_out = shift_left_in << SHIFT_AMOUNT ;
		end
		else if (SHIFT_DIRECTION == "RIGHT") begin
			assign shift_left_out = shift_left_in >> SHIFT_AMOUNT ;
		end
	endgenerate
	
endmodule