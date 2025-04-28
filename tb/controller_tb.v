module controller_tb;
    reg clk, rst, zero;
    reg [2:0] opcode;
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;

    controller uut (
        .opcode(opcode),
        .clk(clk),
        .zero(zero),
        .rst(rst),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .halt(halt),
        .inc_pc(inc_pc),
        .ld_ac(ld_ac),
        .ld_pc(wr),
        .data_e(data_e)
    );

    initial begin
	rst = 1; opcode = 3'b000; zero = 0;
        #10 rst = 0;
        // Test ADD operation
        opcode = `OPCODE_ADD;
        zero = 0;
        // Run enough clock cycles
        #100;
        // Test SKZ (skip if zero) operation
        opcode = `OPCODE_SKZ;
        zero = 1; // Simulate zero flag = 1
        #100;
        // Test JMP operation
        opcode = `OPCODE_JMP;
        zero = 0;
        #100;
        // Test STO (store) operation
        opcode = `OPCODE_STO;
        zero = 0;
        #100;
        $finish;
    end
    initial begin
	$monitor(
            "[%0t] clk=%b rst=%b opcode=%03b zero=%b | sel=%b rd=%b ld_ir=%b halt=%b inc_pc=%b ld_ac=%b ld_pc=%b wr=%b data_e=%b",
            $time, clk, rst, opcode, zero, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
        );
    end

endmodule