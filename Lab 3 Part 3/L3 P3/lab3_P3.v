module lab3_P3 (s,u,v,w,x,code1,code2,code3,code4);
 
	input[1:0] s;
	input[1:0] u, v, w, x;
	output[6:0] code1, code2, code3,code4;
		
	// You need 4 instances of lab3_P2 connected to inputs appropriately.

	
	lab3_P2 inst1(.s(s), .u(u), .v(v), .w(w), .x(x), .chosen_7segCode(code1));
	lab3_P2 inst2(.s(s), .u(v), .v(w), .w(x), .x(u), .chosen_7segCode(code2));
	lab3_P2 inst3(.s(s), .u(w), .v(x), .w(u), .x(v), .chosen_7segCode(code3));
	lab3_P2 inst4(.s(s), .u(x), .v(u), .w(v), .x(w), .chosen_7segCode(code4));

endmodule 