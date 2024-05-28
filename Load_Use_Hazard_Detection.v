module Load_Use_Hazard_Detection
(
	input wire 		 ID_EX_MemRead,
	input wire [4:0] ID_EX_RT_field,
	input wire [4:0] IF_ID_RS_field,
	input wire [4:0] IF_ID_RT_field,
	output reg 		 IF_ID_Hold_Data,
	output reg 		 HoldPC,
	output reg 		 stall_en
);


	always @(*) begin
		
		IF_ID_Hold_Data = 0;
		HoldPC 			= 0;
		stall_en 		= 0;
		
		if (ID_EX_MemRead && ((ID_EX_RT_field == IF_ID_RS_field) || (ID_EX_RT_field == IF_ID_RT_field))) begin
			IF_ID_Hold_Data = 1;
			HoldPC 			= 1;
			stall_en 		= 1;
		end
		else begin
			IF_ID_Hold_Data = 0;
			HoldPC 			= 0;
			stall_en 		= 0;
		end
	end

endmodule