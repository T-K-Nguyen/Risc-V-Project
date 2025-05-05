// File: src/program_counter.v
// Description: 5-bit Program Counter for RISC CPU
`timescale 1ns/1ps

module program_counter (
    input wire clk,
    input wire rst,
    input wire load,
    input wire inc_pc,  // Add inc_pc input
    input wire [4:0] load_val,
    output reg [4:0] pc
);

always @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 5'b0;
    else if (load)
        pc <= load_val;
    else if (inc_pc)
        pc <= pc + 1;
end
endmodule