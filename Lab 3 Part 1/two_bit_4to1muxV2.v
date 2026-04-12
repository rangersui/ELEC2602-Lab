module two_bit_4to1muxV2 (s,u,v,w,x,m);
input [1:0] s;
input [1:0] u,v,w,x;
output reg [1:0] m;
reg [1:0] t1, t2;
// First stage: s[0] selects between u/v
always @(u,v,s[0]) begin
if (s[0] == 1'b0)
t1 = u;
else
t1 = v;
end

// First stage: s[0] selects between w/x
always @(w,x,s[0]) begin
if (s[0] == 1'b0)
t2 = w;
else
t2 = x;
end

// Second stage: s[1] selects between t1/t2
always @(t1,t2,s[1]) begin
if (s[1] == 1'b0)
m = t1;
else
m = t2;
end
endmodule
