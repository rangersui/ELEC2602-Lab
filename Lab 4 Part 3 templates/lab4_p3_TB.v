`timescale 1ns / 1ps

module lab4_p3_TB;
	reg [3:0] a, b;
	reg cin;
	wire cout;
	wire [3:0] s;
	integer i, errors;
	reg [4:0] expected;

	fourBit_FA dut(.a(a), .b(b), .cin(cin), .cout(cout), .s(s));

	initial begin
		errors = 0;
		$display("  a    b  cin | cout  s   | exp   | result");
		$display("-------------+----------+-------+-------");

		for (i = 0; i < 512; i = i + 1) begin
			a   = i[3:0];
			b   = i[7:4];
			cin = i[8];
			#10;

			expected = a + b + cin;

			if ({cout, s} === expected)
				; // OK, silent
			else begin
				$display(" %2d + %2d + %1b | %b %b | %b | FAIL",
				         a, b, cin, cout, s, expected);
				errors = errors + 1;
			end
		end

		if (errors == 0) $display("PASS: all 512 cases matched");
		else             $display("FAIL: %0d mismatches", errors);
		$finish;
	end
endmodule
