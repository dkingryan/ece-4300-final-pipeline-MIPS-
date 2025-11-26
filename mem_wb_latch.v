`timescale 1ns / 1ps

module mem_wb_latch(
                    input  wire clk,
                    input  wire reset,
                
                    // control from EX/MEM
                    input wire [1:0] control_wb_in,   // {RegWrite, MemtoReg}
                
                    // datapath from MEM stage
                    input wire [31:0] Read_data_in,    // data memory output
                    input wire [31:0] ALU_result_in,   // ALU result from EX
                    input wire [4:0] Write_reg_in,    // destination reg from EX
                
                    // latched outputs to WB stage
                    output reg [1:0] mem_control_wb,
                    output reg [31:0] Read_data,
                    output reg [31:0] mem_ALU_result,
                    output reg [4:0] mem_Write_reg
                    );
                    
                    always @(posedge clk or posedge reset) begin
                        if (reset) begin
                            mem_control_wb <= 2'b0;
                            Read_data      <= 32'b0;
                            mem_ALU_result <= 32'b0;
                            mem_Write_reg  <= 5'b0;
                        end else begin
                            mem_control_wb <= control_wb_in;
                            Read_data      <= Read_data_in;
                            mem_ALU_result <= ALU_result_in;
                            mem_Write_reg  <= Write_reg_in;
                        end
                    end
endmodule
