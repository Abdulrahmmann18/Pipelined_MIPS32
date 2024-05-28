module Data_MEM #(parameter MEM_WIDTH = 32, MEM_DEPTH = 1024, ADDR_SIZE = 32)
(
	input wire 				   clk,
	input wire 				   rst,
	input wire 				   MemWrite,
	input wire 				   MemRead,
	input wire [ADDR_SIZE-1:0] addr, 
	input wire [MEM_WIDTH-1:0] wr_data, 
	output reg [MEM_WIDTH-1:0] rd_data
);

	// declaration of memory
	reg [MEM_WIDTH-1:0] D_mem [MEM_DEPTH-1:0];

	integer i;
	// write operation with clock
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			for (i=0; i<31; i=i+1) begin
				D_mem[i] <= i;
			end	
		end	
		else if (MemWrite) begin
			D_mem[addr] <= wr_data; 
		end
	end
	// read data 
	always @(*) begin
		rd_data = 'b0;
		if (MemRead) begin
			rd_data = D_mem[addr];
		end
		else
			rd_data = 'b0;
	end
endmodule