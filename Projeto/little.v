module lilCount(clock,little);
	input clock;
	output reg little;
	reg [16:0] count;
	initial count <= 0;
	always @(posedge clock) begin
		count<=count+1;
		if(count>=50000)begin
			count <=0;
			little <= ~little;
		end
	end
	
endmodule