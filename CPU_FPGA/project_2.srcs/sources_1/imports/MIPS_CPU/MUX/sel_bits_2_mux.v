`timescale 1ns / 1ps

// 四路选择器
module sel_bits_2_mux
#(	// DATA_BITS为输入的位宽 缺省值为2
	parameter DATA_BITS = 2
)
(
	input [DATA_BITS-1:0] d0, d1, d2, d3,
	input [SEL_BITS-1:0] sel,
	output reg [DATA_BITS-1:0] out
);

parameter SEL_BITS = 2;

always @ (*) begin
	case (sel)
	2'b00: out = d0;
	2'b01: out = d1;
	2'b10: out = d2;
	2'b11: out = d3;
	endcase
end

endmodule