module accumulator(
    input clk, load_en, 
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @ (posedge clk) begin
        data_out <= load_en ? data_in : data_out;   
    end
endmodule