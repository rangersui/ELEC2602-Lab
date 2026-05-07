`timescale 1ns/1ps

// Testbench for lab5_p3 (pattern matcher).
// Self-synchronizes to ticks. ONE_SEC_COUNT shrunk to 3 for fast sim.
//
// Three scenarios:
//   A) Pattern = 1011, feed 1,0,1,1 -> z fires
//   B) Pattern = 0000, feed varying bits, z fires only when window=0000
//   C) Pattern = 1010 with overlap: feed 1,0,1,0,1,0 -> z fires repeatedly
module lab5_p3_TB;
	localparam CYCLES_PER_SEC = 3;

	reg         clk = 1'b0;
	reg         reset = 1'b1;
	reg         w = 1'b0;
	reg         save = 1'b0;
	reg         pause = 1'b0;
	reg  [3:0]  n_in = 4'd0;
	wire [6:0]  hex0, hex5;
	wire [9:0]  ledr;
	wire        z;
	wire [3:0]  count;
	wire [3:0]  n_out;
	integer     errors = 0;

	lab5_p3 #(.ONE_SEC_COUNT(CYCLES_PER_SEC)) dut (
		.clk    (clk),
		.reset  (reset),
		.w      (w),
		.save   (save),
		.pause  (pause),
		.n_in   (n_in),
		.hex0   (hex0),
		.hex5   (hex5),
		.ledr   (ledr),
		.z      (z),
		.count  (count),
		.n_out  (n_out)
	);

	always #5 clk = ~clk;  // 100 MHz test clock

	task tick_and_check;
		input        in_w;
		input  [3:0] exp_window;
		input        exp_z;
		input integer step_id;
		begin
			w = in_w;
			if (!dut.tick) @(posedge dut.tick);
			@(posedge clk); #1;
			if (count === exp_window && z === exp_z)
				$display(" %2d  | w=%b | window=%b (exp %b) | z=%b (exp %b) | pat=%b | OK",
				         step_id, w, count, exp_window, z, exp_z, n_out);
			else begin
				$display(" %2d  | w=%b | window=%b (exp %b) | z=%b (exp %b) | pat=%b | FAIL",
				         step_id, w, count, exp_window, z, exp_z, n_out);
				errors = errors + 1;
			end
		end
	endtask

	task save_pattern;
		input [3:0] new_pat;
		begin
			@(negedge clk);
			n_in = new_pat;
			save = 1'b1;
			@(posedge clk); #1;
			save = 1'b0;
			$display("--- saved pattern=%b ---", new_pat);
		end
	endtask

	initial begin
		$display("step | input | window         | z         | pattern | result");
		$display("-----+-------+----------------+-----------+---------+-------");

		@(negedge clk); @(negedge clk);
		reset = 1'b0;

		// Scenario A: pattern=1011, feed 1,0,1,1
		save_pattern(4'b1011);
		tick_and_check(1'b1, 4'b0001, 1'b0, 0);   // shift in 1
		tick_and_check(1'b0, 4'b0010, 1'b0, 1);   // shift in 0
		tick_and_check(1'b1, 4'b0101, 1'b0, 2);   // shift in 1
		tick_and_check(1'b1, 4'b1011, 1'b1, 3);   // shift in 1 -> match!
		tick_and_check(1'b0, 4'b0110, 1'b0, 4);   // shift in 0 -> no match

		// Scenario B: pattern=0000, feed sequence that hits 0000 mid-stream
		save_pattern(4'b0000);
		tick_and_check(1'b1, 4'b1101, 1'b0, 5);
		tick_and_check(1'b0, 4'b1010, 1'b0, 6);
		tick_and_check(1'b0, 4'b0100, 1'b0, 7);
		tick_and_check(1'b0, 4'b1000, 1'b0, 8);
		tick_and_check(1'b0, 4'b0000, 1'b1, 9);   // four 0s in a row
		tick_and_check(1'b0, 4'b0000, 1'b1, 10);  // overlap, still matches
		tick_and_check(1'b1, 4'b0001, 1'b0, 11);

		// Scenario C: pattern=1010 with overlap
		save_pattern(4'b1010);
		tick_and_check(1'b1, 4'b0011, 1'b0, 12);
		tick_and_check(1'b0, 4'b0110, 1'b0, 13);
		tick_and_check(1'b1, 4'b1101, 1'b0, 14);
		tick_and_check(1'b0, 4'b1010, 1'b1, 15);  // match!
		tick_and_check(1'b1, 4'b0101, 1'b0, 16);  // shifted, no match
		tick_and_check(1'b0, 4'b1010, 1'b1, 17);  // match again (overlap)
		tick_and_check(1'b1, 4'b0101, 1'b0, 18);

		// Scenario D: pause freezes the FSM. Window should NOT change while
		// paused, even though w changes and ticks keep firing.
		$display("--- pausing FSM ---");
		pause = 1'b1;
		tick_and_check(1'b0, 4'b0101, 1'b0, 19);  // window unchanged (was 0101)
		tick_and_check(1'b1, 4'b0101, 1'b0, 20);  // still unchanged
		tick_and_check(1'b0, 4'b0101, 1'b0, 21);  // still unchanged
		$display("--- resuming FSM ---");
		pause = 1'b0;
		tick_and_check(1'b0, 4'b1010, 1'b1, 22);  // resumes, shifts in 0 -> 1010 matches!

		if (errors == 0) $display("PASS: all 23 steps matched");
		else             $display("FAIL: %0d mismatches", errors);
		$finish;
	end
endmodule
