`timescale 1ns / 1ps

module Zero_Ext_5to32(
    input [4:0] data_5bit,
    output [31:0] data_32bit
);
assign data_32bit={ {27{1'b0}}, data_5bit};

endmodule

module Sign_Ext_16to32(
    input [15:0] data_16bit,
    output [31:0] data_32bit
);
assign data_32bit={ {16{data_16bit[15]}}, data_16bit};

endmodule