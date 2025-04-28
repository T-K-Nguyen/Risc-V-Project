module alu_tb;
    reg [2:0] opcode;
    reg [7:0] inA, inB;
    wire [7:0] out;
    wire is_zero;
    alu uut (
        .opcode(opcode),
        .inA(inA),
        .inB(inB),
        .out(out),
        .is_zero(is_zero)
    );
    initial begin
        inA = 8'b00000000; inB = 8'b11111111;
        #10 opcode = `OPCODE_HLT;
        #10 opcode = `OPCODE_SKZ;
        #10 opcode = `OPCODE_ADD;
        #10 opcode = `OPCODE_AND;
        #10 opcode = `OPCODE_XOR;
        #10 opcode = `OPCODE_LDA;
        #10 opcode = `OPCODE_STO;
        #10 opcode = `OPCODE_JMP;
        #10 inA = 8'b10000000; inB = 8'b11111111;
        #10 opcode = `OPCODE_HLT;
        #10 opcode = `OPCODE_SKZ;
        #10 opcode = `OPCODE_ADD;
        #10 opcode = `OPCODE_AND;
        #10 opcode = `OPCODE_XOR;
        #10 opcode = `OPCODE_LDA;
        #10 opcode = `OPCODE_STO;
        #10 opcode = `OPCODE_JMP;
        #1000 $finish;
    end
    initial begin
        $monitor("Time=%0t | inA=%b | inB=%b | opcode=%b | out=%b | is_zero=%b", 
$time, inA, inB, opcode, out, is_zero);
    end
endmodule