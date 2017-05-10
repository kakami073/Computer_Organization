//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:    0312012 0416214  
//
////Date:        2017/04/24
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	BranchType_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemToReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output 			   BranchType_o;
output 				 Jump_o;
output 				 MemRead_o;
output 				 MemWrite_o;
output 				 MemToReg_o;
 

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg   			   BranchType_o;
reg   				 Jump_o;
reg   				 MemRead_o;
reg   				 MemWrite_o;
reg   				 MemToReg_o;

//Parameter


//Main function
always@(instr_op_i)
begin
	case(instr_op_i)
		6'h0:
			ALU_op_o<=3'b010;
		6'h4:	//beq
			ALU_op_o<=3'b001;
		6'h5:	//bne
			ALU_op_o<=3'b001;
		6'h8:	//addi
			ALU_op_o<=3'b100;
		6'h9:	//sltiu
			ALU_op_o<=3'b101;
		6'hd:	//ori
			ALU_op_o<=3'b110;
		6'hf:	//lui
			ALU_op_o<=3'b111;
		default:
			ALU_op_o<=3'b000;
	endcase
end

always@(instr_op_i)
begin
	if(instr_op_i==6'b0||instr_op_i==6'b000100||instr_op_i==6'b000101)
		ALUSrc_o<=0;
	else
		ALUSrc_o<=1;
end

always@(instr_op_i)
begin
	if(instr_op_i==6'h0)
		RegDst_o<=1;
	else
		RegDst_o<=0;	//0 when load
end

always@(instr_op_i)
begin
	if(instr_op_i==6'h4||instr_op_i==6'h5)
		Branch_o<=1;
	else
		Branch_o<=0;
end

always@(instr_op_i)
begin
	if(instr_op_i==6'h4||instr_op_i==6'h5)
		RegWrite_o<=0;
	else
		RegWrite_o<=1;
end

always@(BranchType_o)
begin
	case(instr_op_i[31:26])
		6'd4: 
			BranchType_o <= 0; // bne
		6'd6:
			BranchType_o <= 1; // ble
		6'd1:
			BranchType_o <= 2; // bltz
		default:
			BranchType_o <= 3; // bnez(bne)
end

always@(Jump_o)
begin
	if(instr_op_i[31:26] == 6'd2 || instr_op_i[31:26] == 6'd3) // how to implement 'jr'?
		Jump_o <= 1;
	else
		Jump_o <= 0;
end

always@(MemRead_o)
begin
	if(instr_op_i[31:26] == 6'd35) // if 'lw' 
		MemRead_o <= 1;
	else
		MemRead_o <= 0;
end

always@(MemWrite_o,)
begin
	if(instr_op_i[31:26] == 6'd43) // if 'sw' 
		MemWrite_o <= 1;
	else
		MemWrite_o <= 0;
end
	
always@(MemToReg_o)
begin
	if(instr_op_i[31:26] == 6'd35) // if 'lw' 
		MemToReg_o <= 1;
	else
		MemToReg_o <= 0;
	
end

endmodule





                    
                    
