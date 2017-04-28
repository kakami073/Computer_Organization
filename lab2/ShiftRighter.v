`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:39:44 04/26/2017 
// Design Name: 
// Module Name:    Shifter 
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
module ShiftRighter(
		src_i,
		shamt_i,
		shifter_o
    );

//I/O ports
input  signed [32-1:0] src_i;
input  [5-1:0]  shamt_i;
output signed [32-1:0] shifter_o;

assign shifter_o = src_i >>> shamt_i;


endmodule
