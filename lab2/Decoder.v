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
output [1:0]   RegDst_o;
output         Branch_o;
output [1:0]	   BranchType_o;
output 				 Jump_o;
output 				 MemRead_o;
output 				 MemWrite_o;
output [1:0]		 MemToReg_o;
 

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [1:0]   RegDst_o;
reg            Branch_o;
reg    [1:0]	   BranchType_o;
reg   				 Jump_o;
reg   				 MemRead_o;
reg   				 MemWrite_o;
reg    [1:0]		 MemToReg_o;

//Parameter


//Main function
always@(instr_op_i)
begin
	case(instr_op_i)
		6'h0: // R-type instr
			ALU_op_o<=3'b010;
		6'h1: //bltz
			ALU_op_o<=3'b001;
		6'h2: //j
			ALU_op_o<=3'b000; // don't care
		6'h3: //jal
			ALU_op_o<=3'b000; // don't care
		6'h4:	//beq
			ALU_op_o<=3'b001;
		6'h5:	//bne
			ALU_op_o<=3'b001;
		6'h6: //ble
			ALU_op_o<=3'b001;
		6'h8:	//addi
			ALU_op_o<=3'b100;
		6'h9:	//sltiu
			ALU_op_o<=3'b101;
		6'hf: //lui
			ALU_op_o<=3'b100; // same as addi
		6'h23: //lw
			ALU_op_o<=3'b100;
		6'h2b: //sw
			ALU_op_o<=3'b100;
		default:
			ALU_op_o<=3'b000; // don't care
	endcase
end

always@(instr_op_i)
begin
	if(instr_op_i[5:3]==3'b000) // include R-type, branch, J-type(don't care) instrctions
		ALUSrc_o<=0;
	else
		ALUSrc_o<=1;
end

always@(instr_op_i)
begin
	if(instr_op_i == 6'b000000) // R-type
		RegDst_o<=1;
	else if(instr_op_i[5] == 1'b1 || instr_op_i[5:3] == 3'b001) // load instr, imm instr
		RegDst_o<=0;
	else
		RegDst_o<=2;
end

always@(instr_op_i)
begin
	if(instr_op_i[5:2] == 4'b0001) // branch instr
		Branch_o<=1;
	else
		Branch_o<=0;
end

always@(instr_op_i)
begin
	if(instr_op_i[5:2] == 4'b0001 || instr_op_i == 6'b101011 || instr_op_i == 6'b000010)
		RegWrite_o<=0;
	else
		RegWrite_o<=1; // debug: can't identify jr(R-type)
end

always@(instr_op_i)
begin
	case(instr_op_i)
		6'd4: 
			BranchType_o <= 0; // beq
		6'd6:
			BranchType_o <= 1; // ble
		6'd1:
			BranchType_o <= 2; // bltz
		default:
			BranchType_o <= 3; // bnez(bne)
	endcase
end

always@(instr_op_i)//jr debug complete
begin
	if(instr_op_i[5:1] == 5'b00001) // J-type
		Jump_o <= 1;
	else
		Jump_o <= 0;
end

always@(instr_op_i)
begin
	if(instr_op_i == 6'd35) // lw 
		MemRead_o <= 1;
	else
		MemRead_o <= 0;
end

always@(instr_op_i)
begin
	if(instr_op_i[31:26] == 6'd43) // sw
		MemWrite_o <= 1;
	else
		MemWrite_o <= 0;
end
	
always@(instr_op_i)
begin
	if(instr_op_i[31:26] == 6'd35) // lw 
		MemToReg_o <= 1;
	else if(instr_op_i == 6'd3) // jal
		MemToReg_o <= 2;
	else
		MemToReg_o <= 0;
	
end

endmodule





                    
                    
