// lab5_p2_instantiate.v
// Board wrapper for DE1-SoC. Maps physical board pins to the logical
// ports of lab5_p2 (FSM with 1-second tick).
//
// Pin mapping:
//   CLOCK_50 -> clk    (50 MHz free-running clock)
//   KEY[0]   -> reset  (active-LOW on DE1-SoC, so we invert: pressing KEY0 = reset)
//   SW[1]    -> w      (FSM input bit; per lab spec)
//   HEX0     <- hex0   (current state 0..8 on 7-seg)
//   LEDR     <- ledr   (all 10 red LEDs on when z=1)
//
// Other 7-seg displays are blanked explicitly so they don't show stale
// segments from a prior bitstream.
module lab5_p2_instantiate(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input         CLOCK_50;
	input  [3:0]  KEY;
	input  [9:0]  SW;
	output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0]  LEDR;

	// Default ONE_SEC_COUNT = 50_000_000: one FSM transition per second.
	lab5_p2 core (
		.clk    (CLOCK_50),
		.reset  (~KEY[0]),   // KEY active-low on DE1-SoC
		.w      (SW[1]),     // input symbol per lab spec
		.hex0   (HEX0),
		.ledr   (LEDR),
		.z      (),          // debug port, unused on board
		.state  ()           // debug port, unused on board
	);

	// Blank the unused 7-seg displays (active-low: all segments off).
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
endmodule
