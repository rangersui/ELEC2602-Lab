`timescale 1ns/1ps

// Testbench for lab5_p3 (streak counter, threshold N).
// z fires whenever count reaches N — regardless of whether the streak is 0s
// or 1s. Streak resets to 1 whenever w changes.
//
// Cases mirror the examples from the spec (with N=5):
//   11111            -> z fires after 5th 1
//   00000            -> z fires after 5th 0
//   00111100011111   -> z fires only after the final 5-of-1s tail
//   11000011100000   -> z fires only after the final 5-of-0s tail
module lab5_p3_TB;
	localparam CYCLES_PER_SEC = 3;

	reg         clk = 1'b0;
	reg         reset = 1'b1;
	reg         w = 1'b0;
	reg  [3:0]  n_in = 4'd0;
	reg         save = 1'b0;
	reg         pause = 1'b0;
	wire [6:0]  hex0, hex5;
	wire [9:0]  ledr;
	wire        z;
	wire [3:0]  count;
	wire [3:0]  saved_n_out;
	integer     errors = 0;
	integer     i;

	lab5_p3 #(.ONE_SEC_COUNT(CYCLES_PER_SEC)) dut (
		.clk         (clk),
		.reset       (reset),
		.w           (w),
		.n_in        (n_in),
		.save        (save),
		.pause       (pause),
		.hex0        (hex0),
		.hex5        (hex5),
		.ledr        (ledr),
		.z           (z),
		.count       (count),
		.saved_n_out (saved_n_out)
	);

	always #5 clk = ~clk;

	task tick_and_check;
		input        in_w;
		input  [3:0] exp_count;
		input        exp_z;
		input integer step_id;
		begin
			w = in_w;
			if (!dut.tick) @(posedge dut.tick);
			@(posedge clk); #1;
			if (count === exp_count && z === exp_z)
				$display(" %2d  | w=%b | count=%2d (exp %2d) | z=%b (exp %b) | N=%0d | OK",
				         step_id, w, count, exp_count, z, exp_z, saved_n_out);
			else begin
				$display(" %2d  | w=%b | count=%2d (exp %2d) | z=%b (exp %b) | N=%0d | FAIL",
				         step_id, w, count, exp_count, z, exp_z, saved_n_out);
				errors = errors + 1;
			end
		end
	endtask

	task save_n;
		input [3:0] new_n;
		begin
			@(negedge clk);
			n_in = new_n;
			save = 1'b1;
			@(posedge clk); #1;
			save = 1'b0;
			$display("--- saved N=%0d ---", new_n);
		end
	endtask

	// Apply a sequence of bits and check that z fires at exactly the right step.
	// Assumes count starts at 0.
	task feed_sequence;
		input [127:0] label;
		input [255:0] bits_str;       // ASCII string of '0'/'1' chars
		input integer len;
		input  [3:0]  current_n;
		input integer expected_fire_step; // -1 if z should never fire
		integer       j, b;
		integer       fired_at;
		integer       expected_count;
		reg           expected_z;
		reg [3:0]     prev_bit;
		reg [3:0]     running;
		begin
			$display("\n[%0s] sequence: %0s   (N=%0d)", label, bits_str, current_n);
			fired_at = -1;
			running = 0;
			prev_bit = 4'hX;
			for (j = 0; j < len; j = j + 1) begin
				b = bits_str[(len - 1 - j) * 8 +: 8] - "0";  // get j-th char as 0/1
				// Compute expected count: streak length so far
				if (running == 0)
					running = 1;
				else if (b[0] == prev_bit[0])
					running = (running == 15) ? 15 : (running + 1);
				else
					running = 1;
				prev_bit = b[3:0];
				expected_count = running;
				expected_z = (current_n != 0) && (running >= current_n);

				tick_and_check(b[0], expected_count[3:0], expected_z, j);
				if (expected_z && fired_at == -1) fired_at = j;
			end
			if (expected_fire_step == fired_at)
				$display("  >>> z fired at step %0d (expected %0d) — OK", fired_at, expected_fire_step);
			else begin
				$display("  >>> z fired at step %0d (expected %0d) — FAIL", fired_at, expected_fire_step);
				errors = errors + 1;
			end
		end
	endtask

	initial begin
		$display("=== Lab 5 Part 3 streak detector — examples from spec ===");

		@(negedge clk); @(negedge clk);
		reset = 1'b0;

		// N = 5 for all four spec examples
		save_n(4'd5);

		// 11111  -> success at step 4 (zero-indexed)
		// (5 consecutive 1s; count reaches 5 on the 5th tick)
		// Reset between sequences via FSM reset.
		feed_sequence("ex1: 11111", "11111", 5, 4'd5, 4);

		// reset for next (also re-save N since reset clears save_register)
		reset = 1'b1; @(posedge clk); #1; reset = 1'b0;
		save_n(4'd5);
		feed_sequence("ex2: 00000", "00000", 5, 4'd5, 4);

		reset = 1'b1; @(posedge clk); #1; reset = 1'b0;
		save_n(4'd5);
		feed_sequence("ex3: 00111100011111", "00111100011111", 14, 4'd5, 13);

		reset = 1'b1; @(posedge clk); #1; reset = 1'b0;
		save_n(4'd5);
		feed_sequence("ex4: 11000011100000", "11000011100000", 14, 4'd5, 13);

		reset = 1'b1; @(posedge clk); #1; reset = 1'b0;
		save_n(4'd5);
		feed_sequence("ex5: 1010101010", "1010101010", 10, 4'd5, -1);

		// Pause check
		reset = 1'b1; @(posedge clk); #1; reset = 1'b0;
		save_n(4'd3);
		tick_and_check(1'b1, 4'd1, 1'b0, 100);
		tick_and_check(1'b1, 4'd2, 1'b0, 101);
		tick_and_check(1'b1, 4'd3, 1'b1, 102);  // fires at count=3
		$display("--- pausing ---");
		pause = 1'b1;
		tick_and_check(1'b0, 4'd3, 1'b1, 103);  // unchanged
		tick_and_check(1'b0, 4'd3, 1'b1, 104);
		$display("--- resuming ---");
		pause = 1'b0;
		tick_and_check(1'b0, 4'd1, 1'b0, 105);  // resumes; w=0 differs -> reset to 1

		if (errors == 0) $display("\n=== PASS ===");
		else             $display("\n=== FAIL: %0d mismatches ===", errors);
		$finish;
	end
endmodule
