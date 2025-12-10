`timescale 1ns / 1ps
/*
Takes in rdata1 as its input as well as "b," which is the output of top_mux.
It outputs result (aluout) and zero. This is the arithmetic / logical ALU.
*/
module alu(
    input  wire [31:0] a,        // source from register
    input  wire [31:0] b,        // target from register / imm
    input  wire [2:0]  control,  // select from alu_control
    output reg  [31:0] result,   // goes to MEM data memory and MEM/WB latch
    output wire        zero      // goes to MEM (branch logic)
);

    // ALU control encodings (match alu_control.v)
    localparam ALUADD = 3'b010;
    localparam ALUSUB = 3'b110;
    localparam ALUAND = 3'b000;
    localparam ALUOR  = 3'b001;
    localparam ALUSLT = 3'b111;
    // 3'b011 is reserved for "unknown" in alu_control

    // Combinational ALU
    always @(*) begin
        case (control)
            ALUADD: result = a + b;
            ALUSUB: result = a - b;
            ALUAND: result = a & b;                    // bitwise AND
            ALUOR : result = a | b;                    // bitwise OR
            ALUSLT: result = ($signed(a) < $signed(b)) // signed set-less-than
                             ? 32'd1
                             : 32'd0;
            default: result = 32'hXXXX_XXXX;           // undefined / invalid op
        endcase
    end

    // Zero flag
    assign zero = (result == 32'd0);

endmodule