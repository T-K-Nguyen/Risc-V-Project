module register_tb;
	reg clk, rst, load;
	reg [7:0] in;
	wire[7:0] out;
	register uut(
	.clk(clk),
	.rst(rst),
	.load(load),
	.in(in),
	.out(out)
	);
	always #5 clk = ~clk;
	initial begin
		clk = 0;
       		in = 8'hAA; #5 clk = 1; #5 clk = 0;
       		#5 load = 1;
		in = 8'hAC; #5 rst = 1; #5 clk = 1;
		#10 rst = 0;
		#10 in = 8'hAB; #5 clk = 1; #5 clk = 0;
		#10		
        	$finish;
	end
	initial begin
        	$monitor("[%0t] clk=%b rst=%b load=%b in=%h out=%h", 
                 $time, clk, rst, load, in, out);
    	end
endmodule
	