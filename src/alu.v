// File: src/alu.v
// Description: ALU for RISC CPU with 8 operations
// Includes defines.v for opcode constants
`timescale 1ns/1ps
`include "src/defines.v"

module alu (
    input  wire [2:0] opcode,    // 3-bit opcode
    input  wire [7:0]  inA,       // 8-bit input A (Accumulator)
    input  wire [7:0]  inB,       // 8-bit input B (Memory)
    output reg  [7:0]  out,       // 8-bit output
    output wire   is_zero    // Asynchronous zero flag
);
    // Combinational ALU operations
    always @(*) begin
        case (opcode)
            `OPCODE_HLT:  out = inA;                // Halt: pass inA
            `OPCODE_SKZ:  out = inA;                // Skip if zero: pass inA
            `OPCODE_ADD:  out = inA + inB;          // Add
            `OPCODE_AND:  out = inA & inB;          // Bitwise AND
            `OPCODE_XOR:  out = inA ^ inB;          // Bitwise XOR
            `OPCODE_LDA:  out = inB;                // Load Accumulator
            `OPCODE_STO:  out = inA;                // Store: pass inA
            `OPCODE_JMP:  out = inA;                // Jump: pass inA
            default:      out = 8'b0;               // Default: 0
        endcase
    end

    assign is_zero = (out == 8'b0);
endmodule