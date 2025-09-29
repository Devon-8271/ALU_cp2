module mux2_1_bit (
  input  sel,
  input  a,
  input  b,
  output y
);
  wire nsel, a_and, b_and;
  not n0 (nsel, sel);
  and a0 (a_and, nsel, a);
  and a1 (b_and, sel, b);
  or  o0 (y, a_and, b_and);
endmodule
