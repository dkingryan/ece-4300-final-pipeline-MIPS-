`timescale 1ns / 1ps

module control(
               input wire clk,
               input wire rst,
               input wire [5:0] opcode,   // instructions [31:26]
               output reg [1:0] wb,       // {RegWrite, MemToReg}
               output reg [2:0] mem,      // {Branch, MemRead, MemWrite}
               output reg [3:0] ex        // {RegDst, ALUOp1, ALUOp0, ALUSrc}
              );
              
              // Opcode definitions 
              localparam OP_R   = 6'b000000;  // R-format
              localparam OP_LW  = 6'b100011;  // Load Word
              localparam OP_SW  = 6'b101011;  // Store Word
              localparam OP_BEQ = 6'b000100;  // Branch Equal
              
              always @(*) begin
                case(opcode)
                    OP_R: begin
                        wb = 2'b10;
                        mem = 3'b000;
                        ex = 4'b1010;
                    end
                    
                    OP_LW: begin
                        wb = 2'b11;
                        mem = 3'b010;
                        ex = 4'b0100;
                    end
                    
                    OP_SW: begin
                        wb = 2'b00;
                        mem = 3'b001;
                        ex = 4'b0100;
                    end
                    
                    OP_BEQ: begin
                        wb = 2'b00;
                        mem = 3'b100;
                        ex = 4'b0001;
                    end
                    
                    default: begin
                        wb = 2'b00;
                        mem = 3'b000;
                        ex = 4'b0000;
                    end
                 endcase
              end
              
endmodule
