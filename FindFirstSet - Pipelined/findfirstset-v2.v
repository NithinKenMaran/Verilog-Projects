module findfirstset(
    input clk, reset, valid_in,
    input [1023:0] in,
    output reg [9:0] result
);

    ///////// PIPELINE  ///////////////
    /*
    - pipeline. 9: input. 0: output
    - each pipeline stage gets a select half of the above stage. 
    - selection depends on above stage output.

    -> inreg[8] <= out[9] ? inreg[9][2^9 +: 2^9] : inreg[9][0 +: 2^9]

    */

    reg [1023:0] inreg [9:0]; 
    genvar j;
    always @ (posedge clk) begin 
        inreg[9] <= in;
        generate 
            for (j = 0; j < 9; j++) begin: pipeline_stages
                inreg[j] <= out[j+1] ? inreg[j+1][2 ** (j+1) +: 2 ** (j+1)] : inreg[j+1][0 +: 2 ** (j+1)];
            end
        endgenerate
    end


    //////// STAGE OUTPUT ////////
    /*

    out[9] = |inreg[9][2^9 +: 2^9]
    slice starts at 2^i, for a width of 2^i.
    
    */
    genvar i;
    generate
        for (i = 0; i < 10; i++) begin: out_connection
            assign out[i] = |inreg[i][2**i +: 2**i]; 
        end
    endgenerate


    ////// STORING OUTPUTS ///////

    reg [9:0] outreg_rows [9:0];
    genvar k;
    always @ (posedge clk) begin
        generate
            for (k = 0; k < 10; k++) begin: outreg_filling
                outreg_rows[k] <= {out[k], outreg_rows[k][9:1]}; //shift out[k] (k'th stage output) in from the left.
            end
        endgenerate
    end

    ///////// VALIDITY //////////

    always @ (posedge clk) begin
        {validity_reg, validity_out} <= {valid_in, validity_reg[9:0]};
    end


    ///////// RESULT //////////
    wire [9:0] out_diag;
    genvar m;
    generate
        for (m = 0; m < 10; m++) begin: diagonal
            out_diag[k] = outreg_rows[k][9-k];
        end
    endgenerate
    assign result = {10{validity_out}} & 


endmodule