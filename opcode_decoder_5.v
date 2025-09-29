module opcode_decoder_5 (
  input  [4:0] ctrl,
  output op_add, op_sub, op_and, op_or, op_sll, op_sra
);
  wire n0, n1, n2, n3, n4;
  not inv0 (n0, ctrl[0]);
  not inv1 (n1, ctrl[1]);
  not inv2 (n2, ctrl[2]);
  not inv3 (n3, ctrl[3]);
  not inv4 (n4, ctrl[4]);

  // ADD = 00000
  wire a1,a2,a3;
  and a_12 (a1, n4, n3);
  and a_34 (a2, n2, n1);
  and a_56 (a3, a1, a2);
  and a_7  (op_add, a3, n0);

  // SUB = 00001
  wire s1,s2,s3;
  and s_12 (s1, n4, n3);
  and s_34 (s2, n2, n1);
  and s_56 (s3, s1, s2);
  and s_7  (op_sub, s3, ctrl[0]);

  // AND = 00010
  wire an1, an2, an3;
  and an_12 (an1, n4, n3);
  and an_34 (an2, n2, ctrl[1]);
  and an_56 (an3, an1, an2);
  and an_7  (op_and, an3, n0);

  // OR = 00011
  wire or1, or2, or3;
  and or_12 (or1, n4, n3);
  and or_34 (or2, n2, ctrl[1]);
  and or_56 (or3, or1, or2);
  and or_7  (op_or, or3, ctrl[0]);

  // SLL = 00100
  wire sl1, sl2, sl3;
  and sl_12 (sl1, n4, n3);
  and sl_34 (sl2, ctrl[2], n1);
  and sl_56 (sl3, sl1, sl2);
  and sl_7  (op_sll, sl3, n0);

  // SRA = 00101
  wire sr1, sr2, sr3;
  and sr_12 (sr1, n4, n3);
  and sr_34 (sr2, ctrl[2], n1);
  and sr_56 (sr3, sr1, sr2);
  and sr_7  (op_sra, sr3, ctrl[0]);
endmodule
