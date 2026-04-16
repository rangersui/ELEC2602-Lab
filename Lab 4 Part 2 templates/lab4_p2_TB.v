`timescale 1ns / 1ps

module lab4_p2_TB;
    reg  [3:0] v;
    wire [6:0] d1, d0;
    integer i, errors;
    reg [6:0] exp_d1, exp_d0;

    lab4_p2 dut (.v(v), .d1(d1), .d2(d0));

    function [6:0] seg;
        input [3:0] digit;
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    endfunction

    initial begin
        errors = 0;
        $display(" v  | d1 (tens) exp       | d0 (units) exp      | result");
        $display("----+---------------------+---------------------+-------");

        for (i = 0; i < 16; i = i + 1) begin
            v = i[3:0];
            #10;

            if (i < 10) begin
                exp_d1 = seg(4'd0);
                exp_d0 = seg(i[3:0]);
            end else begin
                exp_d1 = seg(4'd1);
                exp_d0 = seg(i[3:0] - 4'd10);
            end

            if (d1 === exp_d1 && d0 === exp_d0)
                $display(" %2d | %b %b | %b %b | OK",
                         v, d1, exp_d1, d0, exp_d0);
            else begin
                $display(" %2d | %b %b | %b %b | FAIL",
                         v, d1, exp_d1, d0, exp_d0);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("PASS: all 16 cases matched");
        else             $display("FAIL: %0d mismatches", errors);
        $finish;
    end
endmodule