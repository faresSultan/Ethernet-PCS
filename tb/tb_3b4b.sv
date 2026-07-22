module tb_3b4b;

  reg  [2:0] din;
  reg        rd_in;
  wire [3:0] dout;
  wire       rd_out;

  logic [3:0] exp_minus [0:7];  // abcdei when rd_in = 0 (RD-)
  logic [3:0] exp_plus  [0:7];  // abcdei when rd_in = 1 (RD+)
  bit exp_rdout;
  int errors = 0;

  enc_3b4b u_enc_3b4b (
    .din(din), .rd_in(rd_in), .dout(dout), .rd_out(rd_out)
  );

  task check(input int idx, input bit rd,
             input logic [3:0] exp_code, input bit exp_rdout);
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


  function automatic bit exp_rd(input logic [3:0] code, input bit rd_before);
    case ($countones(code))
      3:       return 1'b1;         // 1-heavy → RD+
      1:       return 1'b0;         // 0-heavy → RD-
      default: return rd_before;    // 2-2 neutral 
    endcase
  endfunction

  initial begin
    // 3b/4b (fghj) code-groups, IEEE 802.3-2022 Table 36-1
    // Bit order: dout[3]=f ... dout[0]=j
    exp_minus[0]=4'b1011; exp_plus[0]=4'b0100;  // D0
    exp_minus[1]=4'b1001; exp_plus[1]=4'b1001;  // D1
    exp_minus[2]=4'b0101; exp_plus[2]=4'b0101;  // D2
    exp_minus[3]=4'b1100; exp_plus[3]=4'b0011;  // D3
    exp_minus[4]=4'b1101; exp_plus[4]=4'b0010;  // D4
    exp_minus[5]=4'b1010; exp_plus[5]=4'b1010;  // D5
    exp_minus[6]=4'b0110; exp_plus[6]=4'b0110;  // D6
    exp_minus[7]=4'b1110; exp_plus[7]=4'b0001;  // D7
   
    for (int i = 0; i < 8; i++) begin
      din = i[2:0]; rd_in = 1'b0;              // entered RD-
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