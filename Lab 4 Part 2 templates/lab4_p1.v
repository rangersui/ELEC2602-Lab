module decoder_7seg_2output(code, decoded_output);

	input[3:0] code;
	output reg[13:0]  decoded_output;


	always @(code) begin
		case (code)
		4'h1 : begin decoded_output = 14'h01; end
		4'h2 : begin decoded_output = 14'h0A; end
		4'h3 : begin decoded_output = 14'hFF; end
		default : begin decoded_output = 14'hFF; end
	endcase
	end
	

 
endmodule
