
// Description: Testbench for RISC CPU module
`timescale 1ns/1ps
`include "src/risc_cpu.v"

module tb_risc_cpu;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [7:0] data_out;

    // Instantiate RISC CPU
    risc_cpu uut (
        .clk(clk),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period (100 MHz)
    end

    // Test stimulus
    initial begin
        // Reset
        rst = 1;
        #20;
        rst = 0;

        // Load memory with test1.mem or test2.mem
        // Comment/uncomment to switch between test programs
        //$readmemb("tb/test_programs/test1.mem", uut.mem0.mem);  // For test1.mem
        $readmemb("tb/test_programs/test2.mem", uut.mem0.mem);  // For test2.mem

        // Run simulation for a fixed time
        #1000;

        // Check results
        $display("Final Accumulator value: %h", data_out);
        $display("Memory at address 7: %h", uut.mem0.mem[7]);  // For test1.mem
        $finish;
    end

    //debug purposes
    initial begin
        $monitor("Time=%0t rst=%b clk=%b PC=%d State=%d IR=%h Opcode=%b Wr=%b Data_e=%b Sel=%b Addr=%h Data_in=%h Data_reg=%h Accumulator=%h Mem[7]=%h Ld_ac=%b Alu_out=%h",
            $time, rst, clk, uut.pc, uut.ctrl0.state, uut.ir, uut.opcode, uut.wr,
            uut.data_e, uut.sel, uut.addr, uut.data_in_out, uut.data_reg,
            data_out, uut.mem0.mem[7], uut.ctrl0.ld_ac, uut.alu0.out);   
    end
    
    // Dump waveform for Cadence
    initial begin
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, tb_risc_cpu);
    end

endmodule