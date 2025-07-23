`include "header/program.vh"
module control_unit(
    input clk, 

    output [2:0] cpu_state, 
    output [63:0] reg_file_out,
    output [3:0] pc_debug
);

// EXPOSED OUTPUTS FOR DEBUGGING //
    assign cpu_state = state;
    assign reg_file_out = {r[7], r[6], r[5], r[4], r[3], r[2], r[1], r[0]};
    assign pc_debug = pc_address_output;

// INSTANTIATION //

    // registers //
    reg [7:0] sreg;
    reg [2:0] state; // exposing CPU state as an output, above.
    reg [2:0] is_done;
    reg [7:0] r [0:7]; //register file


    // memory (RAM) //
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

    // memory (ROM) //
    reg [159:0] rom; //20-byte instructions, 8 instructions max.

    // ALU //
    reg signed [7:0] alu_in_a, alu_in_b;
    reg [3:0] alu_op;
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
    reg [19:0] ir_instruction_in;
    wire [3:0] ir_opcode;
    wire [7:0] ir_operand1, ir_operand2;

    instruction_register ir (
        clk, ir_load_en, ir_instruction_in, ir_opcode, ir_operand1, ir_operand2
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

    // CPU state machine //
    parameter INIT = 3'd0, FETCH = 3'd1, DECODE = 3'd2, EXECUTE = 3'd3, FINISH = 3'd4;
    always @ (posedge clk) begin
        case (state) 
            INIT: state <= (is_done == INIT) ? FETCH : INIT;
            FETCH: state <= (is_done == FETCH) ? DECODE : FETCH;
            DECODE: state <= (is_done == FINISH) ? FINISH : 
            (is_done == DECODE) ? EXECUTE : DECODE;
            EXECUTE: state <= (is_done == EXECUTE) ? FETCH : EXECUTE;
            FINISH: state <= FINISH;
        endcase
    end

    // INIT sub-state machine definitions //
    parameter INIT_SET_CLR = 1'b0, INIT_RELEASE_CLR = 1'b1;
    reg init_phase;

    // INITIALIZE //
    initial begin 
        rom <= `ROM; // load program into ROM

        // state machine initializations // 
        state <= INIT; 
        is_done <= FINISH;

        // sub-state machine initializations //
        init_phase <= INIT_SET_CLR;
        fetch_phase <= FETCH_LOAD;
        decode_phase <= DECODE_START;
        execute_phase <= EXECUTE_START;

    end

    // FETCH sub-state machine definitions //
    reg [1:0] fetch_phase;
    parameter FETCH_LOAD = 2'd0, FETCH_INC = 2'd1, FETCH_DONE = 2'd2;

    // DECODE sub-state machine definitions //
    reg [1:0] decode_phase;
    parameter DECODE_START = 2'd0, DECODE_DONE = 2'd1;

    // EXECUTE sub-state machine definitions //
    reg [1:0] execute_phase;
    parameter EXECUTE_START = 2'd0, EXECUTE_DONE = 2'd1;


    always @ (posedge clk) begin
        case (state) 
            INIT: begin
                case (init_phase) 
                    INIT_SET_CLR: begin
                        mem_clr <= 1'b1;
                        pc_reset <= 1'b1;
                        pc_jump <= 1'b0;
                        pc_increment <= 1'b0;
                        init_phase <= INIT_RELEASE_CLR;
                        is_done <= INIT; 
                    end
                    // sequence per clock cycle: INIT -> INIT is_done -> FETCH 

                    INIT_RELEASE_CLR: begin 
                    // mem_clr changes to 1'b0, and state changes to FETCH.
                        mem_clr <= 1'b0;
                        pc_reset <= 1'b0;
                    end
                endcase
            end

            FETCH: begin
                case (fetch_phase)
                    FETCH_LOAD: begin
                        ir_instruction_in <= rom[pc_address_output * 20 +: 20];
                        ir_load_en <= 1'b1;
                        fetch_phase <= FETCH_INC;
                    end
                    FETCH_INC: begin
                        ir_load_en <= 1'b0;
                        pc_increment <= 1'b1;
                        fetch_phase <= FETCH_DONE;
                        is_done <= FETCH;
                    end
                    FETCH_DONE: begin 
                        // pc_increment changes to 1'b0, and state changes to DECODE
                        pc_increment <= 1'b0;
                        fetch_phase <= FETCH_LOAD;
                    end
                endcase
            end

            DECODE: begin // setup inputs, for EXECUTE stage
                case (decode_phase)
                    DECODE_START: begin
                        decode_phase <= DECODE_DONE;
                        is_done <= DECODE;
                        case(ir_opcode) 
                            `ADD, `SUB, `AND, `OR, `XOR: begin
                                alu_in_a <= r[ir_operand1];
                                alu_in_b <= r[ir_operand2];
                                alu_op <= ir_opcode;
                            end

                            `STOP: begin
                                is_done <= FINISH; // CPU will now go directly to FINISH stage
                            end

                            default: ; //ignore
                        endcase
                    end

                    DECODE_DONE: begin
                        decode_phase <= DECODE_START;
                    end
                endcase
            end

            EXECUTE: begin
                case (execute_phase) 
                    EXECUTE_START: begin
                        execute_phase <= EXECUTE_DONE;
                        is_done <= EXECUTE;

                        case (ir_opcode)
                            `LDR: r[ir_operand1] <= ir_operand2;
                            `ADD, `SUB, `AND, `OR, `XOR: begin
                                r[ir_operand1] <= alu_result;
                            end

                            default: ; // NOP
                        endcase
                    end

                    EXECUTE_DONE: begin
                        execute_phase <= EXECUTE_START;
                    end
                endcase
            end
        endcase
    end

    

endmodule