`timescale 1ns / 1ps

module top_mux(
                output wire [31:0] y, // output of mux is 32 bit "b" wire
                input wire [31:0] a, 
                input wire [31:0] b, // input a = 1'b1, b = 1'b0
                input wire alusrc
                );
                
                assign y = alusrc ? a : b;

endmodule