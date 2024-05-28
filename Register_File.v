module Register_File #(parameter MEM_WIDTH = 32, MEM_DEPTH = 32, ADDR_SIZE = 5)
(
	input wire 				    clk,
	input wire 				    rst,
	input wire 	     			RegWrite,
	input wire  [ADDR_SIZE-1:0] rd_addr1,
	input wire  [ADDR_SIZE-1:0] rd_addr2,
	input wire  [ADDR_SIZE-1:0] wr_addr,
	input wire  [MEM_WIDTH-1:0] wr_data,
	output wire [MEM_WIDTH-1:0] rd_data1,
	output wire [MEM_WIDTH-1:0] rd_data2
);

	// declaration of Register file memory
	reg [MEM_WIDTH-1:0] R_mem [MEM_DEPTH-1:0];

	// the operation of writing in register file
	integer i;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			/*
			for (i=0; i<31; i=i+1) begin
				R_mem[i] <= i;
			end
			*/
			R_mem[5'b00000] = 32'd0; // zero register $0
			R_mem[5'b00001] = 32'd1; // assembler temp $at
			R_mem[5'b00010] = 32'd2; // $v0
			R_mem[5'b00011] = 32'd3; // $v1
			R_mem[5'b00100] = 32'd4; // $a0
			R_mem[5'b00101] = 32'd5; // $a1
			R_mem[5'b00110] = 32'd6; // $a2
			R_mem[5'b00111] = 32'd7; // $a3
			R_mem[5'b01000] = 32'd8; // $t0
			R_mem[5'b01001] = 32'd9; // $t1
			R_mem[5'b01010] = 32'd10; // $t2
			R_mem[5'b01011] = 32'd11; // $t3
			R_mem[5'b01100] = 32'd12; // $t4
			R_mem[5'b01101] = 32'd13; // $t5
			R_mem[5'b01110] = 32'd14; // $t6
			R_mem[5'b01111] = 32'd15; // $t7
			R_mem[5'b10000] = 32'd16; // $s0
			R_mem[5'b10001] = 32'd17; // $s1
			R_mem[5'b10010] = 32'd18; // $s2
			R_mem[5'b10011] = 32'd19; // $s3
			R_mem[5'b10100] = 32'd20; // $s4
			R_mem[5'b10101] = 32'd21; // $s5
			R_mem[5'b10110] = 32'd22; // $s6
			R_mem[5'b10111] = 32'd23; // $s7
			R_mem[5'b11000] = 32'd24; // $t8
			R_mem[5'b11001] = 32'd25; // $t9
			R_mem[5'b11010] = 32'd26; // $k0
			R_mem[5'b11011] = 32'd27; // $k1
			R_mem[5'b11100] = 32'd28; // $gp
			R_mem[5'b11101] = 32'd29; // $sp
			R_mem[5'b11110] = 32'd30; // $fp
			R_mem[5'b11111] = 32'd31; // $ra
		end
		else if (RegWrite) 
				R_mem[wr_addr] <= wr_data;				
	end
	// the operation of reading from register file
	assign rd_data1 = R_mem[rd_addr1];
	assign rd_data2 = R_mem[rd_addr2];

endmodule