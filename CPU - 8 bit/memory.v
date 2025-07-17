module memory(
    input clk, enable, rw,
    input [3:0] address,
    input signed [7:0] data_in,
    output signed [7:0] data_out
);
    reg [7:0] regfile [15:0]; //16 words, 1B each.

    always @ (posedge clk) begin
        if (enable) begin
            if (rw) begin
                regfile[address] 
            end
        end
    end


endmodule