module tb_5b6b;

  reg  [4:0] din;
  reg        rd_in;
  wire [5:0] dout;
  wire       rd_out;

  logic [5:0] exp_minus [0:31];  // abcdei when rd_in = 0 (RD-)
  logic [5:0] exp_plus  [0:31];  // abcdei when rd_in = 1 (RD+)
  bit exp_rdout;
  int errors = 0;

  enc_5b6b u_enc_5b6b (
    .din(din), .rd_in(rd_in), .dout(dout), .rd_out(rd_out)
  );

  task check(input int idx, input bit rd,
             input logic [5:0] exp_code, input bit exp_rdout);
    if (dout !== exp_code) begin
      $error("D%0d.0 RD%s : din=%b  dout=%b  exp=%b  <-- DOUT MISMATCH",
             idx, rd ? "+" : "-", din, dout, exp_code);
      errors++;
    end
    else if (rd_out !== exp_rdout) begin
      $error("D%0d.0 RD%s : din=%b  rd_out=%b  exp=%b  <-- RD_OUT MISMATCH",
             idx, rd ? "+" : "-", din, rd_out, exp_rdout);
      errors++;
    end
    else
      $display("D%0d.0 RD%s : din=%b  dout=%b  rd_out=%b  OK",
               idx, rd ? "+" : "-", din, dout, rd_out);
  endtask


  function automatic bit exp_rd(input logic [5:0] code, input bit rd_before);
    case ($countones(code))
      4:       return 1'b1;         // 1-heavy → RD+
      2:       return 1'b0;         // 0-heavy → RD-
      default: return rd_before;    // 3-3 neutral 
    endcase
  endfunction

  initial begin
    // 5b/6b (abcdei) code-groups, IEEE 802.3-2022 Table 36-1
    // Bit order: dout[5]=a ... dout[0]=i
    exp_minus[0]=6'b100111 ; exp_plus[0]=6'b011000;  // D0
    exp_minus[1]=6'b011101 ; exp_plus[1]=6'b100010;  // D1
    exp_minus[2]=6'b101101 ; exp_plus[2]=6'b010010;  // D2
    exp_minus[3]=6'b110001 ; exp_plus[3]=6'b110001;  // D3
    exp_minus[4]=6'b110101 ; exp_plus[4]=6'b001010;  // D4
    exp_minus[5]=6'b101001 ; exp_plus[5]=6'b101001;  // D5
    exp_minus[6]=6'b011001 ; exp_plus[6]=6'b011001;  // D6
    exp_minus[7]=6'b111000 ; exp_plus[7]=6'b000111;  // D7
    exp_minus[8]=6'b111001 ; exp_plus[8]=6'b000110;  // D8
    exp_minus[9]=6'b100101 ; exp_plus[9]=6'b100101;  // D9
    exp_minus[10]=6'b010101; exp_plus[10]=6'b010101; // D10
    exp_minus[11]=6'b110100; exp_plus[11]=6'b110100; // D11
    exp_minus[12]=6'b001101; exp_plus[12]=6'b001101; // D12
    exp_minus[13]=6'b101100; exp_plus[13]=6'b101100; // D13
    exp_minus[14]=6'b011100; exp_plus[14]=6'b011100; // D14
    exp_minus[15]=6'b010111; exp_plus[15]=6'b101000; // D15
    exp_minus[16]=6'b011011; exp_plus[16]=6'b100100; // D16
    exp_minus[17]=6'b100011; exp_plus[17]=6'b100011; // D17
    exp_minus[18]=6'b010011; exp_plus[18]=6'b010011; // D18
    exp_minus[19]=6'b110010; exp_plus[19]=6'b110010; // D19
    exp_minus[20]=6'b001011; exp_plus[20]=6'b001011; // D20
    exp_minus[21]=6'b101010; exp_plus[21]=6'b101010; // D21
    exp_minus[22]=6'b011010; exp_plus[22]=6'b011010; // D22
    exp_minus[23]=6'b111010; exp_plus[23]=6'b000101; // D23
    exp_minus[24]=6'b110011; exp_plus[24]=6'b001100; // D24
    exp_minus[25]=6'b100110; exp_plus[25]=6'b100110; // D25
    exp_minus[26]=6'b010110; exp_plus[26]=6'b010110; // D26
    exp_minus[27]=6'b110110; exp_plus[27]=6'b001001; // D27
    exp_minus[28]=6'b001110; exp_plus[28]=6'b001110; // D28
    exp_minus[29]=6'b101110; exp_plus[29]=6'b010001; // D29
    exp_minus[30]=6'b011110; exp_plus[30]=6'b100001; // D30
    exp_minus[31]=6'b101011; exp_plus[31]=6'b010100; // D31
    
    for (int i = 0; i < 32; i++) begin
      din = i[4:0]; rd_in = 1'b0;              // entered RD-
      exp_rdout= exp_rd(exp_minus[i], rd_in);
      #10;             
      check(i, 1'b0, exp_minus[i], exp_rdout);

      rd_in = 1'b1;              // entered RD+
      exp_rdout= exp_rd(exp_plus[i], rd_in);
      #10;
      check(i, 1'b1, exp_plus[i],  exp_rdout);  
    end

    if (errors == 0) $display("\n=== PASS: 64 checks match Table 36-1 (dout + rd_out) ===");
    else             $display("\n=== FAIL: %0d mismatch(es) ===", errors);
    $finish;
  end

endmodule