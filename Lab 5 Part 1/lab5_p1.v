// Lab 5 Part 1 — 1 Hz digit flasher on HEX0.
//
// Clocked at 50 MHz. Two counters (both built from the T-FF/generate template):
//   1) sec_counter: 26-bit, counts clock cycles. When it reaches
//      ONE_SEC_COUNT-1 it asserts a one-cycle pulse (one_sec_pulse) and
//      resets itself on the next edge.
//   2) digit_counter: 4-bit. Enabled only by one_sec_pulse, so it
//      increments exactly once per second. When digit hits 9 and the
//      pulse fires again, clear brings it back to 0.
//
// ONE_SEC_COUNT is a parameter so the testbench can shrink it for sim.
// For the real board keep 50_000_000 (50 MHz clock).
module lab5_p1 #(parameter ONE_SEC_COUNT = 50_000_000) (
	input        clk,          // 50 MHz clock on the board
	input        reset,        // synchronous reset (active high)
	output [6:0] hex0,         // digit -> 7-segment display
	output [3:0] digit_out     // exposed for sim/debug
);
	// 26 bits covers ONE_SEC_COUNT up to ~67M, so fine for 50M.
	localparam SEC_WIDTH = 26;

	wire [SEC_WIDTH-1:0] sec_count;
	wire [3:0]           digit;
	wire                 one_sec_pulse;
	wire                 digit_wrap;

	// One-cycle pulse when the 1-second counter reaches the terminal value.
	assign one_sec_pulse = (sec_count == ONE_SEC_COUNT - 1);

	// When we're at "9" and the next second pulse fires, wrap to 0.
	assign digit_wrap = (digit == 4'd9) && one_sec_pulse;

	// 1-second timer: runs continuously, resets itself each second.
	counter #(.N(SEC_WIDTH)) sec_counter (
		.clk   (clk),
		.clear (reset | one_sec_pulse),
		.enable(1'b1),
		.q     (sec_count)
	);

	// Digit counter: 0..9 loop, stepped once per second.
	counter #(.N(4)) digit_counter (
		.clk   (clk),
		.clear (reset | digit_wrap),
		.enable(one_sec_pulse),
		.q     (digit)
	);

	decoder_7seg hex0_decoder (
		.code           (digit),
		.decoded_output (hex0)
	);

	assign digit_out = digit;
endmodule
