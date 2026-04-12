`timescale 1ns / 1ps
module lab4_p3_TB(a,b,cin,cout,s);

	reg [3:0] count;
	//Add inputs/outputs
	
	//instantiate and connect fourBit_FA
 	
	initial begin 
		count = 4'b0000;
	end
	
	always begin
		#50
		count=count+4'b0001;
	end
	
	always @(count) begin
		case (count)
		4'b0000 : begin ??? end
		default : begin ??? end
	endcase
	end
	
endmodule