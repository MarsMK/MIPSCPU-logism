module controler(
	// input:
	func, operator, 
	// output:
	aluop, ext_16, ext_s, ext_5, regwrite, lw, jal, syscall, sw);

    function [3:0] EXT;
        input digit_1;
        //output [3:0] digit_4; reg [3:0] digit_4;
        EXT = (digit_1==0)?4'b0000:4'b1111;
    endfunction

	input [5:0]func;    // function [5:0]
	input [5:0]operator;    // operator [31:25]

	output [3:0]aluop;    
	output ext_16;        
	output ext_s;         
	output ext_5;         
	output regwrite;      
	output lw;            
	output jal;           
	output syscall;       
	output sw;            

	reg [3:0]aluop;
	reg ext_16;
	reg ext_s;
	reg ext_5;
	reg regwrite;
	reg lw;
	reg jal;
	reg syscall;
	reg sw;
	// 中间变量
	reg beq;
	reg bne;
	reg addi;
	reg addiu;
	reg slti;
	reg andi;
	reg ori;
	reg sll;
	reg srl;
	reg sra;
	reg jr;
	reg add;
	reg addu;
	reg sub;
	reg and_cp;
	reg or_cp;
	reg nor_cp;
	reg slt;
	reg sltu;
	
    reg OR1, OR2, OR3, OR4, OR5, OR6;
    reg [3:0] AND1, AND2, AND3, AND4, AND5, AND6, AND7, AND8, AND9, AND10;

	// 判断指令类型：R型�?�I型�?�J�?
	always @(*) begin
	    // outputs
	    aluop = 4'bzzzz; 
	    ext_16 = 0; ext_5 = 0; ext_s = 0; regwrite = 0;
        lw = 0; jal = 0; syscall = 0; sw = 0;
        //mid-paras
        beq = 0; bne = 0; addi = 0; addiu = 0; 
        slti = 0; andi = 0; ori = 0; sll = 0; 
        srl = 0; sra = 0; jr = 0; add = 0; 
        addu = 0; sub = 0; and_cp = 0; 
        or_cp = 0; nor_cp = 0; slt = 0; sltu = 0; 
        //initialize gates
        OR1 = 0; OR2 = 0; OR3 = 0;
        OR4 = 0; OR5 = 0; OR6 = 0;
        AND1 = 4'b0000; AND2 = 4'b0000; AND3 = 4'b0000;
        AND4 = 4'b0000; AND5 = 4'b0000; AND6 = 4'b0000;
        AND7 = 4'b0000; AND8 = 4'b0000; AND9 = 4'b0000;
        AND10 = 4'b0000;
		case (operator)
		6'h03:
		begin
			jal = 1;    // 寄存器跳�?
		end
		6'h04:
		begin
			beq = 1;    // 相等跳转
		end
		6'h05:
		begin
			bne = 1;    // 不等跳转
		end
		6'h08:
		begin
			addi = 1;    // 立即数加
		end
		6'h09:
		begin
			addiu = 1;     // 无符号立即数�?
		end
		6'h0a:
		begin
			slti = 1;     // 
		end
		6'h0c:
		begin
			andi = 1;    // 立即数与
		end
		6'h0d:
		begin
			ori = 1;    // 立即数或
		end
		6'h23:
		begin
			lw = 1;     // 载入�?
		end
		6'h2b:
		begin
			sw = 1;     // 存储�?
		end
		6'h00:    // 非R型指�?
		begin
			case (func)
			6'h00:
			begin
				sll = 1;
			end
			6'h02:
			begin
				srl = 1;
			end
			6'h03:
			begin
				sra = 1;
			end
			6'h08:
			begin
				jr = 1;
			end
			6'h0c:
			begin
				syscall = 1;
			end
			6'h20:
			begin
				add = 1;
			end
			6'h21:
			begin
				addu = 1;
			end
			6'h22:
			begin
				sub = 1;
			end
			6'h24:
			begin
				and_cp = 1;
			end
			6'h25:
			begin
				or_cp = 1;
			end
			6'h27:
			begin
				nor_cp = 1;
			end
			6'h2a:
			begin
				slt = 1;
			end
			6'h2b:
			begin
				sltu = 1;
			end
			endcase
		end
		endcase
		
        //generate alu_op
            //OR gates
            OR1 = add | addi | addu | sw | lw | addiu;
            OR2 = and_cp | andi;
            OR3 = or_cp | ori;
            OR4 = sll;
            OR5 = slt | slti;
            OR6 = srl;
            //AND gates
            AND1 = EXT(OR1) & 4'h5;
            AND2 = EXT(OR2) & 4'h7;
            AND3 = EXT(OR3) & 4'h8;
            AND4 = EXT(OR4) & 4'h0;
            AND5 = EXT(nor_cp) & 4'ha;
            AND6 = EXT(sra) & 4'h1;
            AND7 = EXT(OR5) & 4'hb;
            AND8 = EXT(sltu) & 4'hc;
            AND9 = EXT(sub) & 4'h6;
            AND10 = EXT(OR6) & 4'h2;
            //4-bit  gate
            aluop = AND1 | AND2 | AND3 | AND4 | AND5 | 
                     AND6 | AND7 | AND8 | AND9 | AND10;  
                  
        //generate ext_16
            ext_16 = andi | ori;  
            
        //generate ext_s
            ext_s = addi | addiu | lw | sw | bne | beq | slti;
        
        //generate ext_5
            ext_5 = sll | sra | srl;
        
        //generate regwrite
            regwrite = add | addu | addi | and_cp | andi | sll | addiu |
                       srl | sra | or_cp | ori | nor_cp | slt | sltu|
                       slti | sub | jal | lw;
	
	end //end always
	
	
endmodule