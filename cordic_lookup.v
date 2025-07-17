module cordic_lookup (
    input [2:0] index,
    output reg signed [7:0] atan_out
);
    always @(*) begin
        case (index)
            3'd0: atan_out = 8'sd50;
            3'd1: atan_out = 8'sd30;
            3'd2: atan_out = 8'sd16;
            3'd3: atan_out = 8'sd8;
            3'd4: atan_out = 8'sd4;
            3'd5: atan_out = 8'sd2;
            3'd6: atan_out = 8'sd1;
            default: atan_out = 8'sd0;
        endcase
    end
endmodule
