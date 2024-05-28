module Decode_stage
(
	input wire		   clk,
	input wire 		   rst,
	input wire 		   Stall_EN,
	input wire 		   MEM_WB_RegWrite,
	input wire  [4:0]  MEM_WB_wr_addr,
	input wire  [31:0] MEM_WB_wr_data,
	input wire  [31:0] IF_ID_PC_plus4,
	input wire  [31:0] IF_ID_Instruction,
	input wire  [31:0] PC_OUT_plus4,
	output wire [4:0]  IF_ID_rs_field, // output for load_use_hazard_unit
	output wire [4:0]  IF_ID_rt_field, // output for load_use_hazard_unit
	output wire [4:0]  ID_EX_rs_field,
	output wire [4:0]  ID_EX_rt_field,
	output wire [4:0]  ID_EX_rd_field,
	output wire [7:0]  ID_EX_CU_signals,
	output wire [31:0] pc_in,
	output wire [31:0] ID_EX_rd_data1,
	output wire [31:0] ID_EX_rd_data2,
	output wire [31:0] ID_EX_sign_ext_OUT
);

	///////////////////////////////////////////////////////// wires declarartion //////////////////////////////////////////////////////
	wire IF_ID_RegDst, IF_ID_Jump, IF_ID_Branch, IF_ID_MemWrite, IF_ID_MemRead, IF_ID_MemToReg, IF_ID_ALUSrc, IF_ID_RegWrite;
	wire Jump, Branch, RegDst, ALUSrc, MemWrite, MemRead, MemToReg, RegWrite, Branch_taken;
	wire [1:0] IF_ID_ALUOp, ALUOp;
	wire [4:0] IF_ID_rd_field;
	wire [5:0] IF_ID_OPCODE_field, IF_ID_FUNCTION_field;
	wire [9:0] CU_signals, IF_ID_CU_signals;
	wire [15:0] IF_ID_branch_16bit_field;
	wire [25:0] IF_ID_jump_26bit_field;
	wire [31:0] IF_ID_rd_data1, IF_ID_rd_data2, IF_ID_sign_ext_OUT, shift_left_branch, branch_address, pc_src1;
	wire [118:0] ID_EX_Register_in, ID_EX_Register_out;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	//////////////////////////////////////////////////////// wires assignments ////////////////////////////////////////////////////////
	assign CU_signals = { Jump, Branch, RegDst, ALUSrc, ALUOp, MemWrite, MemRead, MemToReg, RegWrite} ;
	assign { IF_ID_Jump, IF_ID_Branch, IF_ID_RegDst, IF_ID_ALUSrc, IF_ID_ALUOp,
	  		 IF_ID_MemWrite, IF_ID_MemRead, IF_ID_MemToReg, IF_ID_RegWrite } = IF_ID_CU_signals ;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////// modules instantiation /////////////////////////////////////////////////////
	// instruction decoding 
	Instruction_decoding dec (
		.Instruction_Data(IF_ID_Instruction), .rs_field(IF_ID_rs_field), .rt_field(IF_ID_rt_field),
		.rd_field(IF_ID_rd_field), .branch_16bit_field(IF_ID_branch_16bit_field),
		.jump_26bit_field(IF_ID_jump_26bit_field), .opcode_field(IF_ID_OPCODE_field), .function_field(IF_ID_FUNCTION_field)
	);

	// control unit Instantiation
	Control_Unit CU (
		.opcode(IF_ID_OPCODE_field), .RegDst(RegDst), .Jump(Jump), .Branch(Branch),
		.MemRead(MemRead), .MemToReg(MemToReg), .ALUOp(ALUOp), 
		.MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite)
	);

	// control unit mux
	TwoToOne_mux #(10) CU_mux (
		.IN1(CU_signals), .IN2(10'b0),
		.sel(Stall_EN), .mux_out(IF_ID_CU_signals)
	);

	// register file instantiation
	Register_File R_F (
		.clk(clk), .rst(rst), .RegWrite(MEM_WB_RegWrite), .rd_addr1(IF_ID_rs_field), .rd_addr2(IF_ID_rt_field),
		.wr_addr(MEM_WB_wr_addr), .wr_data(MEM_WB_wr_data), .rd_data1(IF_ID_rd_data1), .rd_data2(IF_ID_rd_data2)
	); 

	// sign extension instantiation
	sign_ext sign_ext (
		.sign_ext_IN(IF_ID_branch_16bit_field), .sign_ext_OUT(IF_ID_sign_ext_OUT)
	);

	// shift left for branch instruction
	shift_circuit sh1 (
		.shift_left_in(IF_ID_sign_ext_OUT), .shift_left_out(shift_left_branch)
	);

	// branch predictor Instantiation
	Branch_predictor BR_INST (
		.rd_reg1_data(IF_ID_rd_data1), .rd_reg2_data(IF_ID_rd_data2),
		.branch(IF_ID_Branch), .Branch_taken(Branch_taken)
	);

	// branch adder
	Adder branch_adder (
		.operand1(IF_ID_PC_plus4), .operand2(shift_left_branch), .result(branch_address)
	);

	// pcsrc mux
	TwoToOne_mux pc_src_mux (
		.IN1(PC_OUT_plus4), .IN2(branch_address),
		.sel(Branch_taken), .mux_out(pc_src1)
	);

	// pc_in mux
	TwoToOne_mux pc_in_mux (
		.IN1(pc_src1), .IN2({IF_ID_PC_plus4[31:28], IF_ID_jump_26bit_field, 2'b00}),
		.sel(IF_ID_Jump), .mux_out(pc_in)
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////// pipeline register ///////////////////////////////////////////////////////////////

	assign ID_EX_Register_in = { IF_ID_CU_signals[7:0], IF_ID_rd_data1, IF_ID_rd_data2, IF_ID_sign_ext_OUT, 
								 IF_ID_rs_field, IF_ID_rt_field, IF_ID_rd_field } ;

	pipeline_register #(119) ID_EX_INST (
		.clk(clk), .rst(rst), .Hold_data(0), .data_in(ID_EX_Register_in), .data_out(ID_EX_Register_out)
	);
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// outputs
	assign ID_EX_CU_signals     = ID_EX_Register_out[118:111] ;  // the control signals except branch and jump becouse we dont need them anymore 
	assign ID_EX_rd_data1       = ID_EX_Register_out[110:79] ;
	assign ID_EX_rd_data2       = ID_EX_Register_out[78:47] ;
	assign ID_EX_sign_ext_OUT   = ID_EX_Register_out[46:15] ;
	assign ID_EX_rs_field 		= ID_EX_Register_out[14:10] ;
	assign ID_EX_rt_field 		= ID_EX_Register_out[9:5] ;
	assign ID_EX_rd_field  		= ID_EX_Register_out[4:0] ;

endmodule