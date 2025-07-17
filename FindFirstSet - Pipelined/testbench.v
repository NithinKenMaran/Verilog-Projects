`timescale 1ns/100ps
module testbench;
    // clock //
    reg clk = 1'b0;
    always #5 clk = ~clk;

    // instantiation //
    reg reset, in_valid = 0;
    reg [1023:0] in = { 
    {1016{1'b0}}, 
    {4{1'b1}}, 
    {4{1'b0}}         };
    wire [9:0] result;
    wire out_valid;
     
    // debug signals //
    wire [0:9] debug_valid_pipe;
    wire [1023:0] ds0;
    wire [511:0]  ds1;
    wire [255:0]  ds2;
    wire [127:0]  ds3;
    wire [63:0]   ds4;
    wire [31:0]   ds5;
    wire [15:0]   ds6;
    wire [7:0]    ds7;
    wire [3:0]    ds8;
    wire [1:0]    ds9;


    wire [9:0] rs0; 
    wire [9:0] rs1; 
    wire [9:0] rs2; 
    wire [9:0] rs3; 
    wire [9:0] rs4; 
    wire [9:0] rs5; 
    wire [9:0] rs6; 
    wire [9:0] rs7; 
    wire [9:0] rs8; 
    wire [9:0] rs9; 
    // ------------ //

    findfirstset dut (clk, reset, in_valid, in,
    // debug signals //
    debug_valid_pipe,
    ds0, ds1, ds2, ds3, ds4, ds5, ds6, ds7, ds8, ds9,

    rs0, rs1, rs2, rs3, rs4, rs5, rs6, rs7, rs8, rs9,
    // ------------- //
     result, out_valid);

    // debug monitors //
    // initial $monitor("validity: %b, result: %b", debug_valid_pipe, result);

    // initial $monitor("stage0: %b \n stage1: %b \n stage2: %b \n stage3: %b \n stage4: %b \n stage5: %b \n stage6: %b \n stage7: %b \n stage8: %b \n stage9: %b ", ds0, ds1, ds2, ds3, ds4, ds5, ds6, ds7, ds8, ds9);

    initial $monitor("result0: %b \n result1: %b \n result2: %b \n result3: %b \n result4: %b \n result5: %b \n result6: %b \n result7: %b \n result8: %b \n result9: %b \n validity: %b", rs0, rs1, rs2, rs3, rs4, rs5, rs6, rs7, rs8, rs9, debug_valid_pipe);

    // ----- //

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