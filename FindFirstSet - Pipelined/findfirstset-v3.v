module findfirstset(
    input clk, reset, in_valid,
    input [1023:0] in,

// debug outputs //
    output [0:9] debug_valid_pipe,
    output [1023:0] ds0,
    output [511:0]  ds1,
    output [255:0]  ds2,
    output [127:0]  ds3,
    output [63:0]   ds4,
    output [31:0]   ds5,
    output [15:0]   ds6,
    output [7:0]    ds7,
    output [3:0]    ds8,
    output [1:0]    ds9,

    output [9:0] rs0, 
    output [9:0] rs1, 
    output [9:0] rs2, 
    output [9:0] rs3, 
    output [9:0] rs4, 
    output [9:0] rs5, 
    output [9:0] rs6, 
    output [9:0] rs7, 
    output [9:0] rs8, 
    output [9:0] rs9, 

/// ---------- ///

    output [9:0] result,
    output reg out_valid
);
    // debug signals //
    genvar debug;
    generate
        for (debug = 0; debug <= 9; debug = debug+1) begin
            assign debug_valid_pipe[debug] = valid_pipe[debug];
        end
    endgenerate

    assign ds0 = stage0;
    assign ds1 = stage1;
    assign ds2 = stage2;
    assign ds3 = stage3;
    assign ds4 = stage4;
    assign ds5 = stage5;
    assign ds6 = stage6;
    assign ds7 = stage7;
    assign ds8 = stage8;
    assign ds9 = stage9;
    
    assign rs0 = result_pipe[0];
    assign rs1 = result_pipe[1];
    assign rs2 = result_pipe[2];
    assign rs3 = result_pipe[3];
    assign rs4 = result_pipe[4];
    assign rs5 = result_pipe[5];
    assign rs6 = result_pipe[6];
    assign rs7 = result_pipe[7];
    assign rs8 = result_pipe[8];
    assign rs9 = result_pipe[9];

    // ------------ //

    // Stage data registers
    reg [1023:0] stage0;
    reg [511:0]  stage1;
    reg [255:0]  stage2;
    reg [127:0]  stage3;
    reg [63:0]   stage4;
    reg [31:0]   stage5;
    reg [15:0]   stage6;
    reg [7:0]    stage7;
    reg [3:0]    stage8;
    reg [1:0]    stage9;

    // Output pipeline (result and valid bits)
    reg [9:0] result_pipe [0:9];
    reg       valid_pipe [0:9];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            stage0 <= 0; stage1 <= 0; stage2 <= 0; stage3 <= 0;
            stage4 <= 0; stage5 <= 0; stage6 <= 0; stage7 <= 0;
            stage8 <= 0; stage9 <= 0;
            for (i = 0; i < 10; i = i + 1) begin
                result_pipe[i] <= 0;
                valid_pipe[i] <= 0;
            end
            out_valid <= 0;
        end 
        
        else begin
            // Stage 0
            stage0 <= in_valid ? in : 0;
            valid_pipe[0] <= in_valid;

            // Stage 1 to 9 - width of each stage: 2 ^ (10 - i) //
            // output of each stage: ~|stage[lower_half]: 2 ^ (9-i) //

            result_pipe[0] <= valid_pipe[0] & (~|stage0[511:0]);
            stage1 <= |stage0[511:0] ? stage0[511:0] : stage0[1023:512];

            result_pipe[1] <= valid_pipe[1] & ((result_pipe[0] << 1) + ~|stage1[255:0]);
            stage2 <= |stage1[255:0] ? stage1[255:0] : stage1[511:256];

            result_pipe[2] <= valid_pipe[2] & ((result_pipe[1] << 1) + ~|stage2[127:0]);
            stage3 <= |stage2[127:0] ? stage2[127:0] : stage2[255:127];

            result_pipe[3] <= valid_pipe[3] & ((result_pipe[2] << 1) + ~|stage3[63:0]);
            stage4 <= |stage3[63:0] ? stage3[63:0] : stage3[127:64];

            result_pipe[4] <= valid_pipe[4] & ((result_pipe[3] << 1) + ~|stage4[31:0]);
            stage5 <= |stage4[31:0] ? stage4[31:0] : stage4[63:32];

            result_pipe[5] <= valid_pipe[5] & ((result_pipe[4] << 1) + ~|stage5[15:0]);
            stage6 <= |stage5[15:0] ? stage5[15:0] : stage5[31:16];

            result_pipe[6] <= valid_pipe[6] & ((result_pipe[5] << 1) + ~|stage6[7:0]);
            stage7 <= |stage6[7:0] ? stage6[7:0] : stage6[15:8];

            result_pipe[7] <= valid_pipe[7] & ((result_pipe[6] << 1) + ~|stage7[3:0]);
            stage8 <= |stage7[3:0] ? stage7[3:0] : stage7[7:4];

            result_pipe[8] <= valid_pipe[8] & ((result_pipe[7] << 1) + ~|stage8[1:0]);
            stage9 <= |stage8[1:0] ? stage8[1:0] : stage8[3:2]; 

            result_pipe[9] <= valid_pipe[9] & ((result_pipe[8] << 1) + ~stage9[0]);

            // Validity pipeline //
            for (i = 1; i < 10; i = i + 1) begin
                valid_pipe[i] <= valid_pipe[i - 1];
            end

            // Outputs //
            out_valid <= valid_pipe[9];
        end
    end
    assign result = result_pipe[9];

endmodule
