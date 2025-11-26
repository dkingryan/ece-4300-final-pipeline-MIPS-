`timescale 1ns / 1ps

module regfile(
                input wire clk, 
                input wire rst,
                input wire regwrite,
                input wire [4:0] rs,            // Read register 1
                input wire [4:0] rt,            // Read register 2
                input wire [4:0] rd,            // Write register
                input wire [31:0] writedata,    // Data to write
                output reg [31:0] A_readdat1,   // Data read from rs
                output reg [31:0] B_readdat2    //Data read from rt
                
               );
               
               reg [31:0] rf [31:0];
               integer i;
               
               initial begin
                    for(i = 0; i < 32; i = i + 1)
                        rf[i] = 32'b0;
               end
               
               always @(posedge clk or posedge rst) begin
                    if (rst) begin
                        for(i = 0; i < 32; i = i + 1)
                            rf[i] = 32'b0;
                        A_readdat1 <= 32'b0;
                        B_readdat2 <= 32'b0;
                    end
                    else begin
                        if(regwrite == 1'b1) begin
                            rf[rd] <= writedata;
                        end
                        else begin
                            if (rs == 5'd0) A_readdat1 <= 32'b0;
                            else A_readdat1 <= rf[rs];
                            
                            if(rt == 5'd0) B_readdat2 <= 32'b0;
                            else B_readdat2 <= rf[rt];
                            
                        end
                    end
               end
                  
endmodule
