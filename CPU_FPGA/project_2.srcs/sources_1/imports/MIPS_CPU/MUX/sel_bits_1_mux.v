`timescale 1ns / 1ps

// 二路选择器
module sel_bits_1_mux
#(	// DATA_BITS为输入的位宽 缺省值为2
	parameter DATA_BITS = 2
)
(
	input wire [DATA_BITS-1:0] d0, d1,
	input wire sel,
	output wire [DATA_BITS-1:0] out
);

assign out = sel? d1: d0;

endmodule