/*NOTES:
all places: index 9: pipeline input, index 0: pipeline output.
stage9: top stage (2^10 -> 2^9); stage0: bottom stage

*/
module findfirstset(
    input clk, reset, valid_in,
    input [1023:0] in,
    output reg [9:0] result
);

    wire [9:0] out; 
    reg [9:0] validity_reg; reg validity_out;

    // i'll keep a width of 1024 for all stages, though the width reduces by a factor of 2 every stage.
    reg [1023:0] inreg [9:0]; //9: pipeline input, 0: pipeline output.

    // stages
    genvar j;
    always @ (posedge clk) begin //each pipeline stage gets a select half of the above stage. 
    // selection depends on above stage output.
        inreg[9] <= in;
        generate 
            for (j = 0; j < 9; j++) begin: pipeline_stages
                // inreg[8] <= out[9] ? inreg[9][2^9 +: 2^9] : inreg[9][0 +: 2^9]
                inreg[j] <= out[j+1] ? inreg[j+1][2 ** (j+1) +: 2 ** (j+1)] : inreg[j+1][0 +: 2 ** (j+1)];
            end
        endgenerate
    end

    // stage output
    genvar i;
    generate
        for (i = 0; i < 10; i++) begin: out_connection
            // out[9] = |inreg[9][2^9 +: 2^9]
            assign out[i] = |inreg[i][2**i +: 2**i]; //starts at 2^i, for a width of 2^i.
        end
    endgenerate


    // out register
    // output is the diagonal of this matrix.
    reg [9:0] outreg_rows [9:0];
    genvar k;
    always @ (posedge clk) begin
        generate
            for (k = 0; k < 10; k++) begin: outreg_filling
                outreg_rows[k] <= {out[k], outreg_rows[k][9:1]}; //shift out[k] (k'th stage output) in from the left.
            end
        endgenerate
    end

    // validity_out contains whether the output at the current point is valid. 
    always @ (posedge clk) begin
        {validity_reg, validity_out} <= {valid_in, validity_reg[9:0]};
    end

    // result update
    wire [9:0] out_diag;
    genvar m;
    generate
        for (m = 0; m < 10; m++) begin: diagonal
            out_diag[k] = out
        end
    endgenerate
    assign result = {10{validity_out}} & 

endmodule  