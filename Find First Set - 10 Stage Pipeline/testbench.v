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