# Overview

This is my hardware implementation of CORDIC with 6 stages, using 8 bit floating-point numbers, in Q1.6 format.

- Input: 8-bit angle, in radians, in Q1.6 8-bit floating-point format. 
- Output: `sin` and `cos` of input angle, in Q1.6 8-bit floating-point format.

>[!Note]
>Q1.6 floating-point format is made of 8 bits: 1 sign bit, 1 exponent bit, and 6 mantissa bits.

# Compiling

```bash
iverilog -o out -f files.txt
```

# Testing

The module requires an input angle, in 8-bit Q1.6 format. The testbench here shows a sample 45-degree input angle.

```verilog
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
```

# Output

1/√2 = 0.707

In Q1.6 format, 0.707 -> `0.707 * 64` = `45` -> `101101`
```
cos: 00101101, sin: 00101101
testbench.v:12: $finish called at 20 (1s)
```
