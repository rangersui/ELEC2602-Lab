// Top-level Level-1 CPU.
//
// Wires the shared 16-bit bus to:
//   - Register file (8x R0..R7) — drivers via reg_tri, loaders via reg_en
//   - A register (loader only)
//   - ALU (combinational; reads A and bus)
//   - G register (loaded with ALU result; drives bus via g_tri)
//   - Status register (loads Z/N from ALU when status_en)
//   - Immediate extender — drives sign_ext(instruction[8:0]) onto bus when imm_tri
//
// The testbench feeds `instruction[15:0]` and the controller decodes it
// directly (no IR in Level 1 — that comes in Level 2).
//
// All bus drivers use tri-state semantics (16'bz when not driving). The
// controller is responsible for ensuring at most one driver is active per
// cycle.
module cpu_level1 (
	input         clk,
	input         reset,
	input  [15:0] instruction,

	// debug / inspection ports
	output [15:0] bus,
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7,
	output [15:0] a_value,
	output [15:0] g_value,
	output        status_zero,
	output        status_negative,
	output        done
);
	// Bus is a wire with multiple tri-state drivers
	wire [15:0] bus_w;

	// --- Register file ---
	wire [7:0]  reg_en;
	wire [7:0]  reg_tri;
	wire [15:0] regfile_bus_out;

	register_file rf (
		.clk     (clk),
		.reset   (reset),
		.bus_in  (bus_w),
		.reg_en  (reg_en),
		.reg_tri (reg_tri),
		.bus_out (regfile_bus_out),
		.r0(r0), .r1(r1), .r2(r2), .r3(r3),
		.r4(r4), .r5(r5), .r6(r6), .r7(r7)
	);

	// --- A register (operand for ALU) ---
	wire        a_en;
	wire [15:0] a_q;
	register #(.WIDTH(16)) A_reg (
		.clk(clk), .reset(reset), .enable(a_en), .d(bus_w), .q(a_q)
	);

	// --- ALU ---
	wire        alu_op;
	wire [15:0] alu_result;
	wire        alu_z, alu_n;
	alu alu_inst (
		.alu_op  (alu_op),
		.a       (a_q),
		.b       (bus_w),
		.result  (alu_result),
		.zero    (alu_z),
		.negative(alu_n)
	);

	// --- G register (latches ALU result) ---
	wire        g_en;
	wire [15:0] g_q;
	register #(.WIDTH(16)) G_reg (
		.clk(clk), .reset(reset), .enable(g_en), .d(alu_result), .q(g_q)
	);

	// --- Status register (latches Z, N from ALU) ---
	wire        status_en;
	wire [1:0]  status_q;
	register #(.WIDTH(2)) Status_reg (
		.clk(clk), .reset(reset), .enable(status_en), .d({alu_n, alu_z}), .q(status_q)
	);

	// --- Immediate extender ---
	// Sign-extend instruction[8:0] to 16 bits, drive onto bus when imm_tri.
	wire        imm_tri;
	wire [15:0] imm_extended = {{7{instruction[8]}}, instruction[8:0]};

	// --- Bus mux ---
	// Single priority mux instead of three competing tri-state drivers — much
	// safer across simulators (some don't resolve multiple 'bz drivers
	// reliably) and translates directly to a synthesizable structure later.
	// Controller guarantees only one source is active per cycle.
	wire        g_tri;

	assign bus_w = g_tri      ? g_q :
	               imm_tri    ? imm_extended :
	               (|reg_tri) ? regfile_bus_out :
	               16'h0000;

	// --- Controller ---
	controller ctrl (
		.clk         (clk),
		.reset       (reset),
		.instruction (instruction),
		.reg_en      (reg_en),
		.reg_tri     (reg_tri),
		.a_en        (a_en),
		.g_en        (g_en),
		.status_en   (status_en),
		.g_tri       (g_tri),
		.imm_tri     (imm_tri),
		.alu_op      (alu_op),
		.done        (done)
	);

	// Debug / inspection outputs
	assign bus             = bus_w;
	assign a_value         = a_q;
	assign g_value         = g_q;
	assign status_zero     = status_q[0];
	assign status_negative = status_q[1];
endmodule
