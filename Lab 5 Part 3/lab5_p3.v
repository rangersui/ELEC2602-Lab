// Lab 5 Part 3 — programmable streak detector.
//
// User specifies (and saves with KEY[3]):
//   N (SW[9:6])  : how many consecutive identical bits trigger success
//
// Data input w (SW[1]) is sampled once per second by the FSM. A streak
// counter counts consecutive bits of the same value; when the streak
// reaches N (regardless of whether the bits are 0s or 1s), z=1 and all 10
// LEDs light up. If w changes before reaching N, the counter resets to 1.
//
// Examples (N=5):
//   11111            -> success on the 5th tick
//   00000            -> success on the 5th tick
//   00111100011111   -> success on the final '1' (5 consecutive 1s at end)
//   11000011100000   -> success on the final '0' (5 consecutive 0s at end)
//
// Pieces (all clocked at 50 MHz):
//   1) sec_counter divides 50 MHz to a 1-cycle tick once per ONE_SEC_COUNT
//      cycles, gating the FSM (subject to pause).
//   2) save_register holds the user-saved N.
//   3) fsm tracks streak length and asserts z when count >= N.
//
// Display:
//   HEX0 -> current streak length
//   HEX5 -> saved N
//   LEDR -> all on while z=1
module lab5_p3 #(parameter ONE_SEC_COUNT = 50_000_000) (
	input        clk,
	input        reset,
	input        w,
	input  [3:0] n_in,             // candidate N (latched on save)
	input        save,             // pulse to save n_in
	input        pause,            // freeze FSM
	output [6:0] hex0,             // current streak count
	output [6:0] hex5,             // saved N
	output [9:0] ledr,             // mirrored z
	output       z,                 // exposed for sim
	output [3:0] count,             // exposed for sim
	output [3:0] saved_n_out        // exposed for sim
);
	localparam SEC_WIDTH = 26;

	wire [SEC_WIDTH-1:0] sec_count;
	wire                 tick;
	wire                 fsm_enable;
	wire [3:0]           saved_n;

	assign tick       = (sec_count == ONE_SEC_COUNT - 1);
	assign fsm_enable = tick & ~pause;

	counter #(.N(SEC_WIDTH)) sec_counter (
		.clk    (clk),
		.clear  (reset | tick),
		.enable (1'b1),
		.q      (sec_count)
	);

	save_register save_reg (
		.clk   (clk),
		.reset (reset),
		.save  (save),
		.n_in  (n_in),
		.n_out (saved_n)
	);

	fsm fsm_inst (
		.clk    (clk),
		.reset  (reset),
		.enable (fsm_enable),
		.w      (w),
		.n      (saved_n),
		.z      (z),
		.count  (count)
	);

	decoder_7seg hex0_dec (.code(count),   .decoded_output(hex0));
	decoder_7seg hex5_dec (.code(saved_n), .decoded_output(hex5));

	assign ledr        = {10{z}};
	assign saved_n_out = saved_n;
endmodule
