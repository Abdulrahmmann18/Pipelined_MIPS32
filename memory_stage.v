module memory_stage
(
	input wire 		   clk,
	input wire 		   rst,
	input wire  [3:0]  EX_MEM_CU_signals,
	input wire  [4:0]  EX_MEM_wr_addr,
	input wire  [31:0] EX_MEM_ALU_result,
	input wire  [31:0] EX_MEM_DMEM_wr_data,
	output wire [1:0]  MEM_WB_CU_signals,
	output wire [4:0]  MEM_WB_wr_addr,
	output wire [31:0] MEM_WB_DMEM_rd_data,
	output wire [31:0] MEM_WB_ALU_result
 );

	////////////////////////////////////////////////////// wires declaraion ////////////////////////////////////////////////////
	wire EX_MEM_MemWrite, EX_MEM_MemRead;
	wire [31:0] EX_MEM_DMEM_rd_data;
	wire [70:0] MEM_WB_Register_in, MEM_WB_Register_out;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////// wires assignments ////////////////////////////////////////////////////
	assign EX_MEM_MemWrite = EX_MEM_CU_signals[3] ;
	assign EX_MEM_MemRead  = EX_MEM_CU_signals[2] ;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////// modules instantiation ////////////////////////////////////////////////

	// Data memory instantiation
	Data_MEM DMEM (
		.clk(clk), .MemWrite(EX_MEM_MemWrite), .MemRead(EX_MEM_MemRead), .addr(EX_MEM_ALU_result),
		.wr_data(EX_MEM_DMEM_wr_data), .rd_data(EX_MEM_DMEM_rd_data)
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////// pipeline register ///////////////////////////////////////////////////

	assign MEM_WB_Register_in = { EX_MEM_CU_signals[1:0], EX_MEM_DMEM_rd_data, EX_MEM_ALU_result, EX_MEM_wr_addr } ;

	pipeline_register #(71) MEM_WB_INST (
		.clk(clk), .rst(rst), .Hold_data(0), .data_in(MEM_WB_Register_in), .data_out(MEM_WB_Register_out)
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// outputs 
	assign MEM_WB_CU_signals   = MEM_WB_Register_out[70:69] ;
	assign MEM_WB_DMEM_rd_data = MEM_WB_Register_out[68:37] ;
	assign MEM_WB_ALU_result   = MEM_WB_Register_out[36:5] ;
	assign MEM_WB_wr_addr      = MEM_WB_Register_out[4:0] ;

endmodule