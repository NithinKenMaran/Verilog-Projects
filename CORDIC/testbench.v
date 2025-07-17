module testbench;
    reg signed [7:0] angle_in;
    wire signed [7:0] cos_out, sin_out;

    cordic dut (
        angle_in, cos_out, sin_out
    );

    initial begin
        angle_in = 8'b0011_0010; // 45 degrees = pi/4 = 50 in Q1.6
        #10 $display("cos: %b, sin: %b", cos_out, sin_out);
        #10 $finish;
    end
endmodule