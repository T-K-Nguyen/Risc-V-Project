// File: src/defines.v
// Description: Constants for RISC CPU opcodes and controller states

`ifndef DEFINES_V
`define DEFINES_V

// Opcode definitions (3-bit)
`define OPCODE_HLT  3'b000  // Halt
`define OPCODE_SKZ  3'b001  // Skip if zero
`define OPCODE_ADD  3'b010  // Add
`define OPCODE_AND  3'b011  // Bitwise AND
`define OPCODE_XOR  3'b100  // Bitwise XOR
`define OPCODE_LDA  3'b101  // Load Accumulator
`define OPCODE_STO  3'b110  // Store Accumulator
`define OPCODE_JMP  3'b111  // Jump

// Controller state encodings (3-bit)
`define STATE_INST_ADDR  3'd0  // Instruction address
`define STATE_INST_FETCH 3'd1  // Instruction fetch
`define STATE_INST_LOAD  3'd2  // Instruction load
`define STATE_IDLE       3'd3  // Idle
`define STATE_OP_ADDR    3'd4  // Operand address
`define STATE_OP_FETCH   3'd5  // Operand fetch
`define STATE_ALU_OP     3'd6  // ALU operation
`define STATE_STORE      3'd7  // Store

`endif