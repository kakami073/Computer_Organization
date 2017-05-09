`timescale 1ns / 1ps
//�}��� 0416214, �ۨΥ� 0312012
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:46:40 03/24/2017 
// Design Name: 
// Module Name:    alu_bottom 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu_bottom(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
					set
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;
output        set;

reg           result;

wire w1,w2,w3,w4,w5;

xor xor1(w1, src1, A_invert);
xor xor2(w2, src2, B_invert);
and and1(w3, w1, w2);
or or1(w4, w1, w2);
assign w5=w1^w2^cin;
assign cout=(w1&w2)|(w2&cin)|(cin&w1);
assign set=(w1&w2)|((w1|w2)&w5);

always@( * )
begin
	case(operation)
		2'b00:
			result<=w3;
		2'b01:
			result<=w4;
		2'b10:
			result<=w5;
		2'b11:
			result<=less;
	endcase
end

endmodule