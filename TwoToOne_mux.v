module TwoToOne_mux #(parameter WIDTH = 32)
(
	input wire [WIDTH-1:0]  IN1,
	input wire [WIDTH-1:0]  IN2,
	input wire 			    sel,
	output wire	[WIDTH-1:0] mux_out
);

	assign mux_out = (~sel) ? IN1 : IN2 ;


endmodule