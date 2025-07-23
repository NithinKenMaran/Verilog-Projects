`include "header/opcodes.vh"
module alu(
    input signed [7:0] operand_a, operand_b, 
    input [3:0] alu_op,
    output reg signed [7:0] result,
    output reg cout, 
    output overflow
);
    always @ (*) begin
        case(alu_op)
            `ADD: {cout, result} = operand_a + operand_b;
            `SUB: {cout, result} = operand_a - operand_b;
            `AND: result = operand_a & operand_b;
            `OR: result = operand_a | operand_b;
            `XOR: result = operand_a ^ operand_b;
        endcase 
    end

    assign overflow = ~operand_a[7] & ~operand_b[7] & result[7] | 
    operand_a[7] & operand_b[7] & ~result[7];

endmodule