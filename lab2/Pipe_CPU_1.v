//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;
/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] PC_in;
wire [31:0] PC_out;
wire [31:0] PC_plus4;
wire [31:0] IM_out;


/**** ID stage ****/
wire [31:0] P_PC_plus4;
wire [31:0] P_IM_out;

wire [31:0] RS_out;
wire [31:0] RT_out;
wire [31:0] SE_out;

//control signal
wire D_RegWrite;
wire [2:0] D_ALU_op;
wire D_ALUSrc;
wire D_RegDst;
wire D_Branch;
wire D_MemRead;
wire D_MemWrite;
wire D_MemToReg;


/**** EX stage ****/
wire [147:0] P_ID_EX;

wire [4:0] Reg_W_Des;
wire [31:0] ALU_2in;
wire [31:0] ALU_result;
wire ALU_zero;
wire [31:0] Adder2_out;
wire [31:0] SL_two;

//control signal
wire [3:0] AC_out;


/**** MEM stage ****/
wire [106:0] P_EX_MEM;

wire [31:0] DM_out;
//control signal


/**** WB stage ****/
wire [70:0] P_MEM_WB;

wire [31:0] Ful_result;
//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux1(
			.data0_i(PC_plus4),
         .data1_i(P_EX_MEM[101:70]),
         .select_i(P_EX_MEM[69]&P_EX_MEM[104]),
         .data_o(PC_in)
		);

ProgramCounter PC(
			.clk_i(clk_i),
			.rst_i(rst_i),
			.pc_in_i(PC_in),
			.pc_out_o(PC_out)
        );

Instr_Memory IM(
			.addr_i(PC_out),
			.instr_o(IM_out)
	    );

Adder Add_pc(
			.src1_i(PC_out),
			.src2_i(32'd4),
			.sum_o(PC_plus4)
		);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
			.clk_i(clk_i),
			.rst_i(rst_i),
			.data_i({PC_plus4,IM_out}),
			.data_o({P_PC_plus4,P_IM_out})
		);

//Instantiate the components in ID stage
Reg_File RF(
			.clk_i(clk_i),
			.rst_i(rst_i),
			.RSaddr_i(P_IM_out[25:21]),
			.RTaddr_i(P_IM_out[20:16]),
			.RDaddr_i(P_MEM_WB[4:0]),
			.RDdata_i(Ful_result),
			.RegWrite_i(P_MEM_WB[70]),
			.RSdata_o(RS_out),
			.RTdata_o(RT_out)
		);

Decoder Control(//////////////////////////////////////////
			.instr_op_i(P_IM_out[31:26]),
			.RegWrite_o(D_RegWrite), //
			.ALU_op_o(D_ALU_op),   //
			.ALUSrc_o(D_ALUSrc),   //
			.RegDst_o(D_RegDst),//
			.Branch_o(D_Branch),//
			.MemRead_o(D_MemRead),//
			.MemWrite_o(D_MemWrite),//
			.MemToReg_o(D_MemToReg)//
		);

Sign_Extend Sign_Extend(
			.data_i(P_IM_out[15:0]),
			.data_o(SE_out)
		);	

Pipe_Reg #(.size(148)) ID_EX(
			.clk_i(clk_i),
			.rst_i(rst_i),
			.data_i({D_RegWrite,D_MemToReg,D_Branch,D_MemRead,D_MemWrite,D_RegDst,
					D_ALU_op,D_ALUSrc,P_PC_plus4,RS_out,RT_out,SE_out,P_IM_out[20:11]}),
			.data_o(P_ID_EX)
		);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shift_Left_Two_32(
			.data_i(P_ID_EX[41:10]),
			.data_o(SL_two)
		);
		
Adder Add_Branch(
			.src1_i(P_ID_EX[137:106]),
			.src2_i(SL_two),
			.sum_o(Adder2_out)
		);
		
ALU ALU(
			.src1_i(P_ID_EX[105:74]),
			.src2_i(ALU_2in),
			.ctrl_i(AC_out),
			.result_o(ALU_result),
			.zero_o(ALU_zero)
		);

ALU_Ctrl ALU_Ctrl(
          .funct_i(P_ID_EX[15:10]),
          .ALUOp_i(P_ID_EX[141:139]),
          .ALUCtrl_o(AC_out)
		);

MUX_2to1 #(.size(32)) Mux2(
			.data0_i(P_ID_EX[73:42]),
         .data1_i(P_ID_EX[41:10]),
         .select_i(P_ID_EX[138]),
         .data_o(ALU_2in)
        );

MUX_2to1 #(.size(5)) Mux3(
			.data0_i(P_ID_EX[9:5]),
         .data1_i(P_ID_EX[4:0]),
         .select_i(P_ID_EX[142]),
         .data_o(Reg_W_Des)
        );

Pipe_Reg #(.size(107)) EX_MEM(
			.clk_i(clk_i),
			.rst_i(clk_i),
			.data_i({P_ID_EX[147:143],Adder2_out,ALU_zero,ALU_result,P_ID_EX[73:42],Reg_W_Des}),
			.data_o(P_EX_MEM)
		);

//Instantiate the components in MEM stage
Data_Memory DM(
			.clk_i(clk_i),
			.addr_i(P_EX_MEM[68:37]),
			.data_i(P_EX_MEM[36:5]),
			.MemRead_i(P_EX_MEM[103]),
			.MemWrite_i(P_EX_MEM[102]),
			.data_o(DM_out)
	    );

Pipe_Reg #(.size(71)) MEM_WB(
			.clk_i(clk_i),
			.rst_i(rst_i),
			.data_i({P_EX_MEM[106:105],DM_out,P_EX_MEM[68:37],P_EX_MEM[4:0]}),
			.data_o(P_MEM_WB)        
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux4(
			.data0_i(P_MEM_WB[36:5]),
         .data1_i(P_MEM_WB[68:37]),
         .select_i(P_MEM_WB[69]),
         .data_o(Ful_result)
        );

/****************************************
signal assignment
****************************************/	
endmodule

