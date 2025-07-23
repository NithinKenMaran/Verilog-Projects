module findfirstset(
    input clk, reset, in_valid, 
    input [1023:0] in,

    output [9:0] result, 
    output out_valid
);

    // validity //
    reg validity [1:10];

    // pipeline stages //
    reg [511:0] stage1; reg [9:0] result_stage1;
    reg [255:0] stage2; reg [9:0] result_stage2;
    reg [127:0] stage3; reg [9:0] result_stage3;
    reg [63:0] stage4; reg [9:0] result_stage4;
    reg [31:0] stage5; reg [9:0] result_stage5;
    reg [15:0] stage6; reg [9:0] result_stage6;
    reg [7:0] stage7; reg [9:0] result_stage7;
    reg [3:0] stage8; reg [9:0] result_stage8;
    reg [1:0] stage9; reg [9:0] result_stage9;
    reg stage10; reg [9:0] result_stage10;

    // initialize //
    initial begin
        for (integer i = 1; i <= 10; i++) begin
            validity[i] <= 1'b0;
        end

        stage1 <= {512{1'b0}}; result_stage1 <= {10{1'b0}};
        stage2 <= {256{1'b0}}; result_stage2 <= {10{1'b0}};
        stage3 <= {128{1'b0}}; result_stage3 <= {10{1'b0}};
        stage4 <= {64{1'b0}}; result_stage4 <= {10{1'b0}};
        stage5 <= {32{1'b0}}; result_stage5 <= {10{1'b0}};
        stage6 <= {16{1'b0}}; result_stage6 <= {10{1'b0}};
        stage7 <= {8{1'b0}}; result_stage7 <= {10{1'b0}};
        stage8 <= {4{1'b0}}; result_stage8 <= {10{1'b0}};
        stage9 <= {2{1'b0}}; result_stage9 <= {10{1'b0}};
        stage10 <= 1'b0; result_stage10 <= {10{1'b0}};
    end

    // stage 1 //
    always @ (posedge clk) begin
        validity[1] <= in_valid;
        stage1 <= |in[511:0] ? in[511:0] : in[1023:512];
        result_stage1 <= { {9{1'b0}} , ~|in[511:0] };
    end

    // stage 2 //
    always @ (posedge clk) begin
        validity[2] <= validity[1];
        stage2 <= |stage1[255:0] ? stage1[255:0] : stage1[511:256];
        result_stage2 <= { result_stage1[8:0] , ~|stage1[255:0] };
    end

    // stage 3 //
    always @ (posedge clk) begin
        validity[3] <= validity[2];
        stage3 <= |stage2[127:0] ? stage2[127:0] : stage2[255:128];
        result_stage3 <= { result_stage2[8:0], ~|stage2[127:0] };
    end

    // stage 4 //
    always @ (posedge clk) begin
        validity[4] <= validity[3];
        stage4 <= |stage3[63:0] ? stage3[63:0] : stage3[127:64];
        result_stage4 <= { result_stage3[8:0], ~|stage3[63:0] };
    end

    // stage 5 //
    always @ (posedge clk) begin
        validity[5] <= validity[4];
        stage5 <= |stage4[31:0] ? stage4[31:0] : stage4[63:32];
        result_stage5 <= { result_stage4[8:0], ~|stage4[31:0] };
    end

    // stage 6 //
    always @ (posedge clk) begin
        validity[6] <= validity[5];
        stage6 <= |stage5[15:0] ? stage5[15:0] : stage5[31:16];
        result_stage6 <= { result_stage5[8:0], ~|stage5[15:0] };
    end

    // stage 7 //
    always @ (posedge clk) begin
        validity[7] <= validity[6];
        stage7 <= |stage6[7:0] ? stage6[7:0] : stage6[15:8];
        result_stage7 <= { result_stage6[8:0], ~|stage6[7:0] };
    end
    

    // stage 8 //
    always @ (posedge clk) begin
        validity[8] <= validity[7];
        stage8 <= |stage7[3:0] ? stage7[3:0] : stage7[7:4];
        result_stage8 <= { result_stage7[8:0], ~|stage7[3:0] };
    end

    // stage 9 //
    always @ (posedge clk) begin
        validity[9] <= validity[8];
        stage9 <= |stage8[1:0] ? stage8[1:0] : stage8[3:2];
        result_stage9 <= { result_stage8[8:0], ~|stage8[1:0] };
    end
    
    // stage 10 //
    always @ (posedge clk) begin
        validity[10] <= validity[9];
        stage10 <= stage9[0] ? stage9[0] : stage9[1];
        result_stage10 <= { result_stage9[8:0], ~stage9[0] };
    end

    assign out_valid = validity[10];
    assign result = result_stage10;

endmodule