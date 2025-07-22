`include "opcodes.vh"

// READ PROGRAM FROM BOTTOM -> TOP! (using little-endian format)
`define ROM { \
    {80{1'b0}}, \                             // fill remaining ROM with zeroes
    {`STOP, 8'b0, 8'b0}, \               //FINISH 
    {`ADD, 8'b0000_0000, 8'b0000_0001}, \ //ADD r0, r1 /* third instruction  */
    {`LDR, 8'b0000_0001, 8'b0000_0010}, \ //r0 <= 8'd2 /* second instruction */
    {`LDR, 8'b0000_0000, 8'b0000_0001} \ //r0 <= 8'd1  /* first instruction  */
}