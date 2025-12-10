`timescale 1ns / 1ps

module incrementer(
                    input wire clk,
                    input wire rst,
                    input wire [31:0] pcin,
                    output [31:0] pcout
                );
    
                assign pcout = pcin + 32'd4;
                
endmodule
