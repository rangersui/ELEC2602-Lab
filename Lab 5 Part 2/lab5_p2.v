// Lab 5 Part 2 — board-ready top.
//
// - Derives a 1-second "tick" (1 cycle wide) from the 50 MHz clock using the
//   26-bit T-FF counter from Part 1. That tick gates the FSM so state
//   transitions happen once per second.
// - Drives HEX0 with the decoded current state (0..8).
// - Lights all red LEDs when z is high.
//
// ONE_SEC_COUNT is a parameter so sims can shrink the tick to a few cycles.
module lab5_p2 #(parameter ONE_SEC_COUNT = 50_000_000) (
	input        clk,           // 50 MHz on the DE1-SoC
	input        reset,         // synchronous reset
	input        w,              // input bit to classify (SW1 on board)
	output [6:0] hex0,          // current state on 7-seg
	output [9:0] ledr,          // all-on when z=1
	output       z,              // exposed for sim
	output [3:0] state           // exposed for sim
);
	localparam SEC_WIDTH = 26;

	wire [SEC_WIDTH-1:0] sec_count;
	wire                 tick;

	assign tick = (sec_count == ONE_SEC_COUNT - 1);

	counter #(.N(SEC_WIDTH)) sec_counter (
		.clk   (clk),
		.clear (reset | tick),
		.enable(1'b1),
		.q     (sec_count)
	);

	fsm fsm_inst (
		.clk    (clk),
		.reset  (reset),
		.enable (tick),
		.w      (w),
		.z      (z),
		.state  (state)
	);

	decoder_7seg hex0_dec (
		.code           (state),
		.decoded_output (hex0)
	);

	// All LEDs on when z asserted.
	assign ledr = {10{z}};
endmodule
