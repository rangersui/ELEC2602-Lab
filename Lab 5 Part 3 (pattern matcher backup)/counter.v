// N-bit synchronous counter built from T flip-flops and a chain of AND gates.
//
// T[0]   = enable
// T[i]   = T[i-1] & Q[i-1]   (i >= 1)
// Q[i]   = tff(clk, clear, T[i])
//
// The generate statement instantiates N copies of the repeating
// {AND gate, T flip-flop} pattern.
module counter #(parameter N = 16) (
	input              clk,
	input              clear,
	input              enable,
	output [N-1:0]     q
);
	wire [N-1:0] t;

	// First stage: T[0] comes directly from enable.
	assign t[0] = enable;

	genvar i;

	// Chain of AND gates: T[i] = T[i-1] & Q[i-1]
	generate
		for (i = 1; i < N; i = i + 1) begin : and_chain
			assign t[i] = t[i-1] & q[i-1];
		end
	endgenerate

	// N T flip-flops, all clocked by the same clk (synchronous counter).
	generate
		for (i = 0; i < N; i = i + 1) begin : ff_chain
			t_ff ff_inst(
				.clk  (clk),
				.clear(clear),
				.t    (t[i]),
				.q    (q[i])
			);
		end
	endgenerate
endmodule
