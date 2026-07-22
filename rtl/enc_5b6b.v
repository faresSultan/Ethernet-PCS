// 5b/6b sub-encoder
// Input : 5 data bits + current running disparity (rd_in)
// Output: 6 encoded bits + resulting running disparity (rd_out)

module enc_5b6b (
    input       [4:0] din,      // the 5-bit value (0..31)
    input             rd_in,    // current RD: 0 = RD-, 1 = RD+
    output reg  [5:0] dout,     // the 6-bit code group
    output reg        rd_out    // RD after this code
);

    always @(*) begin
        case (din)
            //=====================RD+ code    RD- code
            5'd0  : begin
                dout   = rd_in ? 6'b011000 : 6'b100111;
                rd_out = ~rd_in;
            end 
            5'd1  : begin
                dout   = rd_in ? 6'b100010 : 6'b011101;
                rd_out = ~rd_in;
            end
            5'd2  : begin
                dout   = rd_in ? 6'b010010 : 6'b101101;
                rd_out = ~rd_in;
            end
            5'd3  : begin
                dout   = 6'b110001;
                rd_out = rd_in;
            end
            5'd4  : begin
                dout   = rd_in ? 6'b001010 : 6'b110101;
                rd_out = ~rd_in;
            end
            5'd5  : begin
                dout   = 6'b101001;
                rd_out = rd_in;
            end
            5'd6  : begin
                dout   = 6'b011001;
                rd_out = rd_in;
            end
            5'd7  : begin 
                dout   = rd_in ? 6'b000111 : 6'b111000;
                rd_out = rd_in;
            end
            5'd8  : begin
                dout   = rd_in ? 6'b000110 : 6'b111001;
                rd_out = ~rd_in;
            end
            5'd9  : begin
                dout   = 6'b100101;
                rd_out = rd_in;
            end
            5'd10 : begin
                dout   = 6'b010101;
                rd_out = rd_in;
            end
            5'd11 : begin
                dout   = 6'b110100;
                rd_out = rd_in;
            end
            5'd12 : begin
                dout   = 6'b001101;
                rd_out = rd_in;
            end
            5'd13 : begin
                dout   = 6'b101100;
                rd_out = rd_in;
            end
            5'd14 : begin
                dout   = 6'b011100;
                rd_out = rd_in;
            end
            5'd15 : begin
                dout   = rd_in ? 6'b101000 : 6'b010111;
                rd_out = ~rd_in;
            end
            5'd16 : begin
                dout   = rd_in ? 6'b100100 : 6'b011011;
                rd_out = ~rd_in;
            end
            5'd17 : begin
                dout   = 6'b100011;
                rd_out = rd_in;
            end
            5'd18 : begin
                dout   = 6'b010011;
                rd_out = rd_in;
            end
            5'd19 : begin
                dout   = 6'b110010;
                rd_out = rd_in;
            end
            5'd20 : begin
                dout   = 6'b001011;
                rd_out = rd_in;
            end
            5'd21 : begin
                dout   = 6'b101010;
                rd_out = rd_in;
            end
            5'd22 : begin
                dout   = 6'b011010;
                rd_out = rd_in;
            end
            5'd23 : begin
                dout   = rd_in ? 6'b000101 : 6'b111010;
                rd_out = ~rd_in;
            end
            5'd24 : begin
                dout   = rd_in ? 6'b001100 : 6'b110011;
                rd_out = ~rd_in;
            end
            5'd25 : begin
                dout   = 6'b100110;
                rd_out = rd_in;
            end
            5'd26 : begin
                dout   = 6'b010110;
                rd_out = rd_in;
            end
            5'd27 : begin
                dout   = rd_in ? 6'b001001 : 6'b110110;
                rd_out = ~rd_in;
            end
            5'd28 : begin
                dout   = 6'b001110;
                rd_out = rd_in;
            end
            5'd29 : begin
                dout   = rd_in ? 6'b010001 : 6'b101110;
                rd_out = ~rd_in;
            end
            5'd30 : begin
                dout   = rd_in ? 6'b100001 : 6'b011110;
                rd_out = ~rd_in;
            end
            5'd31 : begin
                dout   = rd_in ? 6'b010100 : 6'b101011;
                rd_out = ~rd_in;
            end

        endcase
    end

endmodule