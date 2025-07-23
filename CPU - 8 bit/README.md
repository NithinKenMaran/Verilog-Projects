# Overview

This is an 8-bit CPU that I built, to practice my coursework knowledge from Microprocessors and Digital Systems.

- Each instruction is 20 bits long: 4-bit op-code, and two 8-bit operands.
- Instructions are stored in a 160-bit program memory, with a maximum of 8 instructions.
- The CPU is a state-machine, alternating between `FETCH` -> `DECODE` -> `EXECUTE`, till a `STOP` command is received.
- `control_unit.v` serves as the top-most module for this CPU.
- The internal 8-bit register file and the program counter are exposed, for easy debugging.

# Compile & Execute

```bash
iverilog -o out -f build/compile_list.txt
vvp out
```

# Programming

I've defined a minimal ISA in `header/opcodes.vh`:

```verilog
`define ADD 4'b0001
`define SUB 4'b0010
`define AND 4'b0011
`define OR 4'b0100
`define XOR 4'b0101
`define LDR 4'b0110
`define STOP 4'b1111
```

Use this ISA to write a program in `header/program.vh`. An example program that loads and adds 2 numbers, is shown here:

```verilog
`include "opcodes.vh"

// READ FROM BOTTOM -> TOP! 
`define ROM { \
    {80{1'b0}}, \                             // fill remaining ROM with zeroes
    {`STOP, 8'b0, 8'b0}, \               //FINISH 
    {`ADD, 8'b0000_0000, 8'b0000_0001}, \ //ADD r0, r1 /* third instruction  */
    {`LDR, 8'b0000_0001, 8'b0000_0010}, \ //r0 <= 8'd2 /* second instruction */
    {`LDR, 8'b0000_0000, 8'b0000_0001} \ //r0 <= 8'd1  /* first instruction  */
}
```

# Output

The above program, when tested with a simple testbench, gives the following output. Follow the changes in `r0` & `r1`, with the change in `pc` (Program Counter).

```
Time: 0 | State: 0 | r0=x r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = x
Time: 15000 | State: 1 | r0=x r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 0
Time: 45000 | State: 2 | r0=x r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 1
Time: 65000 | State: 3 | r0=x r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 1
Time: 75000 | State: 3 | r0=1 r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 1
Time: 85000 | State: 1 | r0=1 r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 1
Time: 115000 | State: 2 | r0=1 r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 2
Time: 135000 | State: 3 | r0=1 r1=x r2=x r3=x r4=x r5=x r6=x r7=x | pc = 2
Time: 145000 | State: 3 | r0=1 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 2
Time: 155000 | State: 1 | r0=1 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 2
Time: 185000 | State: 2 | r0=1 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 3
Time: 205000 | State: 3 | r0=1 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 3
Time: 215000 | State: 3 | r0=3 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 3
Time: 225000 | State: 1 | r0=3 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 3
Time: 255000 | State: 2 | r0=3 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 4
Time: 275000 | State: 4 | r0=3 r1=2 r2=x r3=x r4=x r5=x r6=x r7=x | pc = 4

Program halted. Final Register File:
r0=3 r1=2 r2=x r3=x
r4=x r5=x r6=x r7=x
testbench.v:41: $finish called at 285000 (1ps)
```

Refer to my `testbench.v` for a minimal testbench that monitors the register file and program counter. For the most part, all debugging can be done with just these two. 
