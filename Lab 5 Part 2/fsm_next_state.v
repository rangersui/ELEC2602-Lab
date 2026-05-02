// Next-state logic (pure combinational).
// State encoding:
//   A=0 (reset)
//   B=1 C=2 D=3 E=4  (zero chain, E -> z=1)
//   F=5 G=6 H=7 I=8  (one  chain, I -> z=1)
//
// Transitions (per state diagram):
//   A: 0->B 1->F
//   B: 0->C 1->F
//   C: 0->D 1->F
//   D: 0->E 1->F
//   E: 0->E 1->F   (stay in E while w=0 so overlap works)
//   F: 0->B 1->G
//   G: 0->B 1->H
//   H: 0->B 1->I
//   I: 0->B 1->I   (stay in I while w=1 so overlap works)
module fsm_next_state(current_state, w, next_state);
	input  [3:0] current_state;
	input        w;
	output reg [3:0] next_state;

	always @(*) begin
		case (current_state)
			4'd0: next_state = w ? 4'd5 : 4'd1;  // A
			4'd1: next_state = w ? 4'd5 : 4'd2;  // B
			4'd2: next_state = w ? 4'd5 : 4'd3;  // C
			4'd3: next_state = w ? 4'd5 : 4'd4;  // D
			4'd4: next_state = w ? 4'd5 : 4'd4;  // E (stay on 0)
			4'd5: next_state = w ? 4'd6 : 4'd1;  // F
			4'd6: next_state = w ? 4'd7 : 4'd1;  // G
			4'd7: next_state = w ? 4'd8 : 4'd1;  // H
			4'd8: next_state = w ? 4'd8 : 4'd1;  // I (stay on 1)
			default: next_state = 4'd0;
		endcase
	end
endmodule
