// File: src/memory.v
// Description: 32x8-bit Memory for RISC CPU
`timescale 1ns/1ps

module memory (
    input  wire        clk,
    input  wire        rst,
    input  wire [4:0]  addr,
    input  wire [7:0]  data_in,
    output reg  [7:0]  data_out,
    input  wire        rd,
    input  wire        wr
);
    reg [7:0] mem [0:31];

    always @(posedge clk) begin
        if (rst) begin
            $readmemh("tb/test_programs/test3.mem", mem);
        end
    end


    // Combinational read
    always @(*) begin
        if (rd)
            data_out = mem[addr];
        else
            data_out = 8'b0;
    end

    // Synchronous write
    always @(posedge clk) begin
        if (wr)
            mem[addr] <= data_in;
    end
endmodule