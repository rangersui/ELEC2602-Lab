module lab3_P2 (s,u,v,w,x,chosen_7segCode);
 
	input[1:0] s;
	input[1:0] u, v, w, x;
	output[6:0] chosen_7segCode;
	
	wire[1:0] temp;
	
	/* need to connect an instance of two_bit_4to1mux or
	two_bit_4to1muxV2 (named part3) to an instance of decoder_7seg
	named part4. 
	
	Use the wire 2-bit called temp to connect them 
	(note output of two_bit_4to1mux is 2-bit, input to decoder_7seg is 
	2-bit)
	*/
	
	// Complete your choice of the following
	// module two_bit_4to1muxV2 (s,u,v,w,x,m);

	two_bit_4to1muxV2 part2(.s(s),.u(u),.v(v),.w(w),.x(x),.m(temp));


	decoder_7seg part1(.code(temp),.decoded_output(chosen_7segCode));
	
	//two_bit_4to1mux part3(.s(),...);
	//two_bit_4to1muxV2 part3(.s(),...);
	//decoder_7seg part4(.code());

endmodule
