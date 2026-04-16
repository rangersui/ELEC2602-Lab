module circuitA (
    input  [3:0] v,
    output reg [3:0] A
);
    always @(*) begin
        if (v < 4'd10)
            A = v;
        else
            A = v - 4'd10;
    end
endmodule