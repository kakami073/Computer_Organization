//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0416214/ÂæêÁ‰∫//----------------------------------------------
//Date:        2017/04/24
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

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


endmodule





                    
                    