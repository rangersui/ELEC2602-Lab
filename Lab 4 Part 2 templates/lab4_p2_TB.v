`timescale 1ns / 1ps
 
module lab3_p2_TB;
 
 
	reg [3:0] count;
	reg [3:0] input_binary;
	wire [6:0] output_7seg1, output_7seg2;
	
	// ------------------ Instantiate module ------------------
	// ------------------ They should have same inputs ------------------
	lab4_p1 instantiate_lab4_p1(.v(), .d1(), .d2());
	lab4_p2 instantiate_lab4_p2(.v(), .d1(), .d2());
 	
	initial begin 
		count = 4'b0000;
	end
	
	always begin
		#50
		count=count+4'b0001;
	end

	integer errors = 0;	
	always @(count) begin
		case (count)
			4'b0000 : begin input_binary = 4'b0000; end
			4'b0001 : begin input_binary = 4'b0101; end
			4'b0010 : begin input_binary = 4'b1010; end
			default : begin input_binary = 4'b0011; end
		endcase
		if ( !== d_dut) begin
			$display("❌ MISMATCH: U=%b V=%b W=%b X=%b S=%b | REF=%b DUT=%b",
					  U, V, W, X, S, d_ref, d_dut);
			errors = errors + 1;
		end
		if (count == 4'b1111) begin
			if (errors == 0)
				$display("✅ ALL TESTS PASSED");
			else
				$display("❌ TEST FAILED with %0d errors", errors);
		end

	end

endmodule