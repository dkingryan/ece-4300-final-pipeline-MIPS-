`timescale 1ns / 1ps

module instrMem(
    input  wire clk,
    input  wire rst,
    input  wire [31:0] addr,
    output [31:0] data
);

    reg [31:0] mem [0:255];
    
    initial begin
        $readmemb("instructions.mem", mem);
     end
     
     assign data = mem[addr[31:2]];
    
endmodule

