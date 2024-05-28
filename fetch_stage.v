module fetch_stage
(
	input wire		   clk,
	input wire 		   rst,
	input wire 		   HoldPC,			  
	input wire 		   Hold_data,         
	input wire  [31:0] pc_in,			  
	output wire [31:0] PC_OUT_plus4,      
	output wire [31:0] IF_ID_PC_plus4,    
	output wire [31:0] IF_ID_Instruction  
);

	////////////////////////////////////////////////////// wires declaraion ////////////////////////////////////////////////////
	wire [31:0] PC_OUT, INSTRUCTION ;
	wire [63:0] IF_ID_Register_in, IF_ID_Register_out;
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	///////////////////////////////////////////////////// modules instantiation ////////////////////////////////////////////////	
	// PC module Instantiation
	pipeline_Program_Counter PC_INST (.clk(clk), .rst(rst), .Hold_pc(HoldPC), .pc_in(pc_in), .pc_out(PC_OUT));

	// instruction memory instantiation
	Instruction_MEM IMEM (
		.Instruction_addr(PC_OUT), .Instruction_Data(INSTRUCTION)
	);

	// pc+4 adder
	Adder pc_adder (
		.operand1(PC_OUT), .operand2(32'd4), .result(PC_OUT_plus4)
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////// pipeline register ///////////////////////////////////////////////////
	// IF_ID_REG
	assign IF_ID_Register_in = { PC_OUT_plus4, INSTRUCTION} ;
	pipeline_register #(64) IF_ID_INST (
		.clk(clk), .rst(rst), .Hold_data(Hold_data), .data_in(IF_ID_Register_in), .data_out(IF_ID_Register_out)
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	// outputs
	assign IF_ID_PC_plus4    = IF_ID_Register_out[63:32];
	assign IF_ID_Instruction = IF_ID_Register_out[31:0] ;
	

endmodule