`timescale 1ns / 1ps

module mips_cpu(
	input clk,	//clock
	input [1:0] ShiftA,	//显示模式按钮
	input [3:0] ShiftB,		//内存地址按钮
	input rst, //reset信号
	input change_hz, //频率切换按钮
	inout button,
	output [7:0] an,	 //an控制八个数码管的亮灭
	output CA, CB, CC, CD, CE, CF, CG, DP,
	output [3:0] dmaddr_light //内存地址选择指示�?
	);
	//for test
	reg [15:0] fake_counter = 0;
	
	wire [31:0] divclk;		//分频
	wire [31:0] nextpc;		//下一个PC�?
	wire clk_run;
	 
	//IM参数
	wire [31:0] pc;			//当前PC�?
	wire [31:0] im_now;		//当前指令
	//NPC参数
	wire [15:0] uncon;
	wire [15:0] con;
	wire [15:0] consuccess;
	
	//IM指令分解
	wire [5:0] func;
	wire [4:0] Imm6_10;
	wire [4:0] Imm11_15;
	wire [4:0] Rt;
	wire [4:0] Rs;
	wire [5:0] operator;
	
	//controler参数
	wire [3:0]aluop;    
	wire ext_16;        
	wire ext_s;         
	wire ext_5;         
	wire regwrite;      
	wire lw;            
	wire jal;           
	wire syscall;       
	wire sw;

	//REGFILE参数          
	wire we_t;           
	wire [31:0]w_t;
	wire [4:0]rw_t;      
	wire [4:0]ra_t;      
	wire [4:0]rb_t;      
	wire [31:0]a_t;      
	wire [31:0]b_t; 
	wire [1:0] w_t_sel;
	wire [1:0] rw_t_sel;
	
	//ALU参数
	wire [31:0] X;
	wire [31:0] Y;
	wire [31:0] result;
	wire [31:0] result2;
	wire OF;  	
	wire UOF; 	
	wire Equal; 

	//DM参数
	wire [11:0] addr;
	wire [31:0] din;
	wire WE;
	//wire [1:0] mode;
	wire [31:0] dataout;

	//立即数扩�?
	wire [31:0] ext_32;
	wire [15:0] Imm16;
	wire [4:0] Imm5;
	wire [31:0] Imm5to32;
	wire [31:0] Imm16to32;

	//显示模块
	wire [31:0] DataMemory;
	wire  clk_show;
    assign func = im_now[5:0];
    assign Imm6_10 = im_now[10:6];
    assign Imm11_15 = im_now[15:11];
    assign Rt = im_now[20:16];
    assign Rs = im_now[25:21];
    assign operator = im_now[31:26];
	assign Imm16 = im_now[15:0];
	assign Imm5 = Imm6_10;
	
	wire halt = (((a_t - 32'h00000022) ? 1 : 0) & syscall)&(~rst)&(~button) ? 1 : 0; 
	
	//�������ʾ��Ϣ
    wire [31:0] SyscallOut;
    counter #(32, 32'hffffffff) sys_callout(.data(b_t), .load(1), .clk(clk_run), .halt((~halt) & syscall), .clear(rst), .out(SyscallOut));
    
    //halt = 1������ֹ
    //total_cycle
    wire [15:0] total_cycle;
    wire halt_delay;
    counter #(1, 1) halt_d(.clk(clk_run), .data(halt), .halt(1), .clear(rst), .load(1), .out(halt_delay));
    counter #(16, 16'hffff) totalcyc(.clk(clk_run), .halt(~halt_delay), .count(1), .clear(rst), .out(total_cycle));
	//时钟
	DVM dvm(.clk(clk), .myclk(divclk));
	//读取指令
	counter #(32, 32'hffffffff) next_pc(.data(nextpc), .load(1), .clk(clk_run), .halt(~halt), .clear(rst), .out(pc));
	IM im(.address(pc[11:0]), .im_now(im_now));
	
	//NPC部分
	NPC npc(.rst(rst), .clk(clk_run), .IM(im_now), .OFFSET(ext_32), .PC(pc), .RegRS(a_t), .RegRT(b_t),
		.NextPC(nextpc), .unconditional(uncon), .conditional(con), .conditionalsucces(consuccess));
	
	//OFFSET选择部分
	Zero_Ext_5to32 _5to32(.data_5bit(Imm5), .data_32bit(Imm5to32));
	Sign_Ext_16to32 _16to32(.data_16bit(Imm16), .data_32bit(Imm16to32));
	
	sel_bits_1_mux #(32) _5Extlmm(.d0(Imm16to32), .d1(Imm5to32), .sel(ext_5), .out(ext_32));

	//regfile
	assign w_t_sel[0] = lw;
	assign w_t_sel[1] = jal;
	parameter FREE1 = 32'h00000000;
	sel_bits_2_mux #(32) choose_w_t(.d0(result), .d1(dataout), .d2(pc+4), .d3(FREE1), .sel(w_t_sel), .out(w_t));
	parameter D2 = 5'h1f; 
	parameter FREE2 = 5'h00;
	assign rw_t_sel[0] = ext_16 | ext_s;
	assign rw_t_sel[1] = jal;
	sel_bits_2_mux #(5) choose_rw_t(.d0(Imm11_15), .d1(Rt), .d2(D2), .d3(FREE2), .sel(rw_t_sel), .out(rw_t));
	parameter v0_reg = 5'h02;
	parameter display_reg = 5'h04;
	sel_bits_1_mux #(5) sel_ra_t(.d0(Rs), .d1(v0_reg), .sel(syscall), .out(ra_t));
	sel_bits_1_mux #(5) sel_rb_t(.d0(Rt), .d1(display_reg), .sel(syscall), .out(rb_t));
	assign we_t = regwrite;
	RegisterFile rgfile(.clk(clk_run), .we(we_t), .w(w_t), .rw(rw_t), .ra(ra_t), .rb(rb_t),
		.a(a_t), .b(b_t));
	
	//controler
	controler control(.func(func), .operator(operator), .aluop(aluop), .ext_16(ext_16), .ext_s(ext_s),
	 	.ext_5(ext_5), .regwrite(regwrite), .lw(lw), .jal(jal), .syscall(syscall), .sw(sw));
	
	//ALU
	wire x_sel = ext_5;
	sel_bits_1_mux #(32) alu_x_sel(.d0(a_t), .d1(b_t), .sel(ext_5), .out(X));
	wire [1:0] y_sel;
	assign y_sel[0] = ext_5 | ext_s | ext_16;
	assign y_sel[1] = 0; 
	sel_bits_2_mux #(32) alu_y_sel(.d0(b_t), .d1(ext_32), .d2(a_t), .d3(FREE1), .sel(y_sel), .out(Y));
	RISC_ALU alu(.X(X), .Y(Y), .ALU_OP(aluop), .Result(result), .Result2(result2), .OF(OF), .UOF(UOF), .Equal(Equal));
	
	//数据存储�?
	wire [11:0] addr_1;
	assign addr_1 = {6'b000000, ShiftB, 2'b00};
	assign addr = (sw | lw) ? result[11:0]: addr_1;
	assign din = b_t;
	assign WE = sw;
//	assign mode[0] = (~lw) & (~sw);
//	assign mode[1] = 0;
	DataMemo dm(.addr(addr), .Din(din), .WE(WE), .clk(clk_run), .reset(rst), .DataOut(dataout));

	//显示模块
	//DataMemo rm(.addr({6'b0, ShiftB, 2'b0}), .Din(0), .WE(0), .clk(clk_run), .mode(2'b0), .DataOut(DataMemory));
	
	show_signal my_show(.clk(clk_show), .ShiftA(ShiftA), .ShiftB(ShiftB), .total_cycle(total_cycle), .unconditional(uncon), .conditional(con), .conditionalsucces(consuccess),
		.SyscallOut(SyscallOut), .DataMemory(dataout), .PC(pc), .AN(an), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .DP(DP));
    
	assign clk_run = (change_hz)? divclk[0] : divclk[22];
	assign clk_show = divclk[15];

    always @(posedge clk_run) fake_counter = fake_counter + 1; 

endmodule