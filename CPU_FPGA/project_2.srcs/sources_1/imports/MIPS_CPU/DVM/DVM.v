`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/13 08:58:29
// Design Name: 
// Module Name: DVM
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


module DVM(
    input clk,
    output [32:1] myclk
    );
    reg [32:1] myclk;
    initial myclk = 0;
    always@(posedge clk)
    begin
    	myclk  = myclk + 1;
    end
    // myclk[0] 50MHZ
    // myclk[1] 25MHZ
    //...
    // myclk[19] 190HZ
    // myclk[20] 95HZ
endmodule
