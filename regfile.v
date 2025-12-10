`timescale 1ns / 1ps

module regfile(
                input wire clk, 
                input wire rst,
                input wire regwrite,
                input wire [4:0] rs,            // Read register 1
                input wire [4:0] rt,            // Read register 2
                input wire [4:0] rd,
                input wire [31:0] writedata,
                output [31:0] A_readdat1,
                output [31:0] B_readdat2
                
               );
               
                reg [31:0] rf [31:0];
                integer i;
                
                initial begin
                    for(i=0;i<32;i=i+1) rf[i]=0;
                end
            
                always @(posedge clk or posedge rst) begin
                    if(rst) begin
                        for(i=0;i<32;i=i+1) rf[i]=0;
                    end
                    else if (regwrite && rd != 0) begin
                        rf[rd] <= writedata;
                    end
                end
                
                assign A_readdat1 = (rs == 0) ? 0 : rf[rs];
                assign A_readdat2 = (rt == 0) ? 0 : rf[rt];
                  
endmodule