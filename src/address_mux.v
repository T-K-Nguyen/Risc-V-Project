// File: src/address_mux.v
// Description: 5-bit Address Mux for RISC CPU

module address_mux #(
    parameter WIDTH = 5
) (
    input  wire             sel,        // Select: 1=instruction, 0=operand
    input  wire [WIDTH-1:0] inst_addr,  // Instruction address (from PC)
    input  wire [WIDTH-1:0] op_addr,    // Operand address (from instruction)
    output wire [WIDTH-1:0] addr        // Selected address
);

    assign addr = sel ? inst_addr : op_addr;

endmodule