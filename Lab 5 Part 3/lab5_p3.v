// Lab 5 Part 3 — programmable pattern matcher.
//
// The FSM is a 4-bit sliding-window detector. Each second (one tick), it
// shifts in the current value of w and compares the resulting 4-bit window
// against a user-programmable pattern.
//
// Pieces (all clocked at 50 MHz):
//   1) sec_counter (from Part 1) divides 50 MHz down to a 1-cycle tick once
//      per ONE_SEC_COUNT cycles. That tick gates the FSM.
//   2) pattern_register (n_register) holds the saved 4-bit pattern.
//   3) fsm (next_state + state_reg + output) shifts in w each tick and
//      asserts z when the window == pattern.
//
// Display:
//   HEX0 -> current 4-bit window (as a single hex digit, 0..F)
//   HEX1 -> window[0]  (newest bit)
//   HEX2 -> window[1]
//   HEX3 -> window[2]
//   HEX4 -> window[3]  (oldest bit)
//   HEX5 -> currently-saved pattern (as a single hex digit)
//   LEDR -> all on while z=1 (window matches pattern)
//
// HEX1..HEX4 spell out the sliding window bit-by-bit so you can see each
// bit move left as a new bit shifts in on the right. Reading left to right
// (HEX4 -> HEX1) gives the bits in chronological order, oldest first.
//
// ONE_SEC_COUNT is a parameter so the testbench can shrink it for fast sim.
module lab5_p3 #(parameter ONE_SEC_COUNT = 50_000_000) (
	input        clk,
	input        reset,
	input        w,
	input        save,
	input        pause,        // when 1, FSM holds its state (window stops shifting)
	input  [3:0] n_in,         // pattern_in (kept name n_in to avoid wrapper churn)
	output [6:0] hex0,         // current window (as hex digit)
	output [6:0] hex1,         // window[0] - newest bit
	output [6:0] hex2,         // window[1]
	output [6:0] hex3,         // window[2]
	output [6:0] hex4,         // window[3] - oldest bit
	output [6:0] hex5,         // saved pattern
	output [9:0] ledr,         // mirrored z
	output       z,             // exposed for sim
	output [3:0] count,         // window contents (for sim debug)
	output [3:0] n_out          // saved pattern (for sim debug)
);
	localparam SEC_WIDTH = 26;

	wire [SEC_WIDTH-1:0] sec_count;
	wire                 tick;
	wire                 fsm_enable;
	wire [3:0]           pattern;
	wire [3:0]           window;

	assign tick       = (sec_count == ONE_SEC_COUNT - 1);
	assign fsm_enable = tick & ~pause;   // freeze the FSM when paused

	counter #(.N(SEC_WIDTH)) sec_counter (
		.clk    (clk),
		.clear  (reset | tick),
		.enable (1'b1),
		.q      (sec_count)
	);

	n_register pattern_reg (
		.clk   (clk),
		.reset (reset),
		.save  (save),
		.n_in  (n_in),
		.n_out (pattern)
	);

	fsm fsm_inst (
		.clk     (clk),
		.reset   (reset),
		.enable  (fsm_enable),
		.w       (w),
		.pattern (pattern),
		.z       (z),
		.state   (window)
	);

	decoder_7seg hex0_dec (.code(window),                 .decoded_output(hex0));
	decoder_7seg hex1_dec (.code({3'b000, window[0]}),    .decoded_output(hex1));
	decoder_7seg hex2_dec (.code({3'b000, window[1]}),    .decoded_output(hex2));
	decoder_7seg hex3_dec (.code({3'b000, window[2]}),    .decoded_output(hex3));
	decoder_7seg hex4_dec (.code({3'b000, window[3]}),    .decoded_output(hex4));
	decoder_7seg hex5_dec (.code(pattern),                .decoded_output(hex5));

	assign ledr  = {10{z}};
	assign count = window;
	assign n_out = pattern;
endmodule
