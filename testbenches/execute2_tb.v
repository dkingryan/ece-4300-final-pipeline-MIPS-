module execute2_tb;
    reg clk;
    reg rst;
    reg [1:0] ctlwb_in;
    reg [2:0] ctlm_in;
    reg alusrc, regdst;
    reg [1:0] alu_op;
    reg [31:0] npc, rdata1, rdata2, s_extend;
    reg [4:0] instr_2016, instr_1511;
    reg [5:0] funct;

    wire [1:0] ctlwb_out;
    wire branch, memread, memwrite;
    wire [31:0] adder_out, alu_result_out, rdata2_out;
    wire zero;
    wire [4:0] muxout_out;

    execute uut (
                .clk (clk),
                .rst (rst),
                .wb_ctl (ctlwb_in),  //11 inputs, based off of outputs of ID/EX latch (Lab 2-2)
                .m_ctl (ctlm_in),
                .regdst (regdst),
                .alusrc (alusrc),
                .aluop (alu_op), 
                .npcout (npc),
                .rdata1 (rdata1),
                .rdata2 (rdata2),
                .s_extendout (s_extend),
                .instrout_2016 (instr_2016),
                .instrout_1511 (instr_1511),
                .funct (funct),
                
                .wb_ctlout (ctlwb_out), //9 total outputs from EX/MEM latch
                .branch (branch),
                .memread (memread),
                .memwrite (memwrite),
                .ex_mem_npc (adder_out),
                .zero (zero),
                .alu_result (alu_result_out),
                .rdata2out (rdata2_out),
                .five_bit_muxout (muxout_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        ctlwb_in = 0;
        ctlm_in = 0;
        alusrc = 0;
        regdst = 0;
        alu_op = 0;
        npc = 0;
        rdata1 = 0;
        rdata2 = 0;
        s_extend = 0;
        instr_2016 = 0;
        instr_1511 = 0;
        alu_op = 0;
        funct = 0;
        alusrc = 0;
        regdst = 0;
        #15 
        
        rst = 0;
        ctlwb_in = 2'b10;
        ctlm_in = 3'b001; // Control Memory: Branch = 0, Memread = 0, Memwrite = 0
        rdata1 = 32'd10; // data1 = 10
        rdata2 = 32'd20; //data2 = 20
        s_extend = 0;
        instr_2016 = 5'd5;
        instr_1511 = 5'd10;
        funct = 6'b100000; // ALU Operation = add
        alu_op = 2'b10; // R-Type
        alusrc = 0; // ALU Control = Sign Extended
        regdst = 1; // Mux = instr_1511
        #15;

        // Modify inputs to test different scenarios
        alusrc = 0;
        regdst = 0;
        s_extend = 32'd8;
        alu_op = 2'b01;
        funct = 6'b100010;
        #15;

        $stop;
    end
endmodule