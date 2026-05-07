// State register for the streak-counting FSM.
// Stores {count, last_w}. On every enabled tick (1 Hz on the board) loads
// the next-state values; on reset, snaps back to count=0.
module fsm_state_reg(clk, reset, enable, next_count, next_last_w, current_count, last_w);
	input            clk;
	input            reset;
	input            enable;
	input      [3:0] next_count;
	input            next_last_w;
	output reg [3:0] current_count;
	output reg       last_w;

	always @(posedge clk) begin
		if (reset) begin
			current_count <= 4'd0;
			last_w        <= 1'b0;
		end
		else if (enable) begin
			current_count <= next_count;
			last_w        <= next_last_w;
		end
	end
endmodule
