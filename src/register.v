// File: src/register.v
// Description: 8-bit Accumulator for RISC CPU

module register (
    input  wire        clk,    // Clock input (rising edge)
    input  wire        rst,    // Synchronous reset (high-active)
    input  wire        load,   // Load enable
    input  wire [7:0]  in,     // 8-bit input
    output reg  [7:0]  out     // 8-bit output
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 8'b0;       // Reset to 0
        else if (load)
            out <= in;         // Load input
    end

endmodule