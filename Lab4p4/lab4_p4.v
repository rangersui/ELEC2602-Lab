module lab4_p4(a, b, cin, d1, d2);
	input [3:0] a, b;
	input cin;
	output [6:0] d1, d2;

	wire [3:0] sum;
	wire cout;

	fourBit_FA adder(.a(a), .b(b), .cin(cin), .cout(cout), .s(sum));
	lab4_p2 bcd_display(.v(sum), .d1(d1), .d2(d2));
endmodule
