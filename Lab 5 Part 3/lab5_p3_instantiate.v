// lab5_p3_instantiate.v
// Board wrapper for DE1-SoC.
//
// Pin mapping:
//   CLOCK_50  -> clk     (50 MHz)
//   KEY[0]    -> reset   (active-LOW; pressing = reset)
//   KEY[2]    -> pause   (active-LOW; press to TOGGLE freeze/resume)
//   KEY[3]    -> save    (active-LOW; pressing = latch SW[9:6] as N)
//   SW[1]     -> w       (input bit, sampled each tick)
//   SW[9:6]   -> n_in    (candidate threshold N)
//   HEX0      <- count   (current streak length)
//   HEX5      <- saved N
//   LEDR      <- z       (all 10 LEDs on when z=1)
//   HEX1..HEX4 blanked
module lab5_p3_instantiate(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input         CLOCK_50;
	input  [3:0]  KEY;
	input  [9:0]  SW;
	output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0]  LEDR;

	wire reset_w        = ~KEY[0];
	wire pause_pressed  = ~KEY[2];

	// Edge-detect KEY[2] so each press toggles paused.
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
		.clk         (CLOCK_50),
		.reset       (reset_w),
		.w           (SW[1]),
		.n_in        (SW[9:6]),
		.save        (~KEY[3]),
		.pause       (paused),
		.hex0        (HEX0),
		.hex5        (HEX5),
		.ledr        (LEDR),
		.z           (),
		.count       (),
		.saved_n_out ()
	);

	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
endmodule
