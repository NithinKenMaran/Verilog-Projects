module control_unit(
    input clk
);

    // registers //
    reg [1:0] sreg;
    reg [15:0] r [0:7]; // register file

// INSTANTIATION //

    // memory (RAM) //
    wire [127:0] mem_slot;

    reg mem_rw, mem_clr;
    reg [3:0] mem_address;
    reg signed [15:0] mem_data_in;
    wire signed [15:0] mem_data_out;
    wire mem_out_valid;

    memory mem_card_1 (
        clk, mem_rw, mem_clr, mem_address, mem_data_in, mem_data_out,
        mem_out_valid, mem_slot
    );

    // ROM //
    reg [287:0] rom;

    // ALU //
    reg signed [15:0] alu_in_a, alu_in_b;
    reg [2:0] alu_op;
    wire [7:0] alu_result;
    wire alu_cout, alu_overflow;

    alu logic_unit (
        alu_in_a, alu_in_b, alu_op, alu_result,
        alu_cout, alu_overflow
    );   




endmodule