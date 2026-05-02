// State register.
// On posedge clk:
//   reset=1  -> state <- A (0)
//   enable=1 -> state <- next_state
//   else hold
//
// The `enable` lets us gate the FSM with a slow tick (e.g. the 1-second
// pulse from Part 1) while still clocking everything at 50 MHz.
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
