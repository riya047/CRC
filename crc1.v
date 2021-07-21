`timescale 1ns / 1ps
module crc1(input clk,
				input rst,
				input [31:0]data,
				output reg Y,
				output reg [31:0]out,
				output reg [47:0]send,
				output reg [15:0]crc,res
				);
	integer i,j;
	reg c;
	
	function [15:0]pad(input [15:0]a);
		begin
			for(j=15;j>0;j=j-1)
				begin
					if(j==15 || j==2) a[j]=a[j-1]^c;
					else a[j]=a[j-1];
				end
			a[0]=c;
			pad[15:0]=a[15:0];
		end
	endfunction

	function [47:0]sender(input [31:0]b,input [15:0]k);
		begin
			for(i=31;i>=0;i=i-1)
					begin
						c=b[i]^k[15];
						k[15:0]=pad(k[15:0]);
					end
			sender={b[31:0],k[15:0]};
		end
	endfunction
	
	function [15:0]receiver(input [47:0]m,input [15:0]n);
		begin
			for(i=47;i>=0;i=i-1)
					begin
						c=send[i]^res[15];
						res[15:0]=pad(res[15:0]);
					end
			receiver[15:0]=res[15:0];
		end
	endfunction
			
	always@(posedge clk)
		if(rst)
			begin
				Y=0;
				out=0;
			end
		else
			begin
				crc=0;
				send[47:0]=sender(data[31:0],crc[15:0]);
				crc[15:0]=send[15:0];
				res=0;
				res=receiver(send[47:0],res[15:0]);
				if(res[15:0]==0)
					begin
						Y=1;
						out[31:0]=send[47:16];
					end
				else
					begin
						Y=0;
						out=0;
					end
			end
endmodule
