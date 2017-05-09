// wirter: 0312012 0416214
module MUX_3to1(
	data0_i,
	data1_i,
	data2_i,
	select_i,
	data_o
	);

//I/O ports
input  [31:0] data0_i;
input  [31:0] data1_i;
input  [31:0] data2_i;
input  [3:0]  select_i;
output [31:0] data_o;

reg [31:0] data_o;

always@(*)
begin
	case(select_i)
		4'b1000: // sra srav
			data_o <= data0_i;
		4'b1100: // lui
			data_o <= data1_i;
		default:
			data_o <= data2_i;
	endcase
end


endmodule
