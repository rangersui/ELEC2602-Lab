module lab4_p2 (v, d1, d2);
    input [3:0] v;

	output [6:0] d1, d2; 
	
	//Add any required intermediate wires here

	wire comp_output;
	wire [3:0] A_output;
	wire [3:0] mux_output;
	
	circuitA inst_circA(.v(v),.A(A_output));
	comparator inst_comp(.v(v),.z(comp_output));
	circuitB inst_circB(.z(comp_output),.d1(d1));
	four_bit_2to1mux inst_mux(.sel(comp_output),.a(v),.b(A_output),.chosen(mux_output));
	decoder_7seg instantiate_bto7seg(.code(mux_output),.decoded_output(d2));
	
endmodule