module comparator (
    input  [3:0] v,
    output       z
);
    assign z = (v > 4'd9);
endmodule