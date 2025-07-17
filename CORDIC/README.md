# Overview

This verilog project implements CORDIC with 8 stages, using 8 bit floating-point numbers, in Q1.6 format.

# Compiling

```bash
iverilog -o out -f files.txt
```

# Testing

The module requires an input angle, in 8-bit Q1.6 format. The testbench here shows a sample 45-degree input angle.
