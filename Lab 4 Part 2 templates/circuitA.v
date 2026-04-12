module circuitA (v, A);
	input [3:0] v;
	output [3:0] A;
  
	always @(binary) begin
		case (binary)
		4'b0000 : begin A = 4'b????; end
		...
		default : begin ... end
	endcase
	end
endmodule;