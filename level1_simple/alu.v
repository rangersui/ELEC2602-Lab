// 16-bit ALU. Inputs: A (from A register) and B (from bus).
//
// alu_op:
//   0 -> result = A + B   (ADD)
//   1 -> result = A - B   (SUB)
//
// Flags (computed combinationally on the result):
//   zero     = (result == 0)
//   negative = result[15]      (top bit, signed interpretation)
//
// More ops will be added in Level 2 (AND/OR/XOR/etc).
module alu (
	input         alu_op,
	input  [15:0] a,
	input  [15:0] b,
	output [15:0] result,
	output        zero,
	output        negative
);
	assign result   = alu_op ? (a - b) : (a + b);
	assign zero     = (result == 16'd0);
	assign negative = result[15];
endmodule
