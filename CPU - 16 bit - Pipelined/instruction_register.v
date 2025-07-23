module instruction_register(
    input clk, load_en, 
    input [35:0] instruction_in, // opcode(4), operand1(8), operand2(8)

    output [3:0] opcode, 
    output [15:0] operand1, operand2
);

    reg [35:0] instruction;
    always @ (posedge clk) begin
        instruction <= load_en ? instruction_in : instruction;
    end

    assign {opcode, operand1, operand2} = instruction;
endmodule