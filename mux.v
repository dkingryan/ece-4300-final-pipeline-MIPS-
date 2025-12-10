`timescale 1ns / 1ps

module mux(
           output wire [31:0] y,
           input wire [31:0] a_true,
           input wire [31:0] b_false,
           input wire sel
    );
    
       assign y = sel ? a_true : b_false;
    
endmodule