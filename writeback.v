`timescale 1ns / 1ps

module writeback(
                // Inputs from MEM/WB latch
                input  wire [31:0] mem_Read_data,    // memory read data
                input  wire [31:0] mem_ALU_result,   // ALU result
                input  wire        MemtoReg,         // control signal from MEM/WB
            
                // Output to register file in ID stage
                output wire [31:0] WriteData         // data to be written back
                );
                
                mux_wb mux_wb0 (
                                .mem_Read_data (mem_Read_data),
                                .mem_ALU_result(mem_ALU_result),
                                .MemtoReg      (MemtoReg),
                                .wb_data       (WriteData)
                               );

endmodule