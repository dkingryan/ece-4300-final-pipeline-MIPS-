`timescale 1ns / 1ps

module fetch(
            input wire clk,
            input wire rst,
            input wire ex_mem_pc_src,
            input wire [31:0] ex_mem_npc,
            output wire [31:0] if_id_instr,
            output wire [31:0] if_id_npc
            );
            
            //internal
            wire [31:0] pc_out, pc_mux, next_pc, instr_data;
            
            //Select next PC: branch target (sel=1) or sequential (sel=0)
            mux m0(
                    .y       (pc_mux),
                    .a_true  (ex_mem_npc), // when ex_mem_pc_src == 1
                    .b_false (next_pc),    // when ex_mem_pc_src == 0
                    .sel     (ex_mem_pc_src)
                  );
            
            // PC register   
            pc pc0(
                    .clk   (clk),
                    .rst   (rst),
                    .pc_in  (pc_mux),
                    .pc_out (pc_out)
                  );
            
            // Increment PC by 1
            incrementer in0(
                            .clk   (clk),
                            .rst   (rst),
                            .pcin  (pc_out),
                            .pcout (next_pc)
                           );
            
            // Instruction memory read at current PC
            instrMem inMem0(
                            .clk  (clk),
                            .rst  (rst),
                            .addr (pc_out),
                            .data (instr_data)
                           );

            // IF/ID pipeline latch
            ifIdLatch ifIdLatch0(
                                 .clk       (clk),
                                 .rst       (rst),
                                 .pc_in     (next_pc),      
                                 .instr_in  (instr_data),
                                 .pc_out    (if_id_npc),
                                 .instr_out (if_id_instr)
                                );
           
endmodule