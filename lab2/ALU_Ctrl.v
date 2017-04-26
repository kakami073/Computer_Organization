//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:       0416214/徐瑞亨
//----------------------------------------------
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
	if(ALUOp_i==0)
	case(funct_i)
		6'h20:
			ALUCtrl_o<=	//add
		6'h22:
			ALUCtrl_o<=	//sub
		6'h24:
			ALUCtrl_o<=	//and
		6'h25:
			ALUCtrl_o<=	//or
		6'h2a:
			ALUCtrl_o<=	//slt
		6'h3:
			ALUCtrl_o<=	//sra
		6'h7:
			ALUCtrl_o<=	//srav
		default:
			ALUCtrl_o<=4'b0;
	endcase
	else
	case(ALUOp_i)
		3'b001:
			ALUCtrl_o<=	//beq
		3'b010:
			ALUCtrl_o<=	//addi
		3'b011:
			ALUCtrl_o<=	//sltiu
		3'b100:
			ALUCtrl_o<=	//ori
		3'b101:
			ALUCtrl_o<=	//lui
		default:
			ALUCtrl_o<=4'b0;
	endcase
end

endmodule     





                    
                    