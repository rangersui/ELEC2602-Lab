// Connector for the pattern-matching FSM.
//
//          +-----------------+
//    w --->| fsm_next_state  |---next_state-->+
//          +-----------------+                |
//                                             v
//                                    +-----------------+
//   reset, enable, clk -------------> | fsm_state_reg   |---current_state-->
//                                    +-----------------+                  |
//                                             ^                           |
//                                             +--------loop back----------+
//                                                                         |
//                                             +----+                      |
//                                             |    v                      |
//                                    +-----------------+                  |
//   pattern --------------------------> | fsm_output    |<-----------------+
//                                    +-----------------+
//                                             |
//                                             v
//                                             z
module fsm(clk, reset, enable, w, pattern, z, state);
	input        clk;
	input        reset;
	input        enable;
	input        w;
	input  [3:0] pattern;
	output       z;
	output [3:0] state;

	wire [3:0] next_state;
	wire [3:0] current_state;

	fsm_next_state ns_logic (
		.current_state (current_state),
		.w             (w),
		.next_state    (next_state)
	);

	fsm_state_reg state_register (
		.clk           (clk),
		.reset         (reset),
		.enable        (enable),
		.next_state    (next_state),
		.current_state (current_state)
	);

	fsm_output out_logic (
		.current_state (current_state),
		.pattern       (pattern),
		.z             (z)
	);

	assign state = current_state;
endmodule
