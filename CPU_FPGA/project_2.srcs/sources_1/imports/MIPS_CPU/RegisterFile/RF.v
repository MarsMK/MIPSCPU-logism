module RegisterFile(clk, we, w, rw, ra, rb, a, b);
	// input:
	input clk;          // 时钟
	input we;           // 写使�?
	input [31:0]w;      // 要写入寄存器的数�?
	input [4:0]rw;      // 要写入的地址
	input [4:0]ra;      // 要读取的地址
	input [4:0]rb;      // 要读取的地址
	output [31:0]a;     // 要读出的数据
	output [31:0]b;     // 要读出的数据

	reg [31:0]data[31:0];    // 寄存器中存放的数�?
	reg [31:0]a;    // 读出的数据a
	reg [31:0]b;    // 读出的数据b
	
	integer i;
	
	initial 
	begin
	for (i = 0; i <= 31; i = i+1)
	begin
	   data[i] = 32'h00000000;
	end
	end

	always @(posedge clk) begin
		if (we == 1'b1 && rw != 1'b0)    // 向寄存器写数�?
		begin
			data[rw] = w;
		end
//		a = data[ra];    // 读出数据a
//		b = data[rb];    // 读出数据b
	end
	
	always @ (*) begin
	   a = (ra == 0) ? 1'b0 : data[ra];
	   b = (rb == 0) ? 1'b0 : data[rb];
	end

endmodule