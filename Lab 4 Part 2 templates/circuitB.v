module circuitB (z, d1);
    input z;
	output reg[6:0] d1; 
	
	always @(z)
	begin
	  if (z == 1'b????)
		d1 = ???;
	  else
		d1 = ??;
	end
endmodule;