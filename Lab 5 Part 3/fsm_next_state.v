// Next-state logic for the streak-counting FSM.
//
// State = {last_w (1 bit), count (4 bits)}:
//   count  = how long the current streak is (0..15, saturating)
//   last_w = the most recent bit we've seen — internal plumbing used to
//            decide whether the new w extends the streak or breaks it.
//
// Update rules:
//   - count==0  (just-reset, no bits seen yet): start the first streak.
//   - w == last_w : extend streak (saturate at 15 to avoid wrap).
//   - w != last_w : streak broken — restart from 1 with the new bit.
module fsm_next_state(current_count, last_w, w, next_count, next_last_w);
	input  [3:0] current_count;
	input        last_w;
	input        w;
	output reg [3:0] next_count;
	output reg       next_last_w;

	always @(*) begin
		if (current_count == 4'd0) begin
			next_count  = 4'd1;
			next_last_w = w;
		end
		else if (w == last_w) begin
			next_count  = (current_count == 4'd15) ? 4'd15 : (current_count + 4'd1);
			next_last_w = last_w;
		end
		else begin
			next_count  = 4'd1;
			next_last_w = w;
		end
	end
endmodule
