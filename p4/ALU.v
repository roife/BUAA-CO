`timescale 1ns / 1ps
`include "const.v"

module ALU (
    input [3:0] ALUControl,
    input [31:0] A,
    input [31:0] B,
    input [5:0] shamt,
    output [31:0] ALUout
);

    assign ALUout = (ALUControl == `ALU_add) ? A + B :
                    (ALUControl == `ALU_sub) ? A - B :
                    (ALUControl == `ALU_and) ? A & B :
                    (ALUControl == `ALU_or) ? A | B :
                    (ALUControl == `ALU_sll) ? B << shamt :
                    (ALUControl == `ALU_slt) ? A < B :
                    (ALUControl == `ALU_lui) ? B << 16 :
                    (ALUControl == `ALU_sllv) ? B << A[4:0] :
                    32'b0;

endmodule