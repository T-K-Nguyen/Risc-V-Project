// File: src/controller.v
// Description: Controller for RISC CPU with 8 states
// Includes defines.v for opcode and state constants

`timescale 1ns/1ps
`include "src/defines.v"

module controller (
    input wire        clk,
    input wire        rst,
    input wire [2:0]  opcode,
    input wire        zero,
    output reg        sel,
    output reg        rd,
    output reg        ld_ir,
    output reg        halt,
    output reg [1:0]  inc_pc,
    output reg        ld_ac,
    output reg        ld_pc,
    output reg        wr,
    output reg        data_e,
    output reg [2:0] state
);

    reg skip_next;

    // Sequential logic (partial)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sel <= 0; rd <= 0; ld_ir <= 0; halt <= 0;
            inc_pc <= 0; ld_ac <= 0; ld_pc <= 0; wr <= 0; data_e <= 0;
            skip_next <= 0;
            state <= `STATE_INST_ADDR;
        end else if (halt) begin
            rd <= 0; ld_ir <= 0; inc_pc <= 0;
        end else begin
            case (state)
                `STATE_INST_ADDR: state <= `STATE_INST_FETCH;
                `STATE_INST_FETCH: state <= `STATE_INST_LOAD;
                `STATE_INST_LOAD: state <= `STATE_OP_ADDR;
                `STATE_OP_ADDR: state <= `STATE_OP_FETCH;
                `STATE_OP_FETCH: state <= `STATE_ALU_OP;
                `STATE_ALU_OP: state <= `STATE_STORE;
                `STATE_STORE: state <= `STATE_NEXT;
                `STATE_NEXT: begin
                    if (skip_next) state <= `STATE_INST_ADDR; // Skip next instruction
                    else state <= `STATE_INST_ADDR; // Normal progression
                end
                default: state <= `STATE_INST_ADDR; // Reset to initial state if undefined
            endcase

            // Handle opcode-specific logic
            case (state)
                `STATE_ALU_OP: begin
                    ld_ac <= (opcode == `OPCODE_ADD || opcode == `OPCODE_AND ||
                            opcode == `OPCODE_XOR || opcode == `OPCODE_LDA);
                    skip_next <= (opcode == `OPCODE_SKZ && zero);
                    ld_pc <= (opcode == `OPCODE_JMP);
                    if (opcode == `OPCODE_SKZ)
                        $display("SKZ: zero=%b, skip_next=%b at time %t", zero, (opcode == `OPCODE_SKZ && zero), $time);
                end
                `STATE_STORE: begin
                    ld_ac <= 0;
                end
                default: begin
                    ld_ac <= 0;
                    skip_next <= 0;
                end
            endcase
        end
    end

    // Combinational logic (partial)
    always @(*) begin
        sel = 0; rd = 0; ld_ir = 0; halt = 0; inc_pc = 0;
        ld_pc = 0; wr = 0; data_e = 0;

        halt = (opcode == `OPCODE_HLT);

        case (state)
            `STATE_INST_ADDR: begin
                sel = 1;
            end
            `STATE_INST_FETCH: begin
                sel = 1;
                rd = 1;
            end
            `STATE_INST_LOAD: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
            end
            `STATE_OP_ADDR: begin
                sel = 0;
            end
            `STATE_OP_FETCH: begin
                sel = 0;
                rd = 1;
            end
            `STATE_ALU_OP: begin
                ld_pc = (opcode == `OPCODE_JMP);
            end
            `STATE_STORE: begin
                wr = (opcode == `OPCODE_STO);
                data_e = (opcode == `OPCODE_STO);
                sel = 0;
            end
            `STATE_NEXT: begin
                if (skip_next) begin
                    inc_pc = 2;
                    $display("SKZ: Skipping next instruction, inc_pc set to 2 at time %t", $time);
                end else if (!halt) begin
                    inc_pc = 1; // Ensure PC increments for valid instructions
                end
            end
            default: begin
                halt = 1; // Halt on undefined state as a fallback
            end
        endcase
    end

endmodule