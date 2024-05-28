module FourToOne_mux #(parameter WIDTH = 32)
(
	input wire [WIDTH-1:0] IN0,
	input wire [WIDTH-1:0] IN1,
	input wire [WIDTH-1:0] IN2,
	input wire [WIDTH-1:0] IN3,
	input wire [1:0] 	   sel,
	output reg [WIDTH-1:0] mux_out
);

	always @(*) begin
		mux_out = 'b0;
		case (sel)
			2'b00 : mux_out = IN0;
			2'b01 : mux_out = IN1;
			2'b10 : mux_out = IN2;
			2'b11 : mux_out = IN3;
		endcase
	end

endmodule