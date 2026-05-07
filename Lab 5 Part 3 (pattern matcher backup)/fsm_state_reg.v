// State register for the pattern-matching FSM.
// Stores the 4-bit shift window. Reset clears it; on each enabled tick,
// loads the next-state value (which is a left-shift of the previous window
// with w as the new LSB).
module fsm_state_reg(clk, reset, enable, next_state, current_state);
	input            clk;
	input            reset;
	input            enable;
	input      [3:0] next_state;
	output reg [3:0] current_state;

	always @(posedge clk) begin
		if (reset)
			current_state <= 4'd0;
		else if (enable)
			current_state <= next_state;
	end
endmodule
