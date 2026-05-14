// Generic parameterized register with synchronous reset and enable.
//
// On posedge clk:
//   reset=1   -> q <- 0
//   enable=1  -> q <- d
//   else        q holds
//
// Used for R0..R7, A, G, and Status.
module register #(parameter WIDTH = 16) (
	input                  clk,
	input                  reset,
	input                  enable,
	input  [WIDTH-1:0]     d,
	output reg [WIDTH-1:0] q
);
	always @(posedge clk) begin
		if (reset)
			q <= {WIDTH{1'b0}};
		else if (enable)
			q <= d;
	end
endmodule
