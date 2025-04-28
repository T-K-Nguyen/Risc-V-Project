module memory_tb;
    reg clk, rd, wr;
    reg [4:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    memory uut (
        .clk(clk),
        .rd(rd),
        .addr(addr),
        .wr(wr),
        .data_in(data_in),
	    .data_out(data_out)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        wr = 0; rd = 0;
        addr = 5'b00000;
        data_in = 8'h00;

        #10;
        wr = 1; rd = 0;       // Write mode
        addr = 5'b00011; 
        data_in = 8'hAA;      // Ghi 0xAA vào địa chỉ 3
        #10;
        rd = 1; wr = 0;       // Read mode
        addr = 5'b00011;
        #10;
        
        #10;
        wr = 1; rd = 0;       // Write mode
        addr = 5'b00110; 
        data_in = 8'b10101011;
        
        
        #10;                    
        rd = 1; wr = 0;
        addr = 5'b00110;
        #10;
        #10;
        #10 $finish;
    end
    initial begin
        $monitor("[%0t] clk=%b wr=%b rd=%b addr=%b data_in=%h data_out=%h", 
                 $time, clk, wr, rd, addr, data_in, data_out);
    end
endmodule