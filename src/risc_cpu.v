// File: src/risc_cpu.v
// Description: Top-level RISC CPU module
// Includes defines.v for opcode constants

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
    output wire [7:0]  data_out    // Accumulator output
);

    // Internal signals
    wire [4:0] pc;                // Program Counter
    wire [4:0] addr;              // Memory address
    wire [7:0] alu_out;           // ALU output
    wire [7:0] reg_out;           // Accumulator output
    wire [7:0] mem_out;           // Memory output
    wire [2:0] opcode;            // 3-bit opcode
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e, zero;

    // Module instantiations
    program_counter pc0 (
        .clk(clk),
        .rst(rst),
        .load(ld_pc),
        .load_val(mem_out[4:0]),  // Jump address from memory
        .pc(pc)
    );

    address_mux mux0 (
        .sel(sel),
        .inst_addr(pc),
        .op_addr(mem_out[4:0]),   // Operand address from instruction
        .addr(addr)
    );

    alu alu0 (
        .opcode(opcode),
        .inA(reg_out),
        .inB(mem_out),
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
        .data_e(data_e)
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
        .data_in(reg_out),
        .data_out(mem_out),
        .rd(rd),
        .wr(wr)
    );

    // Instruction register (simplified)
    reg [7:0] ir;  // Instruction register
    always @(posedge clk or posedge rst) begin
        if (rst)
            ir <= 8'b0;
        else if (ld_ir)
            ir <= mem_out;
    end

    // Extract opcode from instruction
    assign opcode = ir[7:5];  // 3-bit opcode (bits 7:5)
    assign data_out = reg_out; // Output Accumulator

endmodule