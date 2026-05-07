// lab5_p3_instantiate.v
// Board wrapper for DE1-SoC. Maps physical board pins to the logical
// ports of lab5_p3 (4-bit pattern matcher).
//
// Pin mapping:
//   CLOCK_50  -> clk      (50 MHz)
//   KEY[0]    -> reset    (active-LOW; pressing KEY0 = reset)
//   KEY[2]    -> pause    (active-LOW; press to TOGGLE — freezes/resumes FSM)
//   KEY[3]    -> save     (active-LOW; pressing KEY3 = latch SW[9:6] as pattern)
//   SW[1]     -> w        (input bit, shifted into the window each tick)
//   SW[9:6]   -> n_in     (candidate 4-bit pattern, latched on save)
//   HEX0      <- window   (current 4-bit window, as hex digit)
//   HEX1      <- bit 0    (newest bit, just shifted in)
//   HEX2      <- bit 1
//   HEX3      <- bit 2
//   HEX4      <- bit 3    (oldest bit, will fall off next tick)
//   HEX5      <- pattern  (currently-saved pattern)
//   LEDR      <- z        (all 10 LEDs on when window matches pattern)
module lab5_p3_instantiate(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input         CLOCK_50;
	input  [3:0]  KEY;
	input  [9:0]  SW;
	output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0]  LEDR;

	wire reset_w        = ~KEY[0];
	wire pause_pressed  = ~KEY[2];

	// Edge-detect KEY[2] so each press toggles the paused state.
	// (No debouncing — a clean button press should produce one rising edge.)
	reg pause_pressed_prev;
	reg paused;

	always @(posedge CLOCK_50) begin
		if (reset_w) begin
			pause_pressed_prev <= 1'b0;
			paused             <= 1'b0;
		end
		else begin
			pause_pressed_prev <= pause_pressed;
			if (pause_pressed && !pause_pressed_prev)
				paused <= ~paused;
		end
	end

	lab5_p3 core (
		.clk    (CLOCK_50),
		.reset  (reset_w),
		.w      (SW[1]),
		.save   (~KEY[3]),
		.pause  (paused),
		.n_in   (SW[9:6]),
		.hex0   (HEX0),
		.hex1   (HEX1),
		.hex2   (HEX2),
		.hex3   (HEX3),
		.hex4   (HEX4),
		.hex5   (HEX5),
		.ledr   (LEDR),
		.z      (),
		.count  (),
		.n_out  ()
	);
endmodule
