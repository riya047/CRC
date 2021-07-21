`timescale 1ns / 1ps
module tb_crc1();
	reg clk,rst;
	reg [31:0]data;
	wire Y;
	wire [31:0]out;
	wire [47:0]send;
	wire [15:0]crc,res;
	crc1 c1(clk,rst,data,Y,out,send,crc,res);
	initial
		begin
			clk=0;
			forever #5 clk=~clk;
		end
	initial
		begin
			rst=0;
			#1 rst=1;
			#10 rst=0;
		end
	always #4 data=$random();
endmodule
