module Instruction_MEM #(parameter MEM_WIDTH = 32, MEM_DEPTH = 1024, ADDR_SIZE = 32)
(
	input wire  [ADDR_SIZE-1:0] Instruction_addr,
	output wire [MEM_WIDTH-1:0] Instruction_Data
);
	

	// declaration of memory
	reg [MEM_WIDTH-1:0] I_mem [MEM_DEPTH-1:0];
	// initialize instruction memory
	initial begin
		// the program to be excuted
		I_mem[0]  = 32'b000000_01000_01001_10001_00000_100000;  // add $s1, $t0, $t1    	32'h01098820
		I_mem[1]  = 32'b101011_00000_10001_0000000000000100;    // sw $s1, 4($zero)			32'hAC110004
		I_mem[2]  = 32'b100011_00000_01010_0000000000000100;    // lw $t2, 4($zero)			32'h8C0A0004
		I_mem[3]  = 32'b000000_01010_01011_01000_00000_100010;  // sub $t0, $t2, $t3    	32'h014B4022
		I_mem[4]  = 32'b000100_01000_01000_0000000000000010;    // beq $t0, $t0, again   	32'h11080001   (should branch to address 20+8 = 28 (I_mem[7]) if $t0 == $t0)      
		I_mem[5]  = 32'b100011_00000_01010_0000000000000100;    // lw $t2, 4($zero)			32'h8C0A0004
		I_mem[6]  = 32'b000000_01010_01011_01000_00000_100010;  // sub $t0, $t2, $t3    	32'h014B4022
		I_mem[7]  = 32'b000000_01000_10000_10100_00000_100000;  // add $s4, $t0, $s0    	32'h01098820
		/*                                                                          // instructions in hex
		I_mem[0]  = 32'b000000_01000_01001_10001_00000_100000;  // add $s1, $t0, $t1    	32'h01098820
		I_mem[1]  = 32'b000000_10001_00000_10010_00000_100000;  // add $s2, $s1, $0     	32'h02209020
		I_mem[2]  = 32'b000000_01000_01001_10010_00000_100010;  // sub $s2, $t0, $t1    	32'h01099022
		I_mem[3]  = 32'b000000_01010_01011_01000_00000_100010;  // sub $t0, $t2, $t3    	32'h014B4022
		I_mem[4]  = 32'b000000_01000_01001_10000_00000_100100;  // and $s0, $t0, $t1    	32'h01098024
		I_mem[5]  = 32'b000000_01001_01010_01011_00000_100100;  // and $t3, $t1, $t2    	32'h012A5824
		I_mem[6]  = 32'b000000_01000_01001_10000_00000_100101;  // or $s0, $t0, $t1     	32'h01098025
		I_mem[7]  = 32'b000000_10010_10011_01000_00000_100101;  // or $t0, $s2, $s3     	32'h02534025
		I_mem[8]  = 32'b000000_01001_01010_01001_00000_101010;  // slt $t1, $t1, $t2		32'h012A482A
		I_mem[9]  = 32'b000000_01000_01100_10000_00000_101010;  // slt $s0, $t0, $t4    	32'h010C802A
		I_mem[10] = 32'b000000_01010_01011_01001_00000_100111;  // nor $t1, $t2, $t3    	32'h014B4827
		I_mem[11] = 32'b000000_01000_01010_10000_00000_100111;  // nor $s0, $t0, $t2    	32'h010A8027
		I_mem[12] = 32'b000100_10000_10010_0000000000000010;    // beq $s0, $s2, delay      32'h12120002   (should branch to address 52+8 = 60 if $s0 == $s2)
		I_mem[13] = 32'b000100_01000_01011_0000000000000100;    // beq $t0, $t3, again   	32'h110B0004   (should branch to address 56+16 = 72 if $t0 == $t3)      
		I_mem[14] = 32'b101011_00000_10000_0000000000000100;    // sw $s0, 4($zero)			32'hAC100004
		I_mem[15] = 32'b101011_10000_01000_0000000000001000;    // sw $t0, 8($s0)           32'hAE080008
		I_mem[16] = 32'b100011_00000_10001_0000000000000100;    // lw $s1, 4($zero)			32'h8C110004
		I_mem[17] = 32'b100011_01000_01010_0000000000010000;    // lw $t2, 16($t0)			32'h8D0A0010
		I_mem[18] = 32'b000010_00000000000000000000001110;      // j end                    32'h0800000E   (should jump to address 56)
		*/
	end
	
	// instruction word
	assign Instruction_Data = I_mem [Instruction_addr[31:2]] ;


endmodule