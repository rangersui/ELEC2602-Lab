`timescale 1ns / 1ps

module lab4_p4_TB;
	reg [3:0] a, b;
	reg cin;
	wire [6:0] d1, d2;
	integer i, j, k, errors;
	integer sum;
	reg [3:0] exp_tens, exp_units;
	reg [6:0] exp_d1, exp_d2;

	lab4_p4 dut(.a(a), .b(b), .cin(cin), .d1(d1), .d2(d2));

	function [6:0] seg;
		input [3:0] digit;
		case (digit)
			4'd0: seg = 7'b1000000;
			4'd1: seg = 7'b1111001;
			4'd2: seg = 7'b0100100;
			4'd3: seg = 7'b0110000;
			4'd4: seg = 7'b0011001;
			4'd5: seg = 7'b0010010;
			4'd6: seg = 7'b0000010;
			4'd7: seg = 7'b1111000;
			4'd8: seg = 7'b0000000;
			4'd9: seg = 7'b0010000;
			default: seg = 7'b1111111;
		endcase
	endfunction

	initial begin
		errors = 0;
		$display("  a  b cin | sum | d1 (tens)  exp      | d2 (units) exp      | result");
		$display("----------+-----+---------------------+---------------------+-------");

		for (i = 0; i <= 7; i = i + 1) begin
			for (j = 0; j <= 7; j = j + 1) begin
				for (k = 0; k <= 1; k = k + 1) begin
					a = i[3:0];
					b = j[3:0];
					cin = k[0];
					#10;

					sum = i + j + k;
					exp_tens  = sum / 10;
					exp_units = sum % 10;
					exp_d1 = seg(exp_tens[3:0]);
					exp_d2 = seg(exp_units[3:0]);

					if (d1 === exp_d1 && d2 === exp_d2)
						; // OK
					else begin
						$display(" %1d  %1d  %1d  |  %2d | %b %b | %b %b | FAIL",
						         i, j, k, sum, d1, exp_d1, d2, exp_d2);
						errors = errors + 1;
					end
				end
			end
		end

		if (errors == 0) $display("PASS: all 128 cases matched");
		else             $display("FAIL: %0d mismatches", errors);
		$finish;
	end
endmodule
