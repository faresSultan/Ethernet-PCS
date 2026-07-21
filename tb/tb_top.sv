module tb_top;

  reg  [4:0] din;
  reg        rd_in;
  wire [5:0] dout;
  wire       rd_out;

  logic [5:0] exp_minus [0:31];  // expected abcdei when rd_in = 0 (RD-)
  logic [5:0] exp_plus  [0:31];  // expected abcdei when rd_in = 1 (RD+)
  int errors = 0;
  bit isBalanced [31:0];  // 1 if the code-group is balanced, 0 otherwise
  
  enc_5b6b u_enc_5b6b (
    .din(din),
    .rd_in(rd_in),
    .dout(dout),
    .rd_out(rd_out)
  );

  // Self-checking task: compare DUT output against the spec value
  task check(input int idx, input bit rd, input logic [5:0] expected);
    if (dout !== expected) begin
      $error("D%0d.0 RD%s : din=%b  dout=%b  expected=%b  <-- MISMATCH",
             idx, rd ? "+" : "-", din, dout, expected);
      errors++;
    end
    else if (isBalanced[idx] && (rd_out !== rd_in)) begin // if balanced, rd_out should match rd_in
        $error("D%0d.0 RD%s : din=%b  rd_out=%b  expected=%b  <-- MISMATCH",
              idx, rd ? "+" : "-", din, rd_out, rd_in);
        errors++;
    end
    else if (!isBalanced[idx] && rd_out !== ~rd_in) begin // if not balanced, rd_out should be inverted
      $error("D%0d.0 RD%s : din=%b  rd_out=%b  expected=%b  <-- MISMATCH",
             idx, rd ? "+" : "-", din, rd_out, ~rd_in);
      errors++;
    end
    else
      $display("D%0d.0 RD%s : din=%b  dout=%b  OK", idx, rd ? "+" : "-", din, dout);
  endtask

  initial begin
    // 5b/6b (abcdei) code-groups, IEEE 802.3-2022 Table 36-1
    // Bit order assumed: dout[5]=a, dout[4]=b, ... dout[0]=i
    exp_minus[0]=6'b100111 ; exp_plus[0]=6'b011000; // D0
    isBalanced[0] = 1'b0;  
    exp_minus[1]=6'b011101 ; exp_plus[1]=6'b100010; // D1
    isBalanced[1] = 1'b0;  
    exp_minus[2]=6'b101101 ; exp_plus[2]=6'b010010; // D2
    isBalanced[2] = 1'b0;  
    exp_minus[3]=6'b110001 ; exp_plus[3]=6'b110001; // D3  (balanced)
    isBalanced[3] = 1'b1;  
    exp_minus[4]=6'b110101 ; exp_plus[4]=6'b001010; // D4
    isBalanced[4] = 1'b0;  
    exp_minus[5]=6'b101001 ; exp_plus[5]=6'b101001; // D5  (balanced)
    isBalanced[5] = 1'b1;  
    exp_minus[6]=6'b011001 ; exp_plus[6]=6'b011001; // D6  (balanced)
    isBalanced[6] = 1'b1;  
    exp_minus[7]=6'b111000 ; exp_plus[7]=6'b000111; // D7
    isBalanced[7] = 1'b0;  
    exp_minus[8]=6'b111001 ; exp_plus[8]=6'b000110; // D8
    isBalanced[8] = 1'b0;  
    exp_minus[9]=6'b100101 ; exp_plus[9]=6'b100101; // D9  (balanced)
    isBalanced[9] = 1'b1;  
    exp_minus[10]=6'b010101; exp_plus[10]=6'b010101; // D10 (balanced)
    isBalanced[10] = 1'b1;
    exp_minus[11]=6'b110100; exp_plus[11]=6'b110100; // D11 (balanced)
    isBalanced[11] = 1'b1;
    exp_minus[12]=6'b001101; exp_plus[12]=6'b001101; // D12 (balanced)
    isBalanced[12] = 1'b1;
    exp_minus[13]=6'b101100; exp_plus[13]=6'b101100; // D13 (balanced)
    isBalanced[13] = 1'b1;
    exp_minus[14]=6'b011100; exp_plus[14]=6'b011100; // D14 (balanced)
    isBalanced[14] = 1'b1;
    exp_minus[15]=6'b010111; exp_plus[15]=6'b101000; // D15
    isBalanced[15] = 1'b0;
    exp_minus[16]=6'b011011; exp_plus[16]=6'b100100; // D16
    isBalanced[16] = 1'b0;
    exp_minus[17]=6'b100011; exp_plus[17]=6'b100011; // D17 (balanced)
    isBalanced[17] = 1'b1;
    exp_minus[18]=6'b010011; exp_plus[18]=6'b010011; // D18 (balanced)
    isBalanced[18] = 1'b1;
    exp_minus[19]=6'b110010; exp_plus[19]=6'b110010; // D19 (balanced)
    isBalanced[19] = 1'b1;
    exp_minus[20]=6'b001011; exp_plus[20]=6'b001011; // D20 (balanced)
    isBalanced[20] = 1'b1;
    exp_minus[21]=6'b101010; exp_plus[21]=6'b101010; // D21 (balanced)
    isBalanced[21] = 1'b1;
    exp_minus[22]=6'b011010; exp_plus[22]=6'b011010; // D22 (balanced)
    isBalanced[22] = 1'b1;
    exp_minus[23]=6'b111010; exp_plus[23]=6'b000101; // D23
    isBalanced[23] = 1'b0;
    exp_minus[24]=6'b110011; exp_plus[24]=6'b001100; // D24
    isBalanced[24] = 1'b0;
    exp_minus[25]=6'b100110; exp_plus[25]=6'b100110; // D25 (balanced)
    isBalanced[25] = 1'b1;
    exp_minus[26]=6'b010110; exp_plus[26]=6'b010110; // D26 (balanced)
    isBalanced[26] = 1'b1;
    exp_minus[27]=6'b110110; exp_plus[27]=6'b001001; // D27
    isBalanced[27] = 1'b0;
    exp_minus[28]=6'b001110; exp_plus[28]=6'b001110; // D28 (balanced)
    isBalanced[28] = 1'b1;
    exp_minus[29]=6'b101110; exp_plus[29]=6'b010001; // D29
    isBalanced[29] = 1'b0;
    exp_minus[30]=6'b011110; exp_plus[30]=6'b100001; // D30
    isBalanced[30] = 1'b0;
    exp_minus[31]=6'b101011; exp_plus[31]=6'b010100; // D31
    isBalanced[31] = 1'b0;

    // Test all 32 inputs with both RD- and RD+
    for (int i = 0; i < 32; i++) begin
      din = i[4:0]; rd_in = 1'b0; #10;  // RD-
      check(i, 1'b0, exp_minus[i]);
      din = i[4:0]; rd_in = 1'b1; #10;  // RD+
      check(i, 1'b1, exp_plus[i]);
    end

    if (errors == 0) $display("\n=== PASS: all 64 code-groups match Table 36-1 ===");
    else             $display("\n=== FAIL: %0d mismatch(es) ===", errors);

  end
  

endmodule
