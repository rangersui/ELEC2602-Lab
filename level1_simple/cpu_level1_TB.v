`timescale 1ns/1ps

// Testbench for cpu_level1.
//
// Drives the `instruction` port one cycle at a time. Each instruction is
// held stable for the right number of cycles based on its cycle count
// (LDI/MOV = 1, ADD/SUB = 3), then advances to the next.
//
// At the end, checks register contents against expected values.
module cpu_level1_TB;
	reg         clk = 1'b0;
	reg         reset = 1'b1;
	reg  [15:0] instruction = 16'b0;
	wire [15:0] bus;
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	wire [15:0] a_value, g_value;
	wire        status_zero, status_negative, done;

	cpu_level1 dut (
		.clk            (clk),
		.reset          (reset),
		.instruction    (instruction),
		.bus            (bus),
		.r0(r0), .r1(r1), .r2(r2), .r3(r3),
		.r4(r4), .r5(r5), .r6(r6), .r7(r7),
		.a_value        (a_value),
		.g_value        (g_value),
		.status_zero    (status_zero),
		.status_negative(status_negative),
		.done           (done)
	);

	always #5 clk = ~clk;  // 100 MHz test clock

	integer errors = 0;

	// ---- Instruction encoders ----
	function [15:0] enc_ldi;
		input [2:0]        rd;
		input signed [8:0] imm;
		begin
			enc_ldi = {4'b0001, rd, imm};
		end
	endfunction

	function [15:0] enc_mov;
		input [2:0] rd;
		input [2:0] rs;
		begin
			enc_mov = {4'b0010, rd, rs, 6'b0};
		end
	endfunction

	function [15:0] enc_add;
		input [2:0] rd;
		input [2:0] rs;
		begin
			enc_add = {4'b0011, rd, rs, 6'b0};
		end
	endfunction

	function [15:0] enc_sub;
		input [2:0] rd;
		input [2:0] rs;
		begin
			enc_sub = {4'b0100, rd, rs, 6'b0};
		end
	endfunction

	// ---- Drive an instruction for the right number of cycles ----
	task exec;
		input [15:0] instr;
		input integer cycles;
		begin
			instruction = instr;
			repeat (cycles) @(posedge clk);
			#1;  // let NBAs settle before next instruction is driven / checked
		end
	endtask

	// Debug: log every cycle so we can see what bus / step / done look like
	always @(posedge clk) begin
		$display("t=%0t  instr=%h  step=%0d  done=%b  bus=%h  reg_en=%b  reg_tri=%b",
		         $time, instruction, dut.ctrl.step, done, bus,
		         dut.ctrl.reg_en, dut.ctrl.reg_tri);
	end

	task check;
		input [255:0] label;
		input [15:0]  got;
		input [15:0]  expected;
		begin
			if (got === expected)
				$display("  OK  %s : got %0d (0x%h)", label, $signed(got), got);
			else begin
				$display("  FAIL %s : got %0d (0x%h), expected %0d (0x%h)",
				         label, $signed(got), got, $signed(expected), expected);
				errors = errors + 1;
			end
		end
	endtask

	initial begin
		$display("=== Level-1 CPU testbench ===");

		// Hold reset two negedges, then release on a negedge so the first
		// posedge clk after release sees reset=0.
		@(negedge clk); @(negedge clk);
		reset = 1'b0;

		// ----- Test 1: LDI loads sign-extended immediate -----
		$display("\n[T1] LDI R0, 100 ; LDI R1, -50 ; LDI R2, 0");
		exec(enc_ldi(3'd0, 9'sd100), 1);
		exec(enc_ldi(3'd1, -9'sd50), 1);
		exec(enc_ldi(3'd2, 9'sd0  ), 1);
		check("R0 = 100",  r0, 16'sd100);
		check("R1 = -50",  r1, -16'sd50);
		check("R2 = 0",    r2, 16'sd0);

		// ----- Test 2: MOV copies a register -----
		$display("\n[T2] MOV R3, R0 ; MOV R4, R1");
		exec(enc_mov(3'd3, 3'd0), 1);
		exec(enc_mov(3'd4, 3'd1), 1);
		check("R3 = R0 = 100", r3, 16'sd100);
		check("R4 = R1 = -50", r4, -16'sd50);

		// ----- Test 3: ADD -----
		$display("\n[T3] LDI R5, 7 ; LDI R6, 12 ; ADD R5, R6  -> R5=19");
		exec(enc_ldi(3'd5, 9'sd7),   1);
		exec(enc_ldi(3'd6, 9'sd12),  1);
		exec(enc_add(3'd5, 3'd6),    3);
		check("R5 = 7 + 12 = 19", r5, 16'sd19);
		check("R6 unchanged = 12", r6, 16'sd12);

		// ----- Test 4: SUB -----
		$display("\n[T4] LDI R7, 100 ; SUB R7, R6 -> R7 = 100 - 12 = 88");
		exec(enc_ldi(3'd7, 9'sd100), 1);
		exec(enc_sub(3'd7, 3'd6),    3);
		check("R7 = 100 - 12 = 88", r7, 16'sd88);

		// ----- Test 5: SUB producing zero -> Z flag should be set -----
		$display("\n[T5] LDI R0, 5 ; LDI R1, 5 ; SUB R0, R1 -> R0=0, Z=1");
		exec(enc_ldi(3'd0, 9'sd5), 1);
		exec(enc_ldi(3'd1, 9'sd5), 1);
		exec(enc_sub(3'd0, 3'd1), 3);
		check("R0 = 0",       r0, 16'sd0);
		if (status_zero === 1'b1)
			$display("  OK  Z flag set after zero result");
		else begin
			$display("  FAIL Z flag = %b, expected 1", status_zero);
			errors = errors + 1;
		end

		// ----- Test 6: SUB producing negative -> N flag should be set -----
		$display("\n[T6] LDI R0, 3 ; LDI R1, 10 ; SUB R0, R1 -> R0=-7, N=1");
		exec(enc_ldi(3'd0, 9'sd3),  1);
		exec(enc_ldi(3'd1, 9'sd10), 1);
		exec(enc_sub(3'd0, 3'd1),   3);
		check("R0 = -7",      r0, -16'sd7);
		if (status_negative === 1'b1)
			$display("  OK  N flag set after negative result");
		else begin
			$display("  FAIL N flag = %b, expected 1", status_negative);
			errors = errors + 1;
		end

		// ----- Test 7: chained arithmetic -----
		$display("\n[T7] R3 = 10; R4 = 3; R3 = R3 + R4 = 13; R3 = R3 - R4 = 10");
		exec(enc_ldi(3'd3, 9'sd10), 1);
		exec(enc_ldi(3'd4, 9'sd3),  1);
		exec(enc_add(3'd3, 3'd4),   3);
		check("R3 = 13", r3, 16'sd13);
		exec(enc_sub(3'd3, 3'd4),   3);
		check("R3 = 10", r3, 16'sd10);

		// Summary
		$display("");
		if (errors == 0) $display("=== PASS: all checks matched ===");
		else             $display("=== FAIL: %0d mismatches ===", errors);
		$finish;
	end
endmodule
