//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0312012 0416214
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;
//Internal Signles
wire [31:0] PC_in;
wire [31:0] PC_out;
wire [31:0] PC_plus4;
wire [31:0] IM_out;
wire [31:0] SE_out;
wire [31:0] ZF_out;
wire D_RegWrite;
wire [2:0] D_ALU_op;
wire D_ALUSrc;
wire [1:0] D_RegDst;//2-bit
wire D_Branch;
wire D_BranchType;
wire [1:0] D_Jump;//2-bit
wire D_MemRead;
wire D_MemWrite;
wire [1:0] D_MemToReg;//2-bit
wire [4:0] RF_wreg_in;
wire [31:0] RS_out;
wire [31:0] RT_out;
wire [3:0] AC_out;
wire [31:0] ALU_2in;
wire [31:0] ALU_result;
wire [31:0] Ful_result;
wire [31:0] Adder2_out;
wire [31:0] SL_two;
wire ALU_zero;
//wire jump;
wire NOT_ZERO;
wire equal_less_than;
wire [31:0] SJ_out;
wire [31:0] Branch_address;

assign NOT_ZERO=~ALU_zero;
assign equal_less_than=ALU_zero|ALU_result[31];
//wire [4:0] Shamt;
//wire [31:0] Shifter_out;
//Greate componentes
//assign jump=(D_Branch&(~ALU_zero)&IM_out[26]) | ((D_Branch)&ALU_zero&~IM_out[26]);
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_in) ,   
	    .pc_out_o(PC_out) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(PC_out),     
	    .sum_o(PC_plus4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(PC_out),  
	    .instr_o(IM_out)    
	    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(IM_out[20:16]),
        .data1_i(IM_out[15:11]),
		  .data2_i(5'b11111),
        .select_i(D_RegDst),
        .data_o(RF_wreg_in)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(IM_out[25:21]) ,  
        .RTaddr_i(IM_out[20:16]) ,  
        .RDaddr_i(RF_wreg_in) ,  
        .RDdata_i(Ful_result)  , 
        .RegWrite_i (D_RegWrite),
        .RSdata_o(RS_out) ,  
        .RTdata_o(RT_out)   
        );
	
Decoder Decoder(
        .instr_op_i(IM_out[31:26]), 
	    .RegWrite_o(D_RegWrite), 
	    .ALU_op_o(D_ALU_op),   
	    .ALUSrc_o(D_ALUSrc),   
	    .RegDst_o(D_RegDst),   
		.Branch_o(D_Branch),
		.BranchType_o(D_BranchType),
		.Jump_o(D_Jump),
		.MemRead_o(D_MemRead),
		.MemWrite_o(D_MemWrite),
		.MemToReg_o(D_MemToReg)
	    );

ALU_Ctrl AC(
        .funct_i(IM_out[5:0]),   
        .ALUOp_i(D_ALU_op),   
        .ALUCtrl_o(AC_out) 
        );
	
Sign_Extend SE(
        .data_i(IM_out[15:0]),
        .data_o(SE_out)
        );
/*
Zero_Filled ZF(
        .data_i(IM_out[15:0]),
        .data_o(ZF_out)
        );*/

MUX_3to1 #(.size(32)) Mux_FuRslt(
        .data0_i(ALU_result),
        .data1_i(DM_out),
        .data2_i(PC_plus4),
        .select_i(D_MemToReg),
        .data_o(Ful_result)
        );	

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RT_out),
        .data1_i(SE_out),
        .select_i(D_ALUSrc),
        .data_o(ALU_2in)
        );	
		
ALU ALU(
        .src1_i(RS_out),
	    .src2_i(ALU_2in),
	    .ctrl_i(AC_out),
	    .result_o(ALU_result),
		.zero_o(ALU_zero)
	    );

//------ shifter --------
/*
MUX_2to1 #(.size(5)) Mux_shamt(
        .data0_i(IM_out[10:6]),
        .data1_i(RS_out[4:0]),
        .select_i(IM_out[2]),
        .data_o(Shamt)
        );	

ShiftRighter ShiftRighter(
				.src_i(RT_out),
				.shamt_i(Shamt),
				.shifter_o(Shifter_out)
				);


*/
//-----------------------
		
Adder Adder2(
        .src1_i(PC_plus4),     
	    .src2_i(SL_two),     
	    .sum_o(Adder2_out)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(SE_out),
        .data_o(SL_two)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(PC_plus4),
        .data1_i(Adder2_out),
        .select_i(D_Branch),
        .data_o(Branch_address)
        );	

//Data Memory
Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(ALU_result),
		.data_i(RT_out),
		.MemRead_i(D_MemRead),
		.MemWrite_i(D_MemWrite),
		.data_o(DM_out)
		);

MUX_4to1 #(.size(1)) Branch_Type(
               .data0_i(ALU_zero),
               .data1_i(equal_less_than),
					.data2_i(ALU_result[31]),
					.data3_i(NOT_ZERO),
               .select_i(D_BranchType),
               .data_o(BT_out)
               );
					
Shift_Left_Two_32 Shifter_Jump(
        .data_i({6'b000000,IM_out[25:0]}),
        .data_o(SJ_out)
        );

MUX_3to1 #(.size(32)) Mux_Jump(
        .data0_i(Adder2_out),
        .data1_i({PC_plus4[31:28],SJ_out[27:0]}),
		  .data2_i(RS_out),
        .select_i(D_Jump),
        .data_o(PC_in)
        );

endmodule
		  


