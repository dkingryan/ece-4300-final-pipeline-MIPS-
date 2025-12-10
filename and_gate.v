`timescale 1ns / 1ps

module and_gate(
                input wire m_ctlout,
                input wire zero,
                output wire PCSrc
               ); 
               
               assign PCSrc = m_ctlout & zero;

endmodule