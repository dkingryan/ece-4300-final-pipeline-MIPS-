`timescale 1ns / 1ps

module memory_tb();
    reg clk;
    reg rst;
    reg Branch;
    reg MemRead;
    reg MemWrite;
    reg [1:0] control_wb_in;   // {RegWrite, MemtoReg}

    reg [31:0] Address;         // ALU result (address)
    reg [31:0] Write_data;      // value to store
    reg [4:0] Write_reg_in;    // destination register
    reg zero;            // ALU zero flag

    wire PCSrc;           // branch control to PC mux / ID
    wire [1:0] mem_control_wb;  // to WB control mux
    wire [31:0] Read_data;       // to WB mux 1
    wire [31:0] mem_ALU_result;  // to WB mux 0
    wire [4:0] mem_Write_reg;    // to WB stage

    memory uut (
        .clk (clk),
        .rst (rst),
        .Branch (Branch),
        .MemRead (MemRead),
        .MemWrite (MemWrite),
        .control_wb_in (control_wb_in),   // {RegWrite, MemtoReg}
    
        .Address (Address),         // ALU result (address)
        .Write_data (Write_data),      // value to store
        .Write_reg_in (Write_reg_in),    // destination register
        .zero (zero),            // ALU zero flag
    
        .PCSrc (PCSrc),           // branch control to PC mux / ID
        .mem_control_wb (mem_control_wb),  // to WB control mux
        .Read_data (Read_data),       // to WB mux 1
        .mem_ALU_result (mem_ALU_result),  // to WB mux 0
        .mem_Write_reg (mem_Write_reg)    // to WB stage
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    
    // Mem Read
    rst = 1;
    Address = 32'h00000004;
    Write_data = 32'h12345678;
    Write_reg_in = 5'h02;
    control_wb_in = 2'b01;
    MemWrite = 0;
    MemRead = 1;
    Branch = 0;
    zero = 0;
    #10; 

    // Mem Write
    rst = 0;
    MemWrite = 1;
    MemRead = 0;
    #10;
    
    // Verify write by reading back
    MemWrite = 0;
    MemRead = 1;
    #10;

    // Branch
    Branch = 1;
    zero = 1;
    #10; // Check PCSrc

    $finish;
end
endmodule
