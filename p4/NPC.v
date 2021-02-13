`timescale 1ns / 1ps
`include "const.v"

module NPC (
    input [31:0] pc,
    input [25:0] imm26,
    input [31:0] RD2,
    input [2:0] Br,
    input jump,
    output [31:0] PC4,
    output [31:0] npc
);
    assign PC4 = pc + 4;
    assign npc = (Br == `BR_pc4) ? pc + 4 :
                 (Br == `BR_j) ? {pc[31:28], imm26, 2'b0} :
                 (Br == `BR_jr) ? RD2 :
                 (Br == `BR_beq && jump) ? pc + 4 + {{14{imm26[15]}}, imm26[15:0], 2'b0} :
                 pc + 4;
endmodule