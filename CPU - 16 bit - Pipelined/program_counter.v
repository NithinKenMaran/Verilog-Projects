module program_counter(
    input clk, reset, jump, increment,
    input [3:0] address_input,
    output reg [3:0] current_address,
    output reg pc_overflow
);

    always @ (posedge clk) begin
        current_address <= reset ? 4'b0000 : 
        jump ? address_input :
        increment ? current_address + 4'b0001 :
        current_address;
    end

    always @ (*) begin // latch: turned on if pc ever hits 4'b1111
        pc_overflow <= pc_overflow ? 1'b1 : 
        (current_address == 4'b1111) ? 1'b1 : 1'b0;
    end

endmodule