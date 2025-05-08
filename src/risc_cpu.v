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
    wire sel, rd, ld_ir, halt, ld_ac, ld_pc, wr, data_e, zero;

    wire [7:0] data_in;
    // Add data register to latch memory output
    reg [7:0] data_reg;
    wire [7:0] alu_inB;           // ALU input B (from data_reg)

    // Module instantiations
    wire [1:0] inc_pc;  

    // Local state wire (if not directly accessible)
    wire [2:0] state;

    // Instruction register
    reg [7:0] ir;


    program_counter pc0 (
        .clk(clk),
        .rst(rst),
        .load(ld_pc),
        .inc_pc(inc_pc),  // Now 2 bits
        .load_val(ir[4:0]),
        .pc(pc)
    );
    always @(posedge clk or posedge rst) begin
        if (rst)
            ir <= 8'b10100000;  // Non-HLT opcode
        else if (ld_ir) begin
            ir <= mem_out;
            $display("IR updated to %h (ir[4:0]=%b) at time %t", mem_out, mem_out[4:0], $time);
        end
    end

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
    always @(zero) $display("Zero signal updated to %b at time %t", zero, $time);

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
    //debug accumulator
    always @(posedge clk) begin
        if (ld_ac)
            $display("Accumulator updated to %h at time %t", alu_out, $time);
    end


    memory mem0 (
        .clk(clk),
        .addr(addr),
        .data_in(data_in),
        .data_out(mem_out),
        .rd(rd),
        .wr(wr),
        .rst(rst)
    );

    
    // always @(posedge clk or posedge rst) begin
    //     if (rst)
    //         ir <= 8'b10100000;  // Non-HLT opcode
    //     else if (ld_ir)
    //         ir <= mem_out;
    // end

    // Extract opcode
    assign opcode = ir[7:5];
    assign data_out = reg_out;

    // Data input for memory
    assign data_in = data_e ? reg_out : 8'b0;
    assign data_in_out = data_in;

    // Latch memory data one cycle after STATE_OP_FETCH
    reg [2:0] prev_state;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 8'b0;
            prev_state <= 0;
        end else begin
            prev_state <= state;
            if (state == `STATE_OP_FETCH)  // Capture during STATE_OP_FETCH
                data_reg <= mem_out;
        end
    end

    //debug data reg
    always @(posedge clk) begin
        if (state == `STATE_OP_FETCH)
            $display("STATE_OP_FETCH: mem_out=%h, Data_reg=%h at time %t", mem_out, data_reg, $time);
    end

    // Assign ALU input B from data_reg
    assign alu_inB = data_reg;

    

endmodule