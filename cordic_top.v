module cordic (
    input  signed [7:0] angle_in,     
    output signed [7:0] cos_out,      
    output signed [7:0] sin_out       
);

    /* NOTE: Q1.6 format is used everywhere here. */

    // starting values //
    wire signed [7:0] x0 = 8'sd64; // x = 1.0, = 64 in Q1.6 format
    wire signed [7:0] y0 = 8'sd0; // y = 0.0
    wire signed [7:0] z0 = angle_in;

    // stages //
    wire signed [7:0] x1, y1, z1;
    wire signed [7:0] x2, y2, z2;
    wire signed [7:0] x3, y3, z3;
    wire signed [7:0] x4, y4, z4;
    wire signed [7:0] x5, y5, z5;
    wire signed [7:0] x6, y6, z6;

    // Stage 0
    cordic_stage stage0 (.xin(x0), .yin(y0), .zin(z0), .i(3'd0), .xout(x1), .yout(y1), .zout(z1));
    // Stage 1
    cordic_stage stage1 (.xin(x1), .yin(y1), .zin(z1), .i(3'd1), .xout(x2), .yout(y2), .zout(z2));
    // Stage 2
    cordic_stage stage2 (.xin(x2), .yin(y2), .zin(z2), .i(3'd2), .xout(x3), .yout(y3), .zout(z3));
    // Stage 3
    cordic_stage stage3 (.xin(x3), .yin(y3), .zin(z3), .i(3'd3), .xout(x4), .yout(y4), .zout(z4));
    // Stage 4
    cordic_stage stage4 (.xin(x4), .yin(y4), .zin(z4), .i(3'd4), .xout(x5), .yout(y5), .zout(z5));
    // Stage 5
    cordic_stage stage5 (.xin(x5), .yin(y5), .zin(z5), .i(3'd5), .xout(x6), .yout(y6), .zout(z6));

    // CORDIC scaling //
    // scaling value = 0.6 = 39 in Q1.6 (0.6 x 64 = 39)
    // bit shift right by 6, because Q1.6 x Q1.6 => Q2.12

    wire [15:0] x6_scaled, y6_scaled;
    assign x6_scaled = x6 * 8'sd39;
    assign y6_scaled = y6 * 8'sd39;

    assign cos_out = x6_scaled >>> 6;
    assign sin_out = y6_scaled >>> 6;

endmodule
