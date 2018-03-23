`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/12 15:44:53
// Design Name: 
// Module Name: RISC_ALU
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


module RISC_ALU(X, Y, ALU_OP, Result, Result2, OF, UOF, Equal);
input  [31:0] X;
input  [31:0] Y;
input  [ 3:0] ALU_OP; 
output [31:0] Result;  reg [31:0] Result;
output [31:0] Result2; reg [31:0] Result2;
output OF;  reg OF;
output UOF; reg UOF;
output Equal; reg Equal;


`define Zdelay 1.2
`define ALUdelay 3.5
reg [63:0]para1, para2;
reg [15:0]X0, Y0, X1, Y1, S0, S1;
reg p1, p2;
reg C;
always @(*)
begin
    OF = 0;
    UOF = 0;
    Equal = (X == Y)?1:0;
    case(ALU_OP)
        4'b0000: begin
            Result = X<<(Y[4:0]);  Result2 = 0; 
        end
        4'b0001: begin
            Result = $signed(X)>>>(Y[4:0]); Result2 = 0; //SuanShu
        end
        4'b0010: begin
            Result = X>>(Y[4:0]);  Result2 = 0; //LuoJi
        end
        4'b0011: begin
            para1 =(X * Y);
            Result = para1[31:0]; Result2 = para1[63:32];
        end
        4'b0100: begin
            Result = X / Y;        Result2 = X % Y;
        end
        4'b0101: begin
            {C, Result} = X + Y; Result2 = 0;
            X0 = X[15:0]; X1 = X[31:16];
            Y0 = Y[15:0]; Y1 = Y[31:16];
            S0 = X0 + Y0; S1 = X1 + Y1; 
            OF =((X1[15])
                &(~(S1[15]))
                &(Y1[15]))
                |
                ((~(X1[15]))
                &(S1[15])
                &(~(Y1[15])));
            UOF = C;
        end
        4'b0110: begin
            Result = X + ~Y + 1;        Result2 = 0;
            X0 = X[15:0]; X1 = X[31:16];
            Y0 = ~Y[15:0]; Y1 = ~Y[31:16];
            {C, S0} = X0 + Y0 + 1; S1 = X1 + Y1 + C; 
            OF =((X1[15])
                &(~(S1[15]))
                &(Y1[15]))
                |
                ((~(X1[15]))
                &(S1[15])
                &(~(Y1[15])));
            UOF = ($unsigned(X) < $unsigned(Y)) ? 1 : 0;
        end
        4'b0111: begin
            Result = X & Y;        Result2 = 0;
        end
        4'b1000: begin
            Result = X | Y;        Result2 = 0;
        end
        4'b1001: begin
            Result = X ^ Y;        Result2 = 0;
        end
        4'b1010: begin
            Result =~(X | Y);      Result2 = 0;
        end
        4'b1011: begin
            Result = ($signed(X) < $signed(Y)) ? 1 : 0; Result2 = 0;
        end
        4'b1100: begin
            Result = ($unsigned(X) < $unsigned(Y)) ? 1 : 0;  Result2 = 0;
        end
        default: begin
        $display("Unknown ALU_OP");
        Result = 8'bXXXXXXX; Result2 = 8'bXXXXXXX;
        end
    endcase
end
endmodule
