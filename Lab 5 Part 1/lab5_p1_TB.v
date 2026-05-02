`timescale 1ns/1ps

// Testbench for lab5_p1.
// Shrinks ONE_SEC_COUNT from 50_000_000 to 5 so one "second" = 5 clock edges.
// Checks that digit cycles 0->1->2->...->9->0 and holds each digit for
// exactly ONE_SEC_COUNT clock edges.
module lab5_p1_TB;
	localparam CYCLES_PER_SEC = 5;

	reg        clk = 1'b0;
	reg        reset = 1'b1;
	wire [6:0] hex0;
	wire [3:0] digit;
	integer    i, errors;
	integer    expected_digit;

	lab5_p1 #(.ONE_SEC_COUNT(CYCLES_PER_SEC)) dut (
		.clk       (clk),
		.reset     (reset),
		.hex0      (hex0),
		.digit_out (digit)
	);

	// 100 MHz testbench clock (10 ns period).
	always #5 clk = ~clk;

	// Known-good 7-seg reference for spot-checking hex0.
	function [6:0] seg;
		input [3:0] d;
		case (d)
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
		$display("time | digit | hex0     | expected | result");
		$display("-----+-------+----------+----------+-------");

		// Hold reset for a couple of edges, then release on a falling edge
		// so the very first counted posedge sees reset=0.
		@(negedge clk);
		@(negedge clk);
		reset = 1'b0;

		// Walk through two full 0..9 cycles (20 digit transitions).
		for (i = 0; i < 20; i = i + 1) begin
			expected_digit = i % 10;

			// Sample near the middle of the "second" so the
			// combinational decoder has settled.
			#( (CYCLES_PER_SEC * 10) / 2 );

			if (digit === expected_digit[3:0] && hex0 === seg(expected_digit[3:0]))
				$display("%4t |   %0d   | %b  | %b  | OK",
				         $time, digit, hex0, seg(expected_digit[3:0]));
			else begin
				$display("%4t |   %0d   | %b  | %b  | FAIL (expected %0d)",
				         $time, digit, hex0, seg(expected_digit[3:0]), expected_digit);
				errors = errors + 1;
			end

			// Advance to the next "second".
			#( (CYCLES_PER_SEC * 10) / 2 );
		end

		if (errors == 0) $display("PASS: all 20 digit steps matched (0..9 twice)");
		else             $display("FAIL: %0d mismatches", errors);
		$finish;
	end
endmodule
