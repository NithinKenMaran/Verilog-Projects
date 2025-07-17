module accumulator(
    input clk, load_en, 
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @ (posedge clk) begin
        data_out <= load_en ? data_in : data_out;   
    end
endmodule