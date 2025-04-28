module risc_cpu_tb;
    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [7:0] data_out;

    // Instantiate the RISC CPU module
    risc_cpu uut (
        .clk(clk),
        .rst(rst),
        .data_out(data_out)
    );

    // Generate clock signal
    always #5 clk = ~clk;  // Toggle clk every 5 time units

    // Initialize the signals
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;

        // Monitor the outputs
        $monitor("Time: %0t | clk = %b, rst = %b, data_out = %h", $time, clk, rst, data_out);

        // Apply reset
        rst = 1;   // Assert reset
        #10;       // Wait for 10 time units
        rst = 0;   // Deassert reset

        #10;
        
        #100; 
        $finish;
    end
endmodule