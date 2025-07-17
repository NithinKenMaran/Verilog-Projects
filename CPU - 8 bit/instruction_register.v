module instruction_register(
    input clk, load_en, 
    input [7:0] instruction_in,
    output [3:0] opcode, operand
);

    reg [7:0] instruction;
    always @ (posedge clk) begin
        instruction <= load_en ? instruction_in : instruction;
    end

    assign {opcode, operand} = instruction;
endmodule