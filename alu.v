module alu (
  input  [31:0] data_operandA,
  input  [31:0] data_operandB,
  input  [4:0]  ctrl_ALUopcode,
  input  [4:0]  ctrl_shiftamt,
  output [31:0] data_result,
  output        isNotEqual,
  output        isLessThan,
  output        overflow
);

  wire op_add;
  wire op_sub;
  wire op_and;
  wire op_or;
  wire op_sll;
  wire op_sra;
  opcode_decoder_5 u_dec (
    .ctrl(ctrl_ALUopcode),
    .op_add(op_add), .op_sub(op_sub),
    .op_and(op_and), .op_or(op_or),
    .op_sll(op_sll), .op_sra(op_sra)
  );

  wire [31:0] add_r;
  wire [31:0] sub_r;
  add32 u_add (
    .A(data_operandA),
    .B(data_operandB),
    .cin(1'b0),
    .S(add_r),
    .cout()
  );
  sub32 u_sub (
    .A(data_operandA),
    .B(data_operandB),
    .S(sub_r),
    .cout()
  );

  wire a31;
  wire b31;
  assign a31 = data_operandA[31];
  assign b31 = data_operandB[31];

  wire s_add31;
  wire ns_add31;
  assign s_add31 = add_r[31];
  not inv_ns_add (ns_add31, s_add31);

  wire na31;
  wire nb31;
  not inv_na (na31, a31);
  not inv_nb (nb31, b31);

  wire both_neg;
  and and_both_neg (both_neg, a31, b31);
  wire both_neg_ns;
  and and_both_neg_ns (both_neg_ns, both_neg, ns_add31);

  wire both_pos;
  and and_both_pos (both_pos, na31, nb31);
  wire both_pos_s;
  and and_both_pos_s (both_pos_s, both_pos, s_add31);

  wire ov_add;
  or or_ov_add (ov_add, both_neg_ns, both_pos_s);

  wire s_sub31;
  wire ns_sub31;
  assign s_sub31 = sub_r[31];
  not inv_ns_sub (ns_sub31, s_sub31);

  wire a_neg_b_pos;
  and and_a_neg_b_pos (a_neg_b_pos, a31, nb31);
  wire a_neg_b_pos_ns;
  and and_a_neg_b_pos_ns (a_neg_b_pos_ns, a_neg_b_pos, ns_sub31);

  wire a_pos_b_neg;
  and and_a_pos_b_neg (a_pos_b_neg, na31, b31);
  wire a_pos_b_neg_s;
  and and_a_pos_b_neg_s (a_pos_b_neg_s, a_pos_b_neg, s_sub31);

  wire ov_sub;
  or or_ov_sub (ov_sub, a_neg_b_pos_ns, a_pos_b_neg_s);

  wire ov_add_masked;
  wire ov_sub_masked;
  and and_ov_add_mask (ov_add_masked, ov_add, op_add);
  and and_ov_sub_mask (ov_sub_masked, ov_sub, op_sub);
  or  or_ov_all      (overflow, ov_add_masked, ov_sub_masked);

  balanced_or32 u_ne ( .in(sub_r), .out(isNotEqual) );

  wire sub_ov_for_lt;
  and and_sub_ov_mask (sub_ov_for_lt, ov_sub, op_sub);
  xor lt_xor (isLessThan, sub_r[31], ov_sub);

  wire [31:0] and_r;
  wire [31:0] or_r;
  and32 u_and ( .a(data_operandA), .b(data_operandB), .y(and_r) );
  or32  u_or  ( .a(data_operandA), .b(data_operandB), .y(or_r) );

  wire [31:0] sh_r;
  wire op_sh;
  or or_op_sh (op_sh, op_sll, op_sra);
  barrel_shifter_32 u_sh (
    .din(data_operandA),
    .shamt(ctrl_shiftamt),
    .mode(op_sra),
    .dout(sh_r)
  );

  wire [31:0] masked_add;
  wire [31:0] masked_sub;
  wire [31:0] masked_and;
  wire [31:0] masked_or;
  wire [31:0] masked_sh;
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : MASK
      and m_add  (masked_add[i], add_r[i], op_add);
      and m_sub  (masked_sub[i], sub_r[i], op_sub);
      and m_and  (masked_and[i], and_r[i], op_and);
      and m_or   (masked_or[i],  or_r[i],  op_or);
      and m_sh   (masked_sh[i],  sh_r[i],  op_sh);

      wire or1;
      wire or2;
      wire or3;
      or o1 (or1, masked_add[i], masked_sub[i]);
      or o2 (or2, masked_and[i], masked_or[i]);
      or o3 (or3, or1, or2);
      or o4 (data_result[i], or3, masked_sh[i]);
    end
  endgenerate

endmodule
