// File: src/program_counter.v
// Description: 5-bit Program Counter for RISC CPU

module program_counter (
    input  wire        clk,        // Clock input (rising edge)
    input  wire        rst,        // Synchronous reset (high-active)
    input  wire        load,       // Load enable
    input  wire [4:0]  load_val,   // Value to load
    output reg  [4:0]  pc          // Program Counter output
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 5'b0;            // Reset to 0
        else if (load)
            pc <= load_val;        // Load specified value
        else
            pc <= pc + 1;          // Increment
    end

endmodule