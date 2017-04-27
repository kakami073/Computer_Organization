//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
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
wire D_RegWrite;
wire [2:0] D_ALU_op;
wire D_ALUSrc;
wire D_RegDst;
wire D_Branch;
wire [4:0] RF_wreg_in;
wire [31:0] RS_out;
wire [31:0] RT_out;
wire [3:0] AC_out;
wire [31:0] ALU_2in;
wire [31:0] ALU_result;
wire [31:0] Adder2_out;
wire [31:0] SL_two;
wire ALU_zero;
wire jump;
//Greate componentes
assign jump=(D_Branch&(~ALU_zero)&IM_out[26]) | ((~D_Branch)&ALU_zero&IM_out[26]);
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

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(IM_out[20:16]),
        .data1_i(IM_out[15:11]),
        .select_i(D_RegDst),
        .data_o(RF_wreg_in)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(IM_out[25:21]) ,  
        .RTaddr_i(IM_out[20:16]) ,  
        .RDaddr_i(RF_wreg_in) ,  
        .RDdata_i(ALU_result)  , 
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
		.Branch_o(D_Branch)   
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
        .select_i(jump),
        .data_o(PC_in)
        );	

endmodule
		  


