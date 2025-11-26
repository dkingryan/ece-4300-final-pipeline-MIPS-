`timescale 1ns / 1ps

module mips_tb;

    // DUT inputs
    reg clk;
    reg rst;

    // Instantiate the DUT
    MIPS dut (
        .clk (clk),
        .rst (rst)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;   // 5 ns high, 5 ns low
    end

    integer cycle;

    initial begin
        // Apply reset
        rst = 1'b1;
        #20;
        rst = 1'b0;

        // Run for 24 clock cycles
        for (cycle = 0; cycle < 24; cycle = cycle + 1) begin
            @(posedge clk);

         $display("Cycle %0d | IF/ID instr=%b npc=%0d | ID/EX rdata1=%0d rdata2=%0d | EX alu_result=%0d | MEM ReadData=%0d ALUResult=%0d | WB WriteData=%0d",
         cycle,
         dut.if_id_instr,
         dut.if_id_npc,
         dut.id_ex_readdat1,
         dut.id_ex_readdat2,
         dut.alu_result,
         dut.mem_Read_data,
         dut.mem_ALU_result,
         dut.wb_WriteData);

        end

        $finish;
    end

endmodule
