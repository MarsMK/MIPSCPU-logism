`timescale 1ns / 1ps

module NPC
(
	input rst, clk,
	input [31:0] IM, OFFSET, PC, RegRT, RegRS,
	output wire [31:0] NextPC,			// 下一条指令地�?
	output wire [15:0] unconditional,	// 无条件分支指令计�?
	output wire [15:0] conditional,		// 有条件分支指令计�?
	output wire [15:0] conditionalsucces,	// 有条件分支成功跳转计�?
	output wire halt
);

wire [5:0] func, operate;
wire [25:0] instr_index;
wire J, JAL, JR, BNE, BEQ;
wire syscall;
wire [31:0] NextPC0, NextPC1, NextPC2, NextPC21, NextPC22;
wire [1:0] PC_sel;

assign func[5:0] = IM[5:0];
assign operate[5:0] = IM[31:26];
assign instr_index[25:0] = IM[25:0];

// 判断是什么指�?
assign J = (operate == 6'h02)? 1 : 0;
assign JAL = (operate == 6'h03)? 1 : 0;
assign JR = (operate == 6'h00)&(func == 6'h08)? 1 : 0;
assign BNE = (operate == 6'h05)? 1 : 0;
assign BEQ = (operate == 6'h04)? 1 : 0;
assign syscall = (operate == 6'h00)&(func == 6'h0c)? 1 : 0;
assign compare_result1 = (RegRS == 32'ha)? 1 : 0;
assign halt = compare_result1 & syscall;

// 跳转指令类型判断
assign uncondi_count = J | JR | JAL;
assign condi_count = BNE | BEQ;
assign compare_result2 = (RegRS == RegRT)? 1 : 0;
assign BNE_success = (~compare_result2) & BNE;
assign BEQ_success = compare_result2 & BEQ;
assign condisucces_count = BNE_success | BEQ_success;

// 设置下一条指令的地址
assign NextPC0 = PC + 4;
assign NextPC21[31:0] = {PC[31:28], instr_index[25:0], 2'b00};
assign NextPC22 = RegRS;
assign NextPC1 = {OFFSET[29:0], 2'b00} + NextPC0;
assign PC_sel = {uncondi_count, condisucces_count};

sel_bits_1_mux #(32) choose_NextPC1
(
	.d0(NextPC21),
	.d1(NextPC22),
	.sel(JR),
	.out(NextPC2)
);

sel_bits_2_mux #(32) choose_NextPC
(
	.d0(NextPC0),
	.d1(NextPC1),
	.d2(NextPC2),
	.sel(PC_sel),
	.out(NextPC)
);

counter #(.DATA_BITS(16),.MAX_VALUE(16'hffff)) unconditional_count
(
	.count(uncondi_count),
	.clk(clk),
	.clear(rst),
	.halt(1),
	.out(unconditional)
);

counter #(.DATA_BITS(16),.MAX_VALUE(16'hffff)) conditional_count
(
	.count(condi_count),
	.clk(clk),
	.clear(rst),
	.halt(1),
	.out(conditional)
);

counter #(.DATA_BITS(16),.MAX_VALUE(16'hffff)) conditionalsucces_count
(
	.count(condisucces_count),
	.clk(clk),
	.clear(rst),
	.halt(1),
	.out(conditionalsucces)
);

endmodule
