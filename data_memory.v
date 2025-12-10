`timescale 1ns / 1ps

module data_memory(
    input  wire        clk,
    input  wire        MemRead,
    input  wire        MemWrite,
    input  wire [31:0] Address,     // Byte address from ALU
    input  wire [31:0] Write_data,
    output reg  [31:0] Read_data
);

    reg [31:0] mem [0:255];
    wire [7:0] word_addr = Address[31:2];
    
    initial begin
        $readmemb("data.mem", mem);
    end
    
    always @(posedge clk) begin
        if (MemWrite)
            mem[word_addr] <= Write_data;
        end
        
    always @(*) begin
        if (MemRead)
            Read_data = mem[word_addr];
        else
            Read_data = 32'b0;
    end

endmodule
