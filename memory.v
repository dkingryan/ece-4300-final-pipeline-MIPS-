`timescale 1ns / 1ps

module memory(
                input wire clk,
                input wire rst,
            
                // control signals from EX/MEM latch
                input wire Branch,
                input wire MemRead,
                input wire MemWrite,
                input wire [1:0] control_wb_in,   // {RegWrite, MemtoReg}
            
                // datapath from EX/MEM latch
                input wire [31:0] Address,         // ALU result (address)
                input wire [31:0] Write_data,      // value to store
                input wire [4:0] Write_reg_in,    // destination register
                input wire zero,            // ALU zero flag
            
                // outputs
                output wire PCSrc,           // branch control to PC mux / ID
                output wire [1:0] mem_control_wb,  // to WB control mux
                output wire [31:0] Read_data,       // to WB mux 1
                output wire [31:0] mem_ALU_result,  // to WB mux 0
                output wire [4:0] mem_Write_reg    // to WB stage
              ); 
              
            wire [31:0] data_mem_out;

            // Component 1: branch AND gate (Branch & zero -> PCSrc)
            and_gate and_gate0(
                .m_ctlout(Branch),
                .zero(zero),
                .PCSrc(PCSrc)
            );
        
            // Component 2: data memory
            data_memory data_memory0(
                .clk(clk),
                .MemRead(MemRead),
                .MemWrite(MemWrite),
                .Address(Address),
                .Write_data(Write_data),
                .Read_data(data_mem_out)
            );
        
            // Component 3: MEM/WB pipeline register
            mem_wb_latch mem_wb_latch0(
                .clk(clk),
                .rst (rst),
                .control_wb_in(control_wb_in),
                .Read_data_in(data_mem_out),
                .ALU_result_in(Address),
                .Write_reg_in(Write_reg_in),
                .mem_control_wb(mem_control_wb),
                .Read_data(Read_data),
                .mem_ALU_result(mem_ALU_result),
                .mem_Write_reg(mem_Write_reg)
            );

endmodule