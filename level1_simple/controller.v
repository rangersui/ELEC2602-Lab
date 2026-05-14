// Controller (FSM) — sequences the multi-cycle datapath.
//
// Inputs:
//   instruction[15:0] - the current instruction word, held stable by the
//                       testbench for the duration of this instruction.
//                       Format:
//                         LDI:        [op 4][Rd 3][imm 9]
//                         MOV/ADD/SUB:[op 4][Rd 3][Rs 3][unused 6]
//
// Step counter advances each clock cycle. When `done` asserts, the next
// edge resets step to 0 so the testbench can present the next instruction.
//
// Cycle counts:
//   LDI Rd, K9  :  1 cycle
//      T0: imm_tri=1, reg_en[Rd]=1   (Rd <- sign_ext(K9))
//
//   MOV Rd, Rs  :  1 cycle
//      T0: reg_tri[Rs]=1, reg_en[Rd]=1   (Rd <- Rs)
//
//   ADD/SUB Rd, Rs : 3 cycles
//      T0: reg_tri[Rd]=1, a_en=1                 (A  <- Rd)
//      T1: reg_tri[Rs]=1, alu_op=op, g_en=1,     (G  <- A op bus = Rd op Rs)
//                          status_en=1
//      T2: g_tri=1, reg_en[Rd]=1                  (Rd <- G)
module controller (
	input         clk,
	input         reset,
	input  [15:0] instruction,

	// register file controls
	output reg [7:0] reg_en,
	output reg [7:0] reg_tri,

	// ancillary register controls
	output reg       a_en,
	output reg       g_en,
	output reg       status_en,
	output reg       g_tri,
	output reg       imm_tri,

	// ALU op
	output reg       alu_op,

	// progress signal — high during the last cycle of the current instruction
	output reg       done
);
	// Opcode aliases
	localparam OP_LDI = 4'b0001;
	localparam OP_MOV = 4'b0010;
	localparam OP_ADD = 4'b0011;
	localparam OP_SUB = 4'b0100;

	wire [3:0] opcode  = instruction[15:12];
	wire [2:0] rd_addr = instruction[11:9];
	wire [2:0] rs_addr = instruction[8:6];

	reg [1:0] step;

	// Step advance: reset to 0 on done, otherwise increment.
	always @(posedge clk) begin
		if (reset)
			step <= 2'd0;
		else if (done)
			step <= 2'd0;
		else
			step <= step + 2'd1;
	end

	// Combinational output decode based on (opcode, step).
	always @(*) begin
		// defaults
		reg_en    = 8'b0;
		reg_tri   = 8'b0;
		a_en      = 1'b0;
		g_en      = 1'b0;
		status_en = 1'b0;
		g_tri     = 1'b0;
		imm_tri   = 1'b0;
		alu_op    = 1'b0;
		done      = 1'b0;

		case (opcode)
			OP_LDI: begin
				if (step == 2'd0) begin
					imm_tri        = 1'b1;
					reg_en[rd_addr]= 1'b1;
					done           = 1'b1;
				end
			end

			OP_MOV: begin
				if (step == 2'd0) begin
					reg_tri[rs_addr]= 1'b1;
					reg_en[rd_addr] = 1'b1;
					done            = 1'b1;
				end
			end

			OP_ADD: begin
				case (step)
					2'd0: begin
						reg_tri[rd_addr] = 1'b1;
						a_en             = 1'b1;
					end
					2'd1: begin
						reg_tri[rs_addr] = 1'b1;
						alu_op           = 1'b0;  // add
						g_en             = 1'b1;
						status_en        = 1'b1;
					end
					2'd2: begin
						g_tri            = 1'b1;
						reg_en[rd_addr]  = 1'b1;
						done             = 1'b1;
					end
					default: ;
				endcase
			end

			OP_SUB: begin
				case (step)
					2'd0: begin
						reg_tri[rd_addr] = 1'b1;
						a_en             = 1'b1;
					end
					2'd1: begin
						reg_tri[rs_addr] = 1'b1;
						alu_op           = 1'b1;  // sub
						g_en             = 1'b1;
						status_en        = 1'b1;
					end
					2'd2: begin
						g_tri            = 1'b1;
						reg_en[rd_addr]  = 1'b1;
						done             = 1'b1;
					end
					default: ;
				endcase
			end

			default: begin
				// unknown opcode -> NOP, immediately done
				done = 1'b1;
			end
		endcase
	end
endmodule
