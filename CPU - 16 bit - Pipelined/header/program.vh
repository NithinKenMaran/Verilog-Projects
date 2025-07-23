`include "opcodes.vh"

// each instruction: 36 bits: 4-bit opcode, 2x 16-bit operands.

// READ FROM BOTTOM -> TOP! 
`define ROM { \
    {4{36{1'b0}}}, \                             // fill remaining ROM with zeroes
    {`STOP, 16'b0, 16'b0}, \               //FINISH 
    {`ADD, 16'b0, 16'b1}, \ //ADD r0, r1 /* third instruction  */
    {`LDR, 16'd0, 16'd2}, \ //r1 <= 8'd2 /* second instruction */
    {`LDR, 16'd0, 16'd1} \ //r0 <= 8'd1  /* first instruction  */
}