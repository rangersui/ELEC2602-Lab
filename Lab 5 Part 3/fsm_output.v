// Output logic for the pattern-matching FSM.
//
// z = 1 when the current 4-bit window equals the user-saved pattern.
// Overlap is automatic: if the pattern reappears in subsequent windows,
// z fires again.
module fsm_output(current_state, pattern, z);
	input  [3:0] current_state;
	input  [3:0] pattern;
	output       z;

	assign z = (current_state == pattern);
endmodule
