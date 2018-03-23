`timescale 1ns / 1ps
 
// 计数器
module counter
#(
	parameter DATA_BITS = 16,
	parameter MAX_VALUE = 1 // counter达到max_value时，重置为0
)
(
	input [DATA_BITS-1:0] data,
	input clear, // 值为1时， 将counter重置为0
	input load,	// 值为1时， 将data的数据载入到counter
	input count, // 值为1时， counter计数
	input clk, // 时钟， 上升沿生效
	input halt, //值为1时，忽略时钟输入。
	output reg [DATA_BITS-1:0] out, // 输出当前counter的值
	output reg carry // counter达到max_value时，输出为1
);

reg [DATA_BITS-1:0] counter;

initial begin
	counter = 0;
end

always @ (posedge clk) begin
    if(clear)begin
        counter = 0;
      end
	else if(halt) begin
		if (load) begin
			counter = data;
		end
		else if (count) begin
			if (counter == MAX_VALUE) begin
				counter = 0;
			end
			else begin
				counter = counter + 1;
			end
		end
	end
end

always @ (*) begin
	if (counter == MAX_VALUE) begin
		carry = 1;
	end
	else begin
		carry = 0;
	end
	out = counter;
end

endmodule