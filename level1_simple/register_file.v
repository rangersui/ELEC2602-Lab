// 8 x 16-bit register file with per-register tri-state output to a shared bus.
//
// Inputs:
//   bus_in    : the 16-bit shared bus (registers read from here when their reg_en is high)
//   reg_en[i] : if 1, R[i] latches bus_in on the next clock edge
//   reg_tri[i]: if 1, R[i] drives the bus through its tri-state buffer
//
// At most one bit of reg_tri should be high at a time (controller's job to ensure).
//
// Outputs:
//   bus_out   : tri-state output of the selected register (z when none selected)
//   r0..r7    : exposed register contents for testbench inspection
module register_file (
	input         clk,
	input         reset,
	input  [15:0] bus_in,
	input  [7:0]  reg_en,
	input  [7:0]  reg_tri,
	output [15:0] bus_out,
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7
);
	wire [15:0] q [0:7];

	register #(.WIDTH(16)) R0 (.clk(clk), .reset(reset), .enable(reg_en[0]), .d(bus_in), .q(q[0]));
	register #(.WIDTH(16)) R1 (.clk(clk), .reset(reset), .enable(reg_en[1]), .d(bus_in), .q(q[1]));
	register #(.WIDTH(16)) R2 (.clk(clk), .reset(reset), .enable(reg_en[2]), .d(bus_in), .q(q[2]));
	register #(.WIDTH(16)) R3 (.clk(clk), .reset(reset), .enable(reg_en[3]), .d(bus_in), .q(q[3]));
	register #(.WIDTH(16)) R4 (.clk(clk), .reset(reset), .enable(reg_en[4]), .d(bus_in), .q(q[4]));
	register #(.WIDTH(16)) R5 (.clk(clk), .reset(reset), .enable(reg_en[5]), .d(bus_in), .q(q[5]));
	register #(.WIDTH(16)) R6 (.clk(clk), .reset(reset), .enable(reg_en[6]), .d(bus_in), .q(q[6]));
	register #(.WIDTH(16)) R7 (.clk(clk), .reset(reset), .enable(reg_en[7]), .d(bus_in), .q(q[7]));

	// Priority-encoded mux drives the bus output. At most one reg_tri bit
	// should be set, so order doesn't matter. When no reg_tri is set, output
	// 0 (top-level mux selects something else anyway based on its own enables).
	assign bus_out = reg_tri[0] ? q[0] :
	                 reg_tri[1] ? q[1] :
	                 reg_tri[2] ? q[2] :
	                 reg_tri[3] ? q[3] :
	                 reg_tri[4] ? q[4] :
	                 reg_tri[5] ? q[5] :
	                 reg_tri[6] ? q[6] :
	                 reg_tri[7] ? q[7] :
	                 16'h0000;

	assign r0 = q[0];
	assign r1 = q[1];
	assign r2 = q[2];
	assign r3 = q[3];
	assign r4 = q[4];
	assign r5 = q[5];
	assign r6 = q[6];
	assign r7 = q[7];
endmodule
