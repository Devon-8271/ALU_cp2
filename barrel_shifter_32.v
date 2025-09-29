
module barrel_shifter_32 (
  input  [31:0] din,
  input  [4:0]  shamt, 
  input         mode, 
  output [31:0] dout
);
  
  wire [31:0] stage0; 
  wire [31:0] stage1; 
  wire [31:0] stage2; 
  wire [31:0] stage3; 
  wire [31:0] stage4; 

  genvar i;

  
  wire [31:0] left1;
  wire [31:0] right1;

  generate
    for (i = 0; i < 32; i = i + 1) begin : STAGE0_PREP
      if (i == 0) begin
        assign left1[i] = 1'b0;
      end else begin
        assign left1[i] = din[i-1];
      end

      if (i == 31) begin
        assign right1[i] = din[31]; 
      end else begin
        assign right1[i] = din[i+1];
      end

      wire dir_bit0;
      mux2_1_bit dir_mux0 ( .sel(mode), .a(left1[i]), .b(right1[i]), .y(dir_bit0) );

      
      mux2_1_bit amt_mux0 ( .sel(shamt[0]), .a(din[i]), .b(dir_bit0), .y(stage0[i]) );
    end
  endgenerate


  
  wire [31:0] left2, right2;
  generate
    for (i = 0; i < 32; i = i + 1) begin : STAGE1
      if (i < 2) begin
        assign left2[i] = 1'b0;
      end else begin
        assign left2[i] = stage0[i-2];
      end

      if (i > 29) begin
        assign right2[i] = stage0[31];
      end else begin
        assign right2[i] = stage0[i+2];
      end

      wire dir_bit1;
      mux2_1_bit dir_mux1 ( .sel(mode), .a(left2[i]), .b(right2[i]), .y(dir_bit1) );
      mux2_1_bit amt_mux1 ( .sel(shamt[1]), .a(stage0[i]), .b(dir_bit1), .y(stage1[i]) );
    end
  endgenerate


  wire [31:0] left4, right4;
  generate
    for (i = 0; i < 32; i = i + 1) begin : STAGE2
      if (i < 4) begin
        assign left4[i] = 1'b0;
      end else begin
        assign left4[i] = stage1[i-4];
      end

      if (i > 27) begin
        assign right4[i] = stage1[31];
      end else begin
        assign right4[i] = stage1[i+4];
      end

      wire dir_bit2;
      mux2_1_bit dir_mux2 ( .sel(mode), .a(left4[i]), .b(right4[i]), .y(dir_bit2) );
      mux2_1_bit amt_mux2 ( .sel(shamt[2]), .a(stage1[i]), .b(dir_bit2), .y(stage2[i]) );
    end
  endgenerate


  
  wire [31:0] left8, right8;
  generate
    for (i = 0; i < 32; i = i + 1) begin : STAGE3
      if (i < 8) begin
        assign left8[i] = 1'b0;
      end else begin
        assign left8[i] = stage2[i-8];
      end

      if (i > 23) begin
        assign right8[i] = stage2[31];
      end else begin
        assign right8[i] = stage2[i+8];
      end

      wire dir_bit3;
      mux2_1_bit dir_mux3 ( .sel(mode), .a(left8[i]), .b(right8[i]), .y(dir_bit3) );
      mux2_1_bit amt_mux3 ( .sel(shamt[3]), .a(stage2[i]), .b(dir_bit3), .y(stage3[i]) );
    end
  endgenerate



  wire [31:0] left16, right16;
  generate
    for (i = 0; i < 32; i = i + 1) begin : STAGE4
      if (i < 16) begin
        assign left16[i] = 1'b0;
      end else begin
        assign left16[i] = stage3[i-16];
      end

      if (i > 15) begin
        assign right16[i] = stage3[31];
      end else begin
        assign right16[i] = stage3[i+16];
      end

      wire dir_bit4;
      mux2_1_bit dir_mux4 ( .sel(mode), .a(left16[i]), .b(right16[i]), .y(dir_bit4) );
      mux2_1_bit amt_mux4 ( .sel(shamt[4]), .a(stage3[i]), .b(dir_bit4), .y(stage4[i]) );
    end
  endgenerate

  
  assign dout = stage4;

endmodule
