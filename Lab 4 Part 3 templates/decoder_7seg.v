module decoder_7seg(code, decoded_output);
    input  [3:0] code;
    output reg [6:0] decoded_output;

    // Active-LOW, bit order {g,f,e,d,c,b,a}
    always @(*) begin
        case (code)
            4'd0 : decoded_output = 7'b1000000;
            4'd1 : decoded_output = 7'b1111001;
            4'd2 : decoded_output = 7'b0100100;
            4'd3 : decoded_output = 7'b0110000;
            4'd4 : decoded_output = 7'b0011001;
            4'd5 : decoded_output = 7'b0010010;
            4'd6 : decoded_output = 7'b0000010;
            4'd7 : decoded_output = 7'b1111000;
            4'd8 : decoded_output = 7'b0000000;
            4'd9 : decoded_output = 7'b0010000;
            4'd10: decoded_output = 7'b0001000;  // A
            4'd11: decoded_output = 7'b0000011;  // b
            4'd12: decoded_output = 7'b1000110;  // C
            4'd13: decoded_output = 7'b0100001;  // d
            4'd14: decoded_output = 7'b0000110;  // E
            4'd15: decoded_output = 7'b0001110;  // F
            default: decoded_output = 7'b1111111;
        endcase
    end
endmodule