module circuitB (
    input z,
    output reg [6:0] d1
);
    always @(*) begin
        if (z == 1'b0)
            d1 = 7'b1000000;  // "0": g off, all others on (inverted = 0)
        else
            d1 = 7'b1111001;  // "1": only b,c on
    end
endmodule