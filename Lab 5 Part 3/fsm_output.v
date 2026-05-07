// Output logic.
//
// z = 1 when the streak length has reached the threshold N.
// Doesn't care WHICH bit is being counted — five consecutive 0s and five
// consecutive 1s both fire z when N=5.
//
// N=0 forces z low (treat as "disabled" so the circuit is idle until the
// user saves a real threshold).
module fsm_output(current_count, n, z);
	input  [3:0] current_count;
	input  [3:0] n;
	output       z;

	assign z = (n != 4'd0) && (current_count >= n);
endmodule
