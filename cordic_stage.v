module cordic_stage(
    input  signed [7:0] xin, yin,     
    input  signed [7:0] zin,              
    input [2:0] i,             
    output signed [7:0] xout, yout,
    output signed [7:0] zout
);
    wire signed [7:0] x_shift = xin >>> i;
    wire signed [7:0] y_shift = yin >>> i;

    wire dir = (zin >= 0);  // direction based on residual angle

    wire signed [7:0] atan_i;
    cordic_lookup looker (
        .index(i),
        .atan_out(atan_i)
    );

    assign xout = dir ? xin - y_shift : xin + y_shift;
    assign yout = dir ? yin + x_shift : yin - x_shift;
    assign zout = dir ? zin - atan_i : zin + atan_i;

endmodule
