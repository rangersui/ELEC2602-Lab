// T-type flip-flop with synchronous reset.
// On posedge clk:
//   clear=1 -> q <- 0
//   else if t=1 -> q <- ~q
//   else q holds
module t_ff(
	input  clk,
	input  clear,
	input  t,
	output reg q
);
	always @(posedge clk) begin
		if (clear)
			q <= 1'b0;
		else if (t)
			q <= ~q;
	end
endmodule
