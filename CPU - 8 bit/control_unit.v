module control_unit(
    input clk
);
// INSTANTIATION //

    // registers //
    reg [7:0] sreg;
    reg [1:0] state;

    reg [7:0] r [0:4]; // 5x 8-bit registers

    // memory //
    wire [63:0] mem_slot;

    reg mem_rw, mem_clr;
    reg [3:0] mem_address;
    reg signed [7:0] mem_data_in;
    wire signed [7:0] mem_data_out;
    wire mem_out_valid;

    memory mem_card_1 (
        clk, mem_rw, mem_clr, mem_address, mem_data_in, mem_data_out,
        mem_out_valid, mem_slot
    );

    // ALU //
    reg signed [7:0] alu_in_a, alu_in_b;
    reg [2:0] alu_op;
    wire [7:0] alu_result;
    wire alu_cout, alu_overflow;

    alu logic_unit (
        alu_in_a, alu_in_b, alu_op, alu_result,
        alu_cout, alu_overflow
    );

    // program counter //
    reg pc_jump, pc_increment, pc_reset;

    wire pc_increment_safe;
    assign pc_increment_safe = pc_increment & ~pc_jump;

    reg [3:0] pc_address_input;
    wire [3:0] pc_address_output;
    wire pc_overflow;

    program_counter pc (
        clk, pc_reset, pc_jump, pc_increment_safe,
        pc_address_input, pc_address_output, pc_overflow
    );

    // instruction register //
    reg ir_load_en;
    reg [7:0] ir_instruction_in;
    wire [3:0] ir_opcode, ir_operand;

    instruction_register ir (
        clk, ir_load_en, ir_instruction_in, ir_opcode, ir_operand
    );

    // accumulator //
    reg acc1_load_en, acc2_load_en;
    reg [7:0] acc1_data_in, acc2_data_in;
    wire [7:0] acc1_data_out, acc2_data_out;

    accumulator acc1 (
        clk, acc1_load_en, acc1_data_in, acc1_data_out
    );
    accumulator acc2 (
        clk, acc2_load_en, acc2_data_in, acc2_data_out
    );


// OPERATION // 
    initial begin 
        state <= IDLE;
        
    end

    // FETCH // 
    parameter IDLE = 2'd0, FETCH = 2'd1, DECODE = 2'd2, EXECUTE = 2'd3;
    always @ (posedge clk) begin
        case (state) 
            FETCH: 
        endcase
    end

    

    // DECODE //

    // EXECUTE //
    

endmodule