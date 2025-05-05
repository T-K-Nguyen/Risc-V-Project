// File: src/memory.v
// Description: 32x8-bit Memory for RISC CPU
`timescale 1ns/1ps

module memory (
    input  wire        clk,       // Clock input (rising edge)
    input  wire [4:0]  addr,      // 5-bit address
    input  wire [7:0]  data_in,   // 8-bit input data
    output reg  [7:0]  data_out,  // 8-bit output data
    input  wire        rd,        // Read enable
    input  wire        wr         // Write enable
);

    reg [7:0] mem [0:31];  // 32x8-bit memory array

    always @(posedge clk) begin
        if (wr && !rd) begin
            mem[addr] <= data_in;  // Write data
        end
        if (rd && !wr) begin
            data_out <= mem[addr]; // Read data
        end
    end

endmodule