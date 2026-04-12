`timescale 1ns / 1ps
 
module lab3_p1_TB;
 
	// ------------------ Instantiate module ------------------
	// We are instantiating the module mux2, naming it instantiate_mux2.
	// select, input1, input2 are controlled by the testbench, output is 
	// checked  within the testbench
 
	reg [3:0] count;
	reg [1:0] input_c;
	wire [6:0] output_7seg;
	decoder_7seg instantiate_decoder(.code(input_c),.decoded_output(output_7seg));
 	
	initial begin 
		count = 4'b0000;
	end
	
	always begin
		#50
		count=count+4'b0001;
	end
	
	always @(count) begin
		case (count)
		4'b0000 : begin input_c = 2'b00; end
		4'b0001 : begin input_c = 2'b01; end
		4'b0010 : begin input_c = 2'b10; end
		default : begin input_c = 2'b11; end
	endcase
	end

 
endmodule
