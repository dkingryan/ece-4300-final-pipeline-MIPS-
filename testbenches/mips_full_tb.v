`timescale 1ns / 1ps

module mips_pipeline_tb;
    reg clk;
    reg rst;

    mips uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        rst = 1;
        #10 rst = 0;

        #200 $finish;
    end
    
    
endmodule
