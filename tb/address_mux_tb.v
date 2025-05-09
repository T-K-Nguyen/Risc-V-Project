module address_mux_tb;
    parameter WIDTH = 5;
    reg [WIDTH-1:0] inst_addr,op_addr;
    reg sel;
    wire [WIDTH-1:0] addr;

    address_mux uut (
        .inst_addr(inst_addr),
        .op_addr(op_addr),
        .sel(sel),
        .addr(addr)
    );

    initial begin
        inst_addr = 5'b10000; op_addr = 5'b11111;
        sel = 0;
        #100 sel = 0;
        #100;
        inst_addr = 5'b10010; op_addr = 5'b01001;
        #100 sel = 1;
        #100 ;
        #100 sel = 0;
        #100 $finish;
        
    end
    initial begin
        $monitor("Time=%0t | addr=%b ", $time, addr);
    end
endmodule