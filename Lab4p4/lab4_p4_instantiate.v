// lab4_p4_instantiate.v
// Board wrapper for DE1-SoC. Maps physical board pins (SW, LEDR, HEX0..5)
// to the logical ports of lab4_p4 (a, b, cin, d1, d2).
//
// Input mapping (all on slider switches):
//   SW[3:0] -> a   (first 4-bit operand,  range [0..7])
//   SW[7:4] -> b   (second 4-bit operand, range [0..7])
//   SW[8]   -> cin (carry-in)
//   SW[9]   -> unused
//
// Output mapping:
//   HEX0 <- d2 (units digit, 0..9)
//   HEX1 <- d1 (tens digit,  0 or 1)
//   HEX2..HEX5 blanked (active-low: all 1s)
//
// LEDR mirrors the switch inputs so the user can see what they set.

module lab4_p4_instantiate(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// Core combinational circuit: 4-bit adder + BCD display
	lab4_p4 core (
		.a   (SW[3:0]),
		.b   (SW[7:4]),
		.cin (SW[8]),
		.d1  (HEX1),   // tens
		.d2  (HEX0)    // units
	);

	// Blank the unused 7-segment displays (active-low: all segments off)
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	// Echo the inputs on the red LEDs for visual confirmation
	assign LEDR[3:0] = SW[3:0];   // a
	assign LEDR[7:4] = SW[7:4];   // b
	assign LEDR[8]   = SW[8];     // cin
	assign LEDR[9]   = 1'b0;      // spare
endmodule
