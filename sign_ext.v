module sign_ext #(parameter IN_WIDTH = 16, OUT_WIDTH = 32)
(
	input wire  [IN_WIDTH-1:0]  sign_ext_IN,
	output wire [OUT_WIDTH-1:0] sign_ext_OUT
);
	localparam EXT_WIDTH = OUT_WIDTH - IN_WIDTH;
	
	assign sign_ext_OUT = { {EXT_WIDTH{sign_ext_IN[IN_WIDTH-1]}}, sign_ext_IN} ;

endmodule