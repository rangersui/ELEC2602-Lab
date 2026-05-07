// Pattern register — stores the 4-bit user-programmable pattern.
//
// Loads pattern_in into pattern_out on every clock edge where save=1.
// Reset clears the pattern to 0. While pattern=0 (after reset, before save),
// z would only fire if the input stream produced four consecutive 0s.
//
// On the FPGA: clk = 50 MHz, save = ~KEY[3] (active-low button inverted),
// pattern_in = SW[9:6]. Holding the button just keeps re-loading the same
// value each cycle.
//
// (Module kept named "n_register" so the .qsf doesn't need re-importing —
// the role has changed from "threshold N" to "pattern P", but the wiring is
// identical: a 4-bit register with reset and save-enable.)
module n_register(clk, reset, save, n_in, n_out);
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
