`timescale 1ns / 1ps

module mips(
    input  wire clk,
    input  wire rst
);

    // IF <-> ID
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // ID <-> EX
    wire [1:0] id_ex_wb;
    wire [2:0] id_ex_mem;
    wire [3:0] id_ex_execute;
    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;
    wire [4:0] id_ex_instr_bits_20_16;
    wire [4:0] id_ex_instr_bits_15_11;
    wire [5:0] id_ex_instr_bits_5_0;

    // EX <-> MEM
    wire [1:0] ex_mem_wb_ctlout;
    wire branch;
    wire memread;
    wire memwrite;
    wire [31:0] ex_mem_npc;
    wire zero;
    wire [31:0] alu_result;
    wire [31:0] rdata2out;
    wire [4:0] five_bit_muxout;

    // MEM <-> WB
    wire PCSrc;
    wire [1:0] mem_control_wb;   // {RegWrite, MemtoReg}
    wire [31:0] mem_Read_data;
    wire [31:0] mem_ALU_result;
    wire [4:0] mem_Write_reg;

    // WB -> ID (register file write-back)
    wire [31:0] wb_WriteData;

    // FETCH stage
    fetch fetch0(
        .clk          (clk),
        .rst          (rst),
        .ex_mem_pc_src(PCSrc),         // from MEM stage
        .ex_mem_npc   (ex_mem_npc),    // from EX stage
        .if_id_instr  (if_id_instr),
        .if_id_npc    (if_id_npc)
    );

    // DECODE stage
    decode decode0(
        .clk                      (clk),
        .rst                      (rst),
        .wb_reg_write             (mem_control_wb[1]),   // RegWrite
        .wb_write_reg_location    (mem_Write_reg),
        .mem_wb_write_data        (wb_WriteData),
        .if_id_instr              (if_id_instr),
        .if_id_npc                (if_id_npc),
        .id_ex_wb                 (id_ex_wb),
        .id_ex_mem                (id_ex_mem),
        .id_ex_execute            (id_ex_execute),
        .id_ex_npc                (id_ex_npc),
        .id_ex_readdat1           (id_ex_readdat1),
        .id_ex_readdat2           (id_ex_readdat2),
        .id_ex_sign_ext           (id_ex_sign_ext),
        .id_ex_instr_bits_20_16   (id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11   (id_ex_instr_bits_15_11),
        .id_ex_instr_bits_5_0     (id_ex_instr_bits_5_0)
    );

    // EXECUTE stage
    execute execute0(
        .clk           (clk),
        .rst           (rst),
        .wb_ctl        (id_ex_wb),
        .m_ctl         (id_ex_mem),
        .regdst        (id_ex_execute[3]),
        .alusrc        (id_ex_execute[2]),
        .aluop         (id_ex_execute[1:0]),
        .npcout        (id_ex_npc),
        .rdata1        (id_ex_readdat1),
        .rdata2        (id_ex_readdat2),
        .s_extendout   (id_ex_sign_ext),
        .instrout_2016 (id_ex_instr_bits_20_16),
        .instrout_1511 (id_ex_instr_bits_15_11),
        .funct         (id_ex_instr_bits_5_0),
        .wb_ctlout     (ex_mem_wb_ctlout),
        .branch        (branch),
        .memread       (memread),
        .memwrite      (memwrite),
        .ex_mem_npc    (ex_mem_npc),
        .zero          (zero),
        .alu_result    (alu_result),
        .rdata2out     (rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );

    // MEMORY stage
    memory memory0(
        .clk            (clk),
        .rst            (rst),
        .Branch         (branch),
        .MemRead        (memread),
        .MemWrite       (memwrite),
        .control_wb_in  (ex_mem_wb_ctlout),
        .Address        (alu_result),
        .Write_data     (rdata2out),
        .Write_reg_in   (five_bit_muxout),
        .zero           (zero),
        .PCSrc          (PCSrc),
        .mem_control_wb (mem_control_wb),
        .Read_data      (mem_Read_data),
        .mem_ALU_result (mem_ALU_result),
        .mem_Write_reg  (mem_Write_reg)
    );

    // WRITEBACK stage
    writeback writeback0(
        .mem_Read_data  (mem_Read_data),
        .mem_ALU_result (mem_ALU_result),
        .MemtoReg       (mem_control_wb[0]),  // MemtoReg bit
        .WriteData      (wb_WriteData)
    );

endmodule
