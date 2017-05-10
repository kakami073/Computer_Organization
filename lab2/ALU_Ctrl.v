//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0312012 0416214 
//--------------------------------------
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
		6'h18:
			ALUCtrl_o<=4'b1000; //mul
		6'h8:
			ALUCtrl_o<=4'b1111; //jr -> don't care
		default:
			ALUCtrl_o<=4'b1111; //don't care
	endcase
	else
	case(ALUOp_i)
		3'b001:
			ALUCtrl_o<=4'b0110;	//beq bne bltz ble
		3'b100:
			ALUCtrl_o<=4'b0010;	//addi lui lw sw
		3'b101:
			ALUCtrl_o<=4'b0111;	//sltiu
		default:
			ALUCtrl_o<=4'b0000; // don't care
	endcase
end

endmodule     





                    
                    
