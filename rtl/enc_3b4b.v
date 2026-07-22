// 3b/4b sub-encoder
// Input : 3 data bits + current running disparity (rd_in)
// Output: 4 encoded bits + resulting running disparity (rd_out)

module enc_3b4b (
    input       [2:0] din,      // the 3-bit value (0..7)
    input             rd_in,    // current RD: 0 = RD-, 1 = RD+
    output reg  [3:0] dout,     // the 4-bit code group
    output reg        rd_out    // RD after this code
);

    always @(*) begin
        case (din)
            //=====================RD+ code    RD- code
            3'd0  : begin
                dout   = rd_in ? 4'b0100 : 4'b1011;
                rd_out = ~rd_in;
            end 
            3'd1  : begin
                dout   = 4'b1001;
                rd_out = rd_in;
            end
            3'd2  : begin
                dout   = 4'b0101;
                rd_out = rd_in;
            end
            3'd3  : begin
                dout   = rd_in ? 4'b0011 : 4'b1100;
                rd_out = rd_in;
            end
            3'd4  : begin 
                dout   = rd_in ? 4'b0010 : 4'b1101;
                rd_out = ~rd_in;
            end
            3'd5  : begin
                dout   = 4'b1010;
                rd_out = rd_in;
            end
            3'd6  : begin
                dout   = 4'b0110;
                rd_out = rd_in;
            end
            3'd7  : begin 
                dout   = rd_in ? 4'b0001 : 4'b1110;
                rd_out = ~rd_in;
            end
        endcase
    end
endmodule