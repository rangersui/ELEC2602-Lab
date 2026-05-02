// Output logic (pure combinational, Moore-style — depends only on state).
// z = 1 exactly when we're in E (four consecutive 0s) or I (four consecutive 1s).
module fsm_output(current_state, z);
	input  [3:0] current_state;
	output       z;

	assign z = (current_state == 4'd4) || (current_state == 4'd8);
endmodule
