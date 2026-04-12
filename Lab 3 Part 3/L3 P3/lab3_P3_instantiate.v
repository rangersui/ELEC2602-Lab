module lab3_P3_instantiate(SW,HEX1,HEX2, HEX3, HEX4);
 
	input[9:0] SW ;
	output [6:0] HEX1, HEX2, HEX3, HEX4;
	lab3_P3 instantiate_p6 (.s(SW[9:8]),.u(SW[7:6]),.v(SW[5:4]),.w(SW[3:2]),.x(SW[1:0]),
							.code1(HEX1),
							.code2(HEX2),
							.code3(HEX3),
							.code4(HEX4)
							); 
endmodule