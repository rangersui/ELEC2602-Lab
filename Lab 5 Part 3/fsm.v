// Connector for the streak-counting FSM.
// Wires next_state -> state_reg -> output_logic. Internally the state
// register holds count + last_w (the most recent bit seen, used to detect
// when the streak breaks). Externally the FSM only exposes count and z —
// last_w is plumbing.
module fsm(clk, reset, enable, w, n, z, count);
	input        clk;
	input        reset;
	input        enable;
	input        w;
	input  [3:0] n;
	output       z;
	output [3:0] count;

	wire [3:0] next_count;
	wire       next_last_w;
	wire [3:0] current_count;
	wire       last_w;

	fsm_next_state ns_logic (
		.current_count (current_count),
		.last_w        (last_w),
		.w             (w),
		.next_count    (next_count),
		.next_last_w   (next_last_w)
	);

	fsm_state_reg state_register (
		.clk           (clk),
		.reset         (reset),
		.enable        (enable),
		.next_count    (next_count),
		.next_last_w   (next_last_w),
		.current_count (current_count),
		.last_w        (last_w)
	);

	fsm_output out_logic (
		.current_count (current_count),
		.n             (n),
		.z             (z)
	);

	assign count = current_count;
endmodule
