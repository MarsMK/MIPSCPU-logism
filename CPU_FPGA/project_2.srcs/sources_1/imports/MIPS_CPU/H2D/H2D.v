`timescale 1ns / 1ps
module H2D(
    input [15:0] Hex,
    output reg [15:0] Dex
);
reg [3:0] Thousands;
reg [3:0] Hundreds;
reg [3:0] Tens;
reg [3:0] Ones;
integer i;
always@(Hex)
begin
  Thousands=0;
  Hundreds=0;
  Tens=0;
  Ones=0;

  for(i=15;i>=0;i=i-1)
  begin
    if(Thousands>=5)
        Thousands=Thousands+3;
    if(Hundreds>=5)
        Hundreds=Hundreds+3;
    if(Tens>=5)
        Tens=Tens+3;
    if(Ones>=5)
        Ones=Ones+3;
    
    Thousands=Thousands<<1;
    Thousands[0]=Hundreds[3];
    Hundreds=Hundreds<<1;
    Hundreds[0]=Tens[3];
    Tens=Tens<<1;
    Tens[0]=Ones[3];
    Ones=Ones<<1;
    Ones[0]=Hex[i];
  end
  Dex={Thousands,Hundreds,Tens,Ones};
end

endmodule