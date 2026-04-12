module comparator (v, z);
	input [3:0] v; 	
	output reg z; 
	
	always @(v)
	begin
	  if (v == 4'b????)
		z = ???;
	  else
		z = ??;
	end
endmodule;
