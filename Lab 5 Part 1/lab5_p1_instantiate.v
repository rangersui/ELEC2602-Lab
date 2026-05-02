// lab5_p1_instantiate.v
// Board wrapper for DE1-SoC. Maps physical board pins to the logical
// ports of lab5_p1.
//
// Pin mapping:
//   CLOCK_50 -> clk    (50 MHz free-running clock)
//   KEY[0]   -> reset  (active-LOW on DE1-SoC, so we invert: pressing KEY0 = reset)
//   HEX0     <- hex0   (the flashing 0..9 digit)
//
// All other 7-seg displays (HEX1..HEX5) are blanked explicitly so they
// don't show ghost segments from a previous bitstream.
// LEDRs are off.
module lab5_p1_instantiate(CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input        CLOCK_50;
	input  [3:0] KEY;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;

	// Use default ONE_SEC_COUNT = 50_000_000 so each digit holds for 1 s.
	lab5_p1 core (
		.clk       (CLOCK_50),
		.reset     (~KEY[0]),  // KEY is active-low; pressing KEY0 asserts reset
		.hex0      (HEX0),
		.digit_out ()          // debug port, unused on the board
	);

	// Blank the unused 7-seg displays (active-low: all segments off).
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	// Red LEDs off (nothing to show in Part 1).
	assign LEDR = 10'b0;
endmodule
