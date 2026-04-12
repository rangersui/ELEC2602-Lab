module lab4_p2 (v, d1, d2);
    input [3:0] v; 
	output [6:0] d1, d2; 
	
	//Add any required intermediate wires here
	wire [3:0] wire1, wire2;
	wire wire3;
	
	circuitA inst_circA(.v(),.A());
	comparator inst_comp(.v(),.z());
	circuitB inst_circB(.z(),.d1());
	four_bit_2to1mux inst_mux(.sel(),.a(),.b(),.chosen());
	binary_to_7Seg instantiate_bto7seg(.binary(),.sevenSeg());
	
endmodule;