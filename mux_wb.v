`timescale 1ns / 1ps

module mux_wb(
            input wire [31:0] mem_Read_data,   // from MEM/WB latch
            input wire [31:0] mem_ALU_result,  // from MEM/WB latch
            input wire MemtoReg,        // control: 1 -> memory, 0 -> ALU
            output wire [31:0] wb_data          // to ID register file (WriteData)
            );
            
            assign wb_data = (MemtoReg) ? mem_Read_data : mem_ALU_result;
endmodule
