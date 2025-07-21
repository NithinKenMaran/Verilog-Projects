`timescale 1ns / 1ps

module testbench;

reg clk;

// instantiations //
wire [2:0] state;
wire [63:0] reg_file;

control_unit uut (
    .clk(clk),
    .cpu_state(state),
    .reg_file_out(reg_file)
);

// clock //
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
end

// Monitor state and register file
initial begin
    $monitor("Time: %0t | State: %0d | r0=%0d r1=%0d r2=%0d r3=%0d r4=%0d r5=%0d r6=%0d r7=%0d",
             $time, state,
             reg_file[7:0], reg_file[15:8], reg_file[23:16], reg_file[31:24],
             reg_file[39:32], reg_file[47:40], reg_file[55:48], reg_file[63:56]);
end

always @(posedge clk) begin
    if (state == 3'd4) begin // FINISH
        $display("\nProgram halted. Final Register File:");
        $display("r0=%0d r1=%0d r2=%0d r3=%0d", reg_file[7:0], reg_file[15:8],
                                               reg_file[23:16], reg_file[31:24]);
        $display("r4=%0d r5=%0d r6=%0d r7=%0d", reg_file[39:32], reg_file[47:40],
                                               reg_file[55:48], reg_file[63:56]);
        $finish;
    end
end

endmodule
