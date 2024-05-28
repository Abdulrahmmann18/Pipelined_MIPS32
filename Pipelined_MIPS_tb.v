module Pipelined_MIPS_tb();
	// signal declaration
	reg clk, rst;
	// DUT Instantiation
	Pipelined_MIPS DUT (clk, rst);
	// clk generation block
	initial begin
		clk = 0;
		forever
			#4 clk = ~clk;
	end
	// test stimulus 
	initial begin
		rst = 1;
		#50;
		rst = 0;
		repeat (1000) begin
			@(negedge clk);
		end
		$stop;
	end
endmodule