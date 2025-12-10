`timescale 1ns / 1ps
/*
Takes the 6-bit funct field and 2-bit ALUOp and produces the
3-bit ALU control signal "select" for alu.v
*/
module alu_control(
    input  wire [5:0] funct,  // from ID/EX latch (IR[5:0])
    input  wire [1:0] aluop,  // from main control
    output reg  [2:0] select  // to ALU
);

    // ALUOp encodings
    parameter LWSW   = 2'b00; // load / store -> add
    parameter BEQ    = 2'b01; // branch equal -> subtract
    parameter RTYPE  = 2'b10; // R-type -> use funct
    parameter UNKNOWN= 2'b11; // unused / invalid

    // ALU control encodings
    parameter ALUADD = 3'b010;
    parameter ALUSUB = 3'b110;
    parameter ALUAND = 3'b000;
    parameter ALUOR  = 3'b001;
    parameter ALUSLT = 3'b111;
    parameter ALUX   = 3'b011;  // "don't care" / invalid

    // R-type funct field values
    parameter FUNCTADD = 6'b100000;
    parameter FUNCTSUB = 6'b100010;
    parameter FUNCTAND = 6'b100100;
    parameter FUNCTOR  = 6'b100101;
    parameter FUNCTSLT = 6'b101010;

    always @(*) begin
        case (aluop)
            // LW / SW : always ADD
            LWSW:   select = ALUADD;

            // BEQ : always SUBTRACT
            BEQ:    select = ALUSUB;

            // R-type : decode funct field
            RTYPE: begin
                case (funct)
                    FUNCTADD: select = ALUADD;
                    FUNCTSUB: select = ALUSUB;
                    FUNCTAND: select = ALUAND;
                    FUNCTOR:  select = ALUOR;
                    FUNCTSLT: select = ALUSLT;
                    default:  select = ALUX;   // unknown funct
                endcase
            end

            // Unknown / invalid ALUOp
            default: select = ALUX;
        endcase
    end

endmodule