module Execute_stage
(
	input wire 		   clk,
	input wire 		   rst,
	input wire 		   EX_MEM_RegWrite,
	input wire 		   MEM_WB_RegWrite,
	input wire  [4:0]  IF_ID_rs_field,
	input wire  [4:0]  IF_ID_rt_field,
	input wire  [4:0]  ID_EX_rd_field,
	input wire  [4:0]  ID_EX_rs_field,
	input wire  [4:0]  ID_EX_rt_field,
	input wire  [4:0]  EX_MEM_rd_field,
	input wire  [4:0]  MEM_WB_rd_field,
	input wire  [7:0]  ID_EX_CU_signals,
	input wire  [31:0] ID_EX_rd_data1,
	input wire  [31:0] ID_EX_rd_data2,
	input wire  [31:0] ID_EX_sign_ext_OUT,
	input wire  [31:0] MEM_WB_wr_data,
	output wire 	   HoldPC,
	output wire 	   Hold_data,
	output wire 	   Stall_EN,
	output wire [3:0]  EX_MEM_CU_signals,
	output wire [4:0]  EX_MEM_wr_addr,
	output wire [31:0] EX_MEM_ALU_result,
	output wire [31:0] EX_MEM_DMEM_wr_data
);

	////////////////////////////////////////////////////// wires declaraion ////////////////////////////////////////////////////
	wire ID_EX_MemRead, ID_EX_ALUSrc, ID_EX_RegDst, ID_EX_Zero_flag;
	wire [1:0] ID_EX_ALUOp, ForwardA, ForwardB;
	wire [5:0] ID_EX_Function_field;
	wire [4:0] ID_EX_wr_addr;
	wire [3:0] ID_EX_ALU_control;
	wire [31:0] ALU_Src1, ALU_Src2, ForwardB_MUX_OUT, ID_EX_ALU_result;
	wire [72:0] EX_MEM_Register_in, EX_MEM_Register_out;


	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////// wires assignments ////////////////////////////////////////////////////
	assign ID_EX_MemRead 		= ID_EX_CU_signals[1] ;
	assign ID_EX_ALUOp  		= ID_EX_CU_signals[5:4] ;
	assign ID_EX_Function_field = ID_EX_sign_ext_OUT[5:0] ;
	assign ID_EX_ALUSrc         = ID_EX_CU_signals[6] ;
	assign ID_EX_RegDst 		= ID_EX_CU_signals[7] ;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////// modules instantiation ////////////////////////////////////////////////
	// Hazard detiction unit Instantiation
	Load_Use_Hazard_Detection HZ_INST (
		.ID_EX_MemRead(ID_EX_MemRead), .ID_EX_RT_field(ID_EX_rt_field), .IF_ID_RS_field(IF_ID_rs_field),
		.IF_ID_RT_field(IF_ID_rt_field), .IF_ID_Hold_Data(Hold_data), .HoldPC(HoldPC), .stall_en(Stall_EN)
	);

	// ALU control unit Instantiation
	ALU_Control_Unit ALU_CU_INST (.ALUOp(ID_EX_ALUOp), .Function_field(ID_EX_Function_field), .ALU_control(ID_EX_ALU_control));

	// Forwarding unit Instantiation
	Forwarding_Unit FWD_INST (
		.EX_MEM_RegWrite(EX_MEM_RegWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite), .ID_EX_RS_field(ID_EX_rs_field),
		.ID_EX_RT_field(ID_EX_rt_field), .EX_MEM_RD_field(EX_MEM_rd_field), .MEM_WB_RD_field(MEM_WB_rd_field),
		.ForwardA(ForwardA), .ForwardB(ForwardB)
	);

	// alu src muxs
	FourToOne_mux FWDA_MUX (
		.IN0(ID_EX_rd_data1), .IN1(MEM_WB_wr_data), .IN2(EX_MEM_ALU_result),
		.IN3(ID_EX_rd_data1), .sel(ForwardA), .mux_out(ALU_Src1)
	);

	FourToOne_mux FWDB_MUX (
		.IN0(ID_EX_rd_data2), .IN1(MEM_WB_wr_data), .IN2(EX_MEM_ALU_result),
		.IN3(ID_EX_rs_field), .sel(ForwardB), .mux_out(ForwardB_MUX_OUT)
	);

	TwoToOne_mux ALU_Src2_mux (
		.IN1(ForwardB_MUX_OUT), .IN2(ID_EX_sign_ext_OUT),
		.sel(ID_EX_ALUSrc), .mux_out(ALU_Src2)
	);

	// wr_addr mux 
	TwoToOne_mux mux1 (
		.IN1(ID_EX_rt_field), .IN2(ID_EX_rd_field),
		.sel(ID_EX_RegDst), .mux_out(ID_EX_wr_addr)
	);

	// ALU Instantiation
	ALU ALU_INS (
		.Src1(ALU_Src1), .Src2(ALU_Src2), .ALU_control(ID_EX_ALU_control),
		.ALU_result(ID_EX_ALU_result), .Zero_flag(ID_EX_Zero_flag)
	);

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////// pipeline register ///////////////////////////////////////////////////
	assign EX_MEM_Register_in = { ID_EX_CU_signals[3:0], ID_EX_ALU_result, ForwardB_MUX_OUT, ID_EX_wr_addr} ;
	pipeline_register #(73) EX_MEM_INST (
		.clk(clk), .rst(rst), .Hold_data(0), .data_in(EX_MEM_Register_in), .data_out(EX_MEM_Register_out)
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// outputs
	assign EX_MEM_CU_signals = EX_MEM_Register_out[72:69];
	assign EX_MEM_ALU_result = EX_MEM_Register_out[68:37];
	assign EX_MEM_DMEM_wr_data  = EX_MEM_Register_out[36:5] ;
	assign EX_MEM_wr_addr 	 = EX_MEM_Register_out[4:0] ;

endmodule