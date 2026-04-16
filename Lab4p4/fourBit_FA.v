module fourBit_FA(a, b, cin, cout, s);
	input [3:0] a, b;
	input cin;
	output cout;
	output [3:0] s;

	wire c1, c2, c3;

	FA fa0(.a(a[0]), .b(b[0]), .cin(cin),  .cout(c1), .s(s[0]));
	FA fa1(.a(a[1]), .b(b[1]), .cin(c1),   .cout(c2), .s(s[1]));
	FA fa2(.a(a[2]), .b(b[2]), .cin(c2),   .cout(c3), .s(s[2]));
	FA fa3(.a(a[3]), .b(b[3]), .cin(c3),   .cout(cout), .s(s[3]));
endmodule
