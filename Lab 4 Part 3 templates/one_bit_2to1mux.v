module one_bit_2to1mux (s,x,y,m);
 
	input s, x, y;
	output m;
	
	assign m = (~(s) & x) | (s & y);
 
endmodule
