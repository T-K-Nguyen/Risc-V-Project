// File: src/risc_cpu.v
// Description: Top-level RISC CPU module
// Includes defines.v for opcode constants
`timescale 1ns/1ps

`include "src/defines.v"
`include "src/program_counter.v"
`include "src/address_mux.v"
`include "src/alu.v"
`include "src/controller.v"
`include "src/register.v"
`include "src/memory.v"

module risc_cpu (
    input  wire        clk,        // Clock input
    input  wire        rst,        // Reset input
    output wire [7:0]  data_out,   // Accumulator output
    output wire [7:0]  data_in_out // Expose data_in for monitoring
);

    // Internal signals
    wire [4:0] pc;                // Program Counter
    wire [4:0] addr;              // Memory address
    wire [7:0] alu_out;           // ALU output
    wire [7:0] reg_out;           // Accumulator output
    wire [7:0] mem_out;           // Memory output
    wire [2:0] opcode;            // 3-bit opcode
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e, zero;

    // Add data register to latch memory output
    reg [7:0] data_reg;
    wire [7:0] alu_inB;           // ALU input B (from data_reg)

    // Module instantiations
    program_counter pc0 (
        .clk(clk),
        .rst(rst),
        .load(ld_pc),
        .inc_pc(inc_pc),
        .load_val(mem_out[4:0]),
        .pc(pc)
    );

    address_mux mux0 (
        .sel(sel),
        .inst_addr(pc),
        .op_addr(ir[4:0]),
        .addr(addr)
    );

    alu alu0 (
        .opcode(opcode),
        .inA(reg_out),
        .inB(alu_inB),
        .out(alu_out),
        .is_zero(zero)
    );

    controller ctrl0 (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .zero(zero),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .halt(halt),
        .inc_pc(inc_pc),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .wr(wr),
        .data_e(data_e),
        .state(state)  // Add state output
    );

    register reg0 (
        .clk(clk),
        .rst(rst),
        .load(ld_ac),
        .in(alu_out),
        .out(reg_out)
    );

    memory mem0 (
        .clk(clk),
        .addr(addr),
        .data_in(data_in),
        .data_out(mem_out),
        .rd(rd),
        .wr(wr)
    );

    // Instruction register
    reg [7:0] ir;
    always @(posedge clk or posedge rst) begin
        if (rst)
            ir <= 8'b10100000;  // Non-HLT opcode
        else if (ld_ir)
            ir <= mem_out;
    end

    // Extract opcode
    assign opcode = ir[7:5];
    assign data_out = reg_out;

    // Data input for memory
    wire [7:0] data_in = data_e ? reg_out : 8'b0;
    assign data_in_out = data_in;

    // Latch memory data one cycle after STATE_OP_FETCH
    reg [2:0] prev_state;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 8'b0;
            prev_state <= 0;
        end else begin
            prev_state <= state;
            if (prev_state == `STATE_OP_FETCH)
                data_reg <= mem_out;  // Latch after fetch
        end
    end

    // Assign ALU input B from data_reg
    assign alu_inB = data_reg;

    // Local state wire (if not directly accessible)
    wire [2:0] state;

endmodule