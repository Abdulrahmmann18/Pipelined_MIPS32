module Pipelined_MIPS
(
	input wire clk,
	input wire rst
);


/* ******************************************************************* WIRES DECLARATION ***************************************************************** */ 
	wire HoldPC_top, Hold_data_top, Stall_EN_top, MEM_WB_RegWrite_top;
	wire [1:0] MEM_WB_CU_signals_top;
	wire [3:0] EX_MEM_CU_signals_top;
	wire [4:0] MEM_WB_wr_addr_top, IF_ID_rs_field_top, IF_ID_rt_field_top, ID_EX_rs_field_top, ID_EX_rt_field_top,
			   ID_EX_rd_field_top, EX_MEM_rd_field_top, EX_MEM_wr_addr_top;
	wire [7:0] ID_EX_CU_signals_top;
	wire [31:0] pc_in_top, PC_OUT_plus4_top, IF_ID_PC_plus4_top, IF_ID_Instruction_top, MEM_WB_wr_data_top,
				ID_EX_rd_data1_top, ID_EX_rd_data2_top, ID_EX_sign_ext_OUT_top, EX_MEM_ALU_result_top,
				EX_MEM_DMEM_wr_data_top, MEM_WB_DMEM_rd_data_top, MEM_WB_ALU_result_top;
	
/* ******************************************************************** WIRES ASIGNMENTS **************************************************************** */ 
	
								 

/* *************************************************************** MODULES INSTANTIATION ************************************************************* */ 
	// fetch stage
	fetch_stage fetch (
		.clk(clk), .rst(rst), .HoldPC(HoldPC_top), .Hold_data(Hold_data_top), .pc_in(pc_in_top),
		.PC_OUT_plus4(PC_OUT_plus4_top), .IF_ID_PC_plus4(IF_ID_PC_plus4_top), .IF_ID_Instruction(IF_ID_Instruction_top)
	);

	// decode stage
	Decode_stage decode (
		.clk(clk), .rst(rst), .Stall_EN(Stall_EN_top), .MEM_WB_RegWrite(MEM_WB_CU_signals_top[0]),
		.MEM_WB_wr_addr(MEM_WB_wr_addr_top), .MEM_WB_wr_data(MEM_WB_wr_data_top), .IF_ID_PC_plus4(IF_ID_PC_plus4_top),
		.IF_ID_Instruction(IF_ID_Instruction_top), .PC_OUT_plus4(PC_OUT_plus4_top), .IF_ID_rs_field(IF_ID_rs_field_top), 
		.IF_ID_rt_field(IF_ID_rt_field_top), .ID_EX_rs_field(ID_EX_rs_field_top), .ID_EX_rt_field(ID_EX_rt_field_top),
		.ID_EX_rd_field(ID_EX_rd_field_top), .ID_EX_CU_signals(ID_EX_CU_signals_top), .pc_in(pc_in_top),
		.ID_EX_rd_data1(ID_EX_rd_data1_top), .ID_EX_rd_data2(ID_EX_rd_data2_top), .ID_EX_sign_ext_OUT(ID_EX_sign_ext_OUT_top)
	);

	// excute stage
	Excute_stage excute (
		.clk(clk), .rst(rst), .EX_MEM_RegWrite(EX_MEM_CU_signals_top[0]), .MEM_WB_RegWrite(MEM_WB_CU_signals_top[0]),
		.IF_ID_rs_field(IF_ID_rs_field_top), .IF_ID_rt_field(IF_ID_rt_field_top), .ID_EX_rd_field(ID_EX_rd_field_top),
		.ID_EX_rs_field(ID_EX_rs_field_top), .ID_EX_rt_field(ID_EX_rt_field_top), .EX_MEM_rd_field(EX_MEM_rd_field_top), 
		.MEM_WB_rd_field(MEM_WB_wr_addr_top), .ID_EX_CU_signals(ID_EX_CU_signals_top), .ID_EX_rd_data1(ID_EX_rd_data1_top), 
		.ID_EX_rd_data2(ID_EX_rd_data2_top), .ID_EX_sign_ext_OUT(ID_EX_sign_ext_OUT_top), .MEM_WB_wr_data(MEM_WB_wr_data_top), 
		.HoldPC(HoldPC_top), .Hold_data(Hold_data_top), .Stall_EN(Stall_EN_top), .EX_MEM_CU_signals(EX_MEM_CU_signals_top),
		.EX_MEM_wr_addr(EX_MEM_wr_addr_top), .EX_MEM_ALU_result(EX_MEM_ALU_result_top), .EX_MEM_DMEM_wr_data(EX_MEM_DMEM_wr_data_top)
	);

	// memory stage
	memory_stage mem (
		.clk(clk), .rst(rst), .EX_MEM_CU_signals(EX_MEM_CU_signals_top), .EX_MEM_wr_addr(EX_MEM_wr_addr_top),
		.EX_MEM_ALU_result(EX_MEM_ALU_result_top), .EX_MEM_DMEM_wr_data(EX_MEM_DMEM_wr_data_top), 
		.MEM_WB_CU_signals(MEM_WB_CU_signals_top), .MEM_WB_wr_addr(MEM_WB_wr_addr_top), 
		.MEM_WB_DMEM_rd_data(MEM_WB_DMEM_rd_data_top), .MEM_WB_ALU_result(MEM_WB_ALU_result_top)
	);

	// write back stage
	TwoToOne_mux #(32) WR_ADDR (
		.IN1(MEM_WB_ALU_result_top), .IN2(MEM_WB_DMEM_rd_data_top),
		.sel(MEM_WB_CU_signals_top[1]), .mux_out(MEM_WB_wr_data_top)
	);


	
/* *************************************************************************************************************************************************** */

	
endmodule