module program_counter_tb;
	reg clk,rst,load;
	reg [4:0] load_val;
	wire [4:0] pc;

	program_counter uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .load_val(load_val),
        .pc(pc)
    	);
    	initial begin        
        	clk = 0; rst = 1; load_val = 5'b11110; load = 1;
        	#10 rst = 0;
        	#10 load_val = 5'b00001;
        	#10 load = 1;
        	#10 ;
        	#10 load_val = 5'b00110;
        	#20 ;
        	#10 rst = 0;
        	#10 load = 0;
        	#10 load_val = 5'b00110;    
        	#10 load = 1;
        	#10 $finish;
    	end
    	always #5 clk = ~clk;
	initial begin
        	$monitor("[%0t] clk=%b rst=%b load_val=%b load=%b pc=%b", $time, clk, rst, load_val, load, pc);
    	end
endmodule