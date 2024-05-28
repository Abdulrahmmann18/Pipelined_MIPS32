module Instruction_decoding #(parameter MEM_WIDTH = 32)
(
	input wire [MEM_WIDTH-1:0] Instruction_Data,
	output wire [4:0] 			rs_field,
	output wire [4:0] 			rt_field,
	output wire [4:0] 			rd_field,
	output wire [15:0] 			branch_16bit_field,
	output wire [25:0]          jump_26bit_field,
	output wire [5:0]			opcode_field,
	output wire [5:0] 			function_field
);
	assign rs_field     	  = Instruction_Data[25:21] ;  // rs field
	assign rt_field     	  = Instruction_Data[20:16] ;  // rt field
	assign rd_field  		  = Instruction_Data[15:11] ;  // rd field
	assign branch_16bit_field = Instruction_Data[15:0]  ;
	assign jump_26bit_field   = Instruction_Data[25:0]  ;
	assign opcode_field		  = Instruction_Data[31:26] ;
	assign function_field 	  = Instruction_Data[5:0]   ;

endmodule