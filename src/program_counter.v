// File: src/program_counter.v
// Description: 5-bit Program Counter for RISC CPU
`timescale 1ns/1ps

module program_counter (
    input  wire        clk,
    input  wire        rst,
    input  wire        load,
    input  wire [1:0]  inc_pc,  // 2 bits: 0 = no increment, 1 = +1, 2 = +2
    input  wire [4:0]  load_val,
    output reg  [4:0]  pc
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else if (load)
            pc <= load_val;
        else if (inc_pc == 2)
            pc <= pc + 2;  // Skip next instruction
        else if (inc_pc == 1)
            pc <= pc + 1;  // Normal increment
    end
endmodule