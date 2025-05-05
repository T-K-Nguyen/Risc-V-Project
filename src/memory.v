// File: src/memory.v
// Description: 32x8-bit Memory for RISC CPU
`timescale 1ns/1ps

module memory (
    input wire clk,
    input wire [4:0] addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire rd,
    input wire wr
);
    reg [7:0] mem [0:31];

    initial begin
        $readmemh("test1.mem", mem);  // Load memory from file
    end

    always @(posedge clk) begin
        if (wr)
            mem[addr] <= data_in;
        if (rd)
            data_out <= mem[addr];  // Synchronous read
    end
endmodule