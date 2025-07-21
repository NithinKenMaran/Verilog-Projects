module memory(
    input clk, rw, clr,
    input [3:0] address,
    input signed [7:0] data_in,
    output reg signed [7:0] data_out,
    output out_valid,

    output reg [63:0] mem_block // 8-bit width, 8-word depth.
);

    always @ (posedge clk) begin
        if (clr) begin
            mem_block <= 0;
        end

        else if (~rw) begin
            data_out <= mem_block[address << 3 +: 8];
        end

        else if (rw) begin
            mem_block[address << 3 +: 8] <= data_in;
        end
    end

    assign out_valid = ~rw;

endmodule