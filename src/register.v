// File: src/register.v
// Description: 8-bit Accumulator for RISC CPU
`timescale 1ns/1ps

module register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] in,
    output reg [7:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 8'b0;
        else if (load)
            out <= in;
    end
endmodule