`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/12 16:32:16
// Design Name: 
// Module Name: DataMemo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMemo(
    input [12:1] addr,
    input [32:1] Din,
    input WE,
    input clk,
    input reset,
    output [32:1] DataOut
    );
	reg [31:0] mem[1023:0];
    integer i;

    initial
    begin
	    for (i = 0; i <= 1023; i = i + 1)
	    begin
	        mem[i] = 32'h00000000;
	    end
    end

    assign DataOut = mem[addr[12:3]];
    
    always @(posedge clk)
    begin
    	if(WE)
    	begin
    		mem[addr[12:3]] = Din;
    	end
    end
endmodule
