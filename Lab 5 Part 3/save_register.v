// User-input register — holds the saved threshold N (4 bits).
//
// Loaded from n_in on every clock edge where save=1. Reset clears N to 0
// (n=0 -> z forced low, so the circuit is idle until the user explicitly
// saves a threshold).
//
// On the FPGA: clk = 50 MHz, save = ~KEY[3] (active-low button inverted),
// n_in = SW[9:6]. Holding the button just keeps re-loading the same value.
module save_register(clk, reset, save, n_in, n_out);
	input            clk;
	input            reset;
	input            save;
	input      [3:0] n_in;
	output reg [3:0] n_out;

	always @(posedge clk) begin
		if (reset)
			n_out <= 4'd0;
		else if (save)
			n_out <= n_in;
	end
endmodule
