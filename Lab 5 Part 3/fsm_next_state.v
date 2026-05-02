// Next-state logic for the pattern-matching FSM.
//
// State = the last 4 bits seen (a 4-bit shift register).
// On each enabled tick, shift in w as the new LSB and discard the MSB.
//
// next_state = {current_state[2:0], w}
//
// This naturally implements a sliding window over the input stream, so the
// FSM "sees" the most recent 4 bits at all times.
module fsm_next_state(current_state, w, next_state);
	input  [3:0] current_state;
	input        w;
	output [3:0] next_state;

	assign next_state = {current_state[2:0], w};
endmodule
