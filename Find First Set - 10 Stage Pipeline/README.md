# Introduction

I made this pipelined first-set finder, to practice my knowledge of pipelines. This is a precursor to an improved version of my 8-bit CPU, to include pipelines and support for line-jumps.

# Project Overview

This first-set finder takes an 1024-bit input, and returns the position of the first `1`, starting at the LSB. 

The design is **fully pipelined**, meaning that inputs can be fed continuously, and results will be output with a latency of 10 clock cycles. 
This also implies that with a full pipeline, the module **throughput is 1 output per clock cycle**.

# Pipeline Design Overview

The pipeline contains 10 stages, modelling a binary-search. Pretty clearly, an N-bit input would require `log₂(N)` pipeline stages.

At each stage, the lower/upper half of the previous stage is chosen. The stage output represents the presence of a `1` at any place in the lower half of the stage.

At the last stage, we'd be down to 1 bit, and the result pipeline would contain the position of the first `1`, starting from the LSB.

# Testing

I've presented an example `testbench.v` below, with a 1024-bit input:

```verilog
`timescale 1ns/100ps
module testbench;
    // clock //
    reg clk = 1'b0;
    always #5 clk = ~clk;

    // instantiation //
    reg reset, in_valid = 0;

    // input: { 000... <1016x> ...000, 1111, 0000 }
    // first 1 is at index #4

    reg [1023:0] in = { 
    {1016{1'b0}}, 
    {4{1'b1}}, 
    {4{1'b0}} };

    wire [9:0] result;
    wire out_valid;
    findfirstset dut (clk, reset, in_valid, in,

     result, out_valid);

    // reset //
    initial begin
        reset = 1'b1;
        repeat (2) @(negedge clk) ;
        reset = 1'b0;
    end

    // applying stimulus //
    initial begin
        wait (reset == 0); //happens at a negedge.
        in_valid = 1'b1; 
        //apply in_valid for one clock event.
        @(negedge clk);
        in_valid = 1'b0;
    end


    // collect output //
    reg [9:0] collected_output = 0;
    initial begin
        wait (out_valid);
        #1 collected_output = result;
        repeat (2) @ (posedge clk);
        $display("collected output: %b", collected_output);
        #2 $finish;
    end

endmodule

```

# Output

```
collected output: 0000000100
testbench.v:90: $finish called at 1370 (100ps)
```
