`timescale 1ns / 1ps

module _7Seg_Driver_Decode(
	input [1:0] ShiftA,
	input [3:0] ShiftB,
	input [2:0] tube_num,
	input [1:0] count_flag,
	input [3:0] data,
	output reg [7:0] seg
	);

reg [7:0] data_decode;

// 0~f在数码管上的显示
always @ (*) begin
	case(data)
		4'h0: data_decode = 8'b00000011;
		4'h1: data_decode = 8'b10011111;
		4'h2: data_decode = 8'b00100101;
		4'h3: data_decode = 8'b00001101;
		4'h4: data_decode = 8'b10011001;
		4'h5: data_decode = 8'b01001001;
		4'h6: data_decode = 8'b01000001;
		4'h7: data_decode = 8'b00011111;
		4'h8: data_decode = 8'b00000001;
		4'h9: data_decode = 8'b00001001;
		4'ha: data_decode = 8'b00010001;
		4'hb: data_decode = 8'b11000001;
		4'hc: data_decode = 8'b01100011;
		4'hd: data_decode = 8'b10000101;
		4'he: data_decode = 8'b01100001;
		4'hf: data_decode = 8'b01110001;
	endcase
end

always @ (*) begin
	case(tube_num)
		0: begin
			seg = data_decode;
		end
		1: begin
			if(ShiftA == 2'b11 && count_flag < 1) begin
				seg = 8'b11111111;
			end
			else begin
				seg = data_decode;
			end
		end
		2: begin
			if(ShiftA == 2'b11 && count_flag < 2) begin
				seg = 8'b11111111;
			end
			else begin
				seg = data_decode;
			end
		end
		3: begin
			if(ShiftA == 2'b11 && count_flag < 3) begin
				seg = 8'b11111111;
			end
			else begin
				seg = data_decode;
			end
		end
		4: begin
			if(ShiftA == 2'b11) begin
				case(ShiftB)
					4'b0001: seg = 8'b01100011;
					4'b0010: seg = 8'b01100011;
					4'b0100: seg = 8'b01001001;
					default: seg = 8'b11111111;
				endcase
			end
			else begin
				seg = data_decode;
			end
		end
		5: begin
			if(ShiftA == 2'b11) begin
				case(ShiftB) 
					4'b0001: seg = 8'b11110011;
					4'b0010: seg = 8'b11110011;
					4'b0100: seg = 8'b11110011;
					default: seg = 8'b11111111;
				endcase
			end
			else begin
				seg = data_decode;
			end
		end
		6: begin
			if(ShiftA == 2'b11) begin
				case(ShiftB) 
					4'b0001: seg = 8'b11000001;
					4'b0010: seg = 8'b11000001;
					4'b0100: seg = 8'b11000001;
					default: seg = 8'b01001001;
				endcase
			end
			else begin
				seg = data_decode;
			end
		end
		7: begin
			if(ShiftA == 2'b11) begin
				case(ShiftB)
					4'b0001: seg = 8'b10000011; // "U"
					default: seg = 8'b01100011; // "C"
				endcase
			end
			else begin
				seg = data_decode;
			end
		end
	endcase
end

endmodule

