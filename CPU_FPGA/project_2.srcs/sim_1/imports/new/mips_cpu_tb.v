`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/13 20:58:05
// Design Name: 
// Module Name: mips_cpu_tb
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


module mips_cpu_tb(

    );
    
    reg clk_k;
//    reg [15:0]fake_counter;
    wire [7:0] an;     //an控制八个数码管的亮灭
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [3:0] dmaddr_light; //内存地址选择指示�
   
   
    mips_cpu t1(clk_k, 2'b00, 4'b0000, 0, 0, an, CA, CB, CC, CD, CE, CF, CG, DP, dmaddr_light);
    
    initial 
    begin
//        fake_counter = 0;
        clk_k = 0;
        
        forever
        #1 clk_k = ~clk_k;
    end;
    
//    always @(posedge clk_k) fake_counter = fake_counter + 1;   
   
endmodule
