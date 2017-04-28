//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:       0416214/ÂæêÁ‰∫//----------------------------------------------
//Date:        2017/04/24
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(*)
begin
	if(ALUOp_i==3'b010)
	case(funct_i)
		6'h20:
			ALUCtrl_o<=4'b0010;	//add
		6'h22:
			ALUCtrl_o<=4'b0110;	//sub
		6'h24:
			ALUCtrl_o<=4'b0000;	//and
		6'h25:
			ALUCtrl_o<=4'b0001;	//or
		6'h2a:
			ALUCtrl_o<=4'b0111;	//slt
		6'h3:
			ALUCtrl_o<=4'b1000;	//sra
		6'h7:
			ALUCtrl_o<=4'b1000;	//srav
		default:
			ALUCtrl_o<=4'b0;
	endcase
	else
	case(ALUOp_i)
		3'b001:
			ALUCtrl_o<=4'b0110;	//beq bne
		3'b100:
			ALUCtrl_o<=4'b0010;	//addi
		3'b101:
			ALUCtrl_o<=4'b0111;	//sltiu
		3'b110:
			ALUCtrl_o<=4'b0001;	//ori
		3'b111:
			ALUCtrl_o<=4'b1100;	//lui
		default:
			ALUCtrl_o<=4'b0;
	endcase
end

endmodule     





                    
                    
