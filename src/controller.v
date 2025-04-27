// File: src/controller.v
// Description: Controller for RISC CPU with 8 states
// Includes defines.v for opcode and state constants

`include "src/defines.v"

module controller (
    input  wire        clk,        // Clock input (rising edge)
    input  wire        rst,        // Synchronous reset (high-active)
    input  wire [2:0]  opcode,     // 3-bit opcode
    input  wire        zero,       // Zero flag from ALU
    output reg         sel,        // Address Mux select
    output reg         rd,         // Memory read enable
    output reg         ld_ir,      // Load instruction register
    output reg         halt,       // Halt CPU
    output reg         inc_pc,     // Increment Program Counter
    output reg         ld_ac,      // Load Accumulator
    output reg         ld_pc,      // Load Program Counter
    output reg         wr,         // Memory write enable
    output reg         data_e      // Data enable
);

    reg [2:0] state;  // Current state (3-bit)

    // State transition (sequential)
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= `STATE_INST_ADDR;  // Reset to INST_ADDR
        else
            state <= (state == `STATE_STORE) ? `STATE_INST_ADDR : state + 1;
    end

    // Output logic (combinational)
    always @(*) begin
        // Default outputs
        sel = 0; rd = 0; ld_ir = 0; halt = 0; inc_pc = 0;
        ld_ac = 0; ld_pc = 0; wr = 0; data_e = 0;

        case (state)
            `STATE_INST_ADDR: begin
                sel = 1;  // Select PC address
            end
            `STATE_INST_FETCH: begin
                sel = 1;
                rd = 1;   // Read instruction
            end
            `STATE_INST_LOAD: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;  // Load instruction
            end
            `STATE_IDLE: begin
                sel = 1;
            end
            `STATE_OP_ADDR: begin
                sel = 0;  // Select operand address
            end
            `STATE_OP_FETCH: begin
                sel = 0;
            end
            `STATE_ALU_OP: begin
                rd = (opcode == `OPCODE_ADD || opcode == `OPCODE_AND ||
                      opcode == `OPCODE_XOR || opcode == `OPCODE_LDA);
                inc_pc = !(opcode == `OPCODE_SKZ && zero);  // Skip if zero
                ld_ac = (opcode == `OPCODE_ADD || opcode == `OPCODE_AND ||
                         opcode == `OPCODE_XOR || opcode == `OPCODE_LDA);
                ld_pc = (opcode == `OPCODE_JMP);  // Load PC for jump
            end
            `STATE_STORE: begin
                wr = (opcode == `OPCODE_STO);     // Write for store
                data_e = (opcode == `OPCODE_STO); // Enable data output
            end
        endcase
    end

endmodule