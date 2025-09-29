module balanced_or32 (
  input  [31:0] in,
  output        out
);
  wire [15:0] l1;
  wire [7:0]  l2;
  wire [3:0]  l3;
  wire [1:0]  l4;

  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : L1
      or o1 (l1[i], in[2*i], in[2*i+1]);
    end
    for (i = 0; i < 8; i = i + 1) begin : L2
      or o2 (l2[i], l1[2*i], l1[2*i+1]);
    end
    for (i = 0; i < 4; i = i + 1) begin : L3
      or o3 (l3[i], l2[2*i], l2[2*i+1]);
    end
    for (i = 0; i < 2; i = i + 1) begin : L4
      or o4 (l4[i], l3[2*i], l3[2*i+1]);
    end
  endgenerate

  or o_final (out, l4[0], l4[1]);
endmodule
