`timescale 1ns/1ps

// Testbench for lab5_p2.
// ONE_SEC_COUNT is shrunk to 3 so each "second" = 3 clock edges — enough for
// the tick/clear/update round trip without being slow to simulate.
//
// Stimulus: drive w through the canonical check sequence
//   0 0 0 0 1 1 1 1 1 0 0 0 0 1 0 0 0 0 0
// and verify state/z against a hand-worked reference for each tick.
module lab5_p2_TB;
	localparam CYCLES_PER_SEC = 3;
	localparam SEC_NS         = CYCLES_PER_SEC * 10;   // ns per simulated "second"

	reg        clk = 1'b0;
	reg        reset = 1'b1;
	reg        w = 1'b0;
	wire [6:0] hex0;
	wire [9:0] ledr;
	wire       z;
	wire [3:0] state;
	integer    errors;
	integer    step;

	lab5_p2 #(.ONE_SEC_COUNT(CYCLES_PER_SEC)) dut (
		.clk   (clk),
		.reset (reset),
		.w     (w),
		.hex0  (hex0),
		.ledr  (ledr),
		.z     (z),
		.state (state)
	);

	always #5 clk = ~clk;  // 100 MHz test clock

	// Stimulus + expected output. Length: 19 ticks.
	// Starting state: A (0). w sequence and expected post-tick state:
	//   idx  w    state_after   z
	//   0    0    B=1           0
	//   1    0    C=2           0
	//   2    0    D=3           0
	//   3    0    E=4           1   <- four 0s
	//   4    1    F=5           0
	//   5    1    G=6           0
	//   6    1    H=7           0
	//   7    1    I=8           1   <- four 1s
	//   8    1    I=8           1   <- overlap (fifth 1)
	//   9    0    B=1           0
	//  10    0    C=2           0
	//  11    0    D=3           0
	//  12    0    E=4           1   <- four 0s again
	//  13    1    F=5           0
	//  14    0    B=1           0
	//  15    0    C=2           0
	//  16    0    D=3           0
	//  17    0    E=4           1
	//  18    0    E=4           1   <- overlap (fifth 0)
	reg [0:0] w_seq     [0:18];
	reg [3:0] exp_state [0:18];
	reg [0:0] exp_z     [0:18];

	initial begin
		w_seq[ 0]=1'b0; exp_state[ 0]=4'd1; exp_z[ 0]=1'b0;
		w_seq[ 1]=1'b0; exp_state[ 1]=4'd2; exp_z[ 1]=1'b0;
		w_seq[ 2]=1'b0; exp_state[ 2]=4'd3; exp_z[ 2]=1'b0;
		w_seq[ 3]=1'b0; exp_state[ 3]=4'd4; exp_z[ 3]=1'b1;
		w_seq[ 4]=1'b1; exp_state[ 4]=4'd5; exp_z[ 4]=1'b0;
		w_seq[ 5]=1'b1; exp_state[ 5]=4'd6; exp_z[ 5]=1'b0;
		w_seq[ 6]=1'b1; exp_state[ 6]=4'd7; exp_z[ 6]=1'b0;
		w_seq[ 7]=1'b1; exp_state[ 7]=4'd8; exp_z[ 7]=1'b1;
		w_seq[ 8]=1'b1; exp_state[ 8]=4'd8; exp_z[ 8]=1'b1;
		w_seq[ 9]=1'b0; exp_state[ 9]=4'd1; exp_z[ 9]=1'b0;
		w_seq[10]=1'b0; exp_state[10]=4'd2; exp_z[10]=1'b0;
		w_seq[11]=1'b0; exp_state[11]=4'd3; exp_z[11]=1'b0;
		w_seq[12]=1'b0; exp_state[12]=4'd4; exp_z[12]=1'b1;
		w_seq[13]=1'b1; exp_state[13]=4'd5; exp_z[13]=1'b0;
		w_seq[14]=1'b0; exp_state[14]=4'd1; exp_z[14]=1'b0;
		w_seq[15]=1'b0; exp_state[15]=4'd2; exp_z[15]=1'b0;
		w_seq[16]=1'b0; exp_state[16]=4'd3; exp_z[16]=1'b0;
		w_seq[17]=1'b0; exp_state[17]=4'd4; exp_z[17]=1'b1;
		w_seq[18]=1'b0; exp_state[18]=4'd4; exp_z[18]=1'b1;

		errors = 0;
		$display("step | w | state | z | ledr        | exp(state,z) | result");
		$display("-----+---+-------+---+-------------+--------------+-------");

		// Release reset cleanly before the first tick.
		@(negedge clk);
		@(negedge clk);
		reset = 1'b0;

		// Drive each step: set w before the upcoming tick, wait one full
		// "second" (CYCLES_PER_SEC edges), then sample after the tick.
		for (step = 0; step < 19; step = step + 1) begin
			w = w_seq[step];
			// Wait a full simulated second so exactly one tick happens.
			#(SEC_NS);

			if (state === exp_state[step] && z === exp_z[step])
				$display(" %2d  | %b |   %0d   | %b | %b  | (%0d, %b)     | OK",
				         step, w, state, z, ledr, exp_state[step], exp_z[step]);
			else begin
				$display(" %2d  | %b |   %0d   | %b | %b  | (%0d, %b)     | FAIL",
				         step, w, state, z, ledr, exp_state[step], exp_z[step]);
				errors = errors + 1;
			end
		end

		if (errors == 0) $display("PASS: all 19 steps matched");
		else             $display("FAIL: %0d mismatches", errors);
		$finish;
	end
endmodule
