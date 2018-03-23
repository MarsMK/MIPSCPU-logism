`timescale 1ns / 1ps

module show_signal(
	input clk, 
	input [1:0] ShiftA,
	input [3:0] ShiftB,
	input [15:0] total_cycle, unconditional, conditional, conditionalsucces,
	input [31:0] SyscallOut,
	input [31:0] DataMemory,
	input [31:0] PC,
	output reg [7:0] AN,
	output reg CA, CB, CC, CD, CE, CF, CG, DP
	);

wire [31:0] show_data;
wire [7:0]  tube[7:0];
reg  [7:0]  tube_now;

initial begin
	    AN = 8'b11111110;
end

// 扫描数码管AN[0]~AN[7]
always @(posedge clk) begin
    case(AN)
	    8'b11111110:begin
            AN <= 8'b11111101;
            tube_now <= tube[2];
        end
        8'b11111101:begin
            AN <= 8'b11111011;  
            tube_now <= tube[3];
        end
        8'b11111011:begin
            AN <= 8'b11110111;
            tube_now <= tube[4];
        end
        8'b11110111:begin
            AN <= 8'b11101111;
            tube_now <= tube[5];
        end
        8'b11101111:begin
            AN <= 8'b11011111;
            tube_now <= tube[6];
        end
        8'b11011111:begin
            AN <= 8'b10111111;
            tube_now <= tube[7];
        end
        8'b10111111:begin
            AN <= 8'b01111111;
            tube_now <= tube[0];
        end
        default    :begin
            AN <= 8'b11111110;      
            tube_now <= tube[1];
        end
    endcase     	
       
       {CA,CB,CC,CD,CE,CF,CG,DP} <= tube_now; 
    end

wire [31:0] total_cycle_dex;
wire [31:0] unconditional_dex;
wire [31:0] conditional_dex;
wire [31:0] conditionalsucces_dex;
wire [15:0] show_count_hex;
wire [31:0] show_count_dex;
wire [1:0] count_sel;
wire [1:0] count_flag;

assign show_count_dex[31:16] = 0;
assign count_sel[0] = (ShiftB == 4'b0001 | ShiftB == 4'b0100)? 1 : 0;
assign count_sel[1] = (ShiftB == 4'b0010 | ShiftB == 4'b0100)? 1 : 0;
assign count_flag[0] = (show_count_dex[15:12] != 0 | 
	(show_count_dex[11:8] == 0 & show_count_dex[7:4] != 0))? 1 : 0;
assign count_flag[1] = (show_count_dex[15:12] != 0 |
	show_count_dex[11:8])? 1 : 0;

sel_bits_2_mux #(16) sel_show_count(
	.d0(total_cycle),
	.d1(unconditional),
	.d2(conditional),
	.d3(conditionalsucces),
	.sel(count_sel),
	.out(show_count_hex)
);

H2D TC(.Hex(show_count_hex), .Dex(show_count_dex[15:0]));

sel_bits_2_mux #(32) sel_show_data(
	.d0(SyscallOut),
	.d1(DataMemory),
	.d2(PC),
	.d3(show_count_dex),
	.sel(ShiftA),
	.out(show_data)
);

_7Seg_Driver_Decode tube0(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(0),
	.count_flag(count_flag),
	.data(show_data[3:0]),
	.seg(tube[0])
);

_7Seg_Driver_Decode tube1(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(1),
	.count_flag(count_flag),
	.data(show_data[7:4]),
	.seg(tube[1])
);

_7Seg_Driver_Decode tube2(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(2),
	.count_flag(count_flag),
	.data(show_data[11:8]),
	.seg(tube[2])
);

_7Seg_Driver_Decode tube3(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(3),
	.count_flag(count_flag),
	.data(show_data[15:12]),
	.seg(tube[3])
);

_7Seg_Driver_Decode tube4(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(4),
	.count_flag(count_flag),
	.data(show_data[19:16]),
	.seg(tube[4])
);

_7Seg_Driver_Decode tube5(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(5),
	.count_flag(count_flag),
	.data(show_data[23:20]),
	.seg(tube[5])
);

_7Seg_Driver_Decode tube6(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(6),
	.count_flag(count_flag),
	.data(show_data[27:24]),
	.seg(tube[6])
);

_7Seg_Driver_Decode tube7(
	.ShiftA(ShiftA),
	.ShiftB(ShiftB),
	.tube_num(7),
	.count_flag(count_flag),
	.data(show_data[31:28]),
	.seg(tube[7])
);

endmodule