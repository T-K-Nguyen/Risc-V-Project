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
    output reg        inc_pc,
    output reg        ld_ac,
    output reg        ld_pc,
    output reg        wr,
    output reg        data_e
);

    reg [2:0] state;

    // State transition and sequential outputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= `STATE_INST_ADDR;
            ld_ac <= 0;  // Reset ld_ac
        end else begin
            // State transitions
            if (halt && state == `STATE_NEXT)
                state <= state;
            else
                state <= (state == `STATE_STORE) ? `STATE_NEXT :
                        (state == `STATE_NEXT) ? `STATE_INST_ADDR : state + 1;

            // Sequential control for ld_ac to ensure it holds through the clock edge
            case (state)
                `STATE_ALU_OP: begin
                    ld_ac <= (opcode == `OPCODE_ADD || opcode == `OPCODE_AND ||
                             opcode == `OPCODE_XOR || opcode == `OPCODE_LDA);
                end
                `STATE_STORE: begin
                    ld_ac <= 0;  // Clear ld_ac after ALU operation
                end
                default: begin
                    ld_ac <= 0;
                end
            endcase
        end
    end

    // Output logic (combinational)
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
                // Remove rd to avoid re-reading memory; data_reg should be used
                ld_pc = (opcode == `OPCODE_JMP);
            end
            `STATE_STORE: begin
                wr = (opcode == `OPCODE_STO);
                data_e = (opcode == `OPCODE_STO);
                sel = 0;
            end
            `STATE_NEXT: begin
                inc_pc = !halt;
            end
        endcase
    end

endmodule