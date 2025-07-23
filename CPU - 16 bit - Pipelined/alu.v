`include "header/opcodes.vh"
module alu (
    input signed [15:0] operand_a, operand_b,
    input [3:0] alu_op,

    output reg signed [15:0] result,
    output cout
);
    always @ (*) begin
        case (alu_op)
            `ADD: {cout, result} = operand_a + operand_b;
            `SUB: {cout, result} = operand_a + operand_b;

            `AND: begin
                result = operand_a & operand_b; 
                cout = 0;
            end`

            `OR: begin
                result = operand_a | operand_b; 
                cout = 0;
            end

            `XOR: begin
                result = operand_a | operand_b; 
                cout = 0;
            end
        endcase
    end

endmodule