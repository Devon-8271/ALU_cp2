module and32(
	input [31:0] a,
	input [31:0] b,
	output [31:0] y
);
	genvar i;
	generate 
	for (i = 0; i < 32; i = i + 1) begin: AND_BITS
		and and_i (y[i], a[i], b[i]);
	end
	endgenerate
endmodule
