`timescale 1ns / 1ps
`include "const.v"

module E_ALU (
    input ALUAriOverflow,
    input ALUDMOverflow,
    output excOvAri,
    output excOvDM,

    input [3:0] ALUControl,
    input [31:0] A,
    input [31:0] B,
    output [31:0] ALUout
);

    wire [31:0] res_sra = $signed($signed(A) >>> B);
    wire [31:0] res_slt = $signed(A) < $signed(B) ? 32'b1 : 32'b0;

    assign ALUout = (ALUControl == `ALU_add )    ? A + B :
                    (ALUControl == `ALU_sub )    ? A - B :
                    (ALUControl == `ALU_and )    ? A & B :
                    (ALUControl == `ALU_or  )    ? A | B :
                    (ALUControl == `ALU_xor )    ? A ^ B :
                    (ALUControl == `ALU_nor )    ? ~(A | B) :
                    (ALUControl == `ALU_sll )    ? A << B :
                    (ALUControl == `ALU_srl )    ? A >> B :
                    (ALUControl == `ALU_sra )    ? res_sra :
                    (ALUControl == `ALU_slt )    ? res_slt :
                    (ALUControl == `ALU_sltu)    ? A < B :
                    0;

    wire [32:0] exA = {A[31], A}, exB = {B[31], B};
    wire [32:0] exAdd = exA + exB, exSub = exA - exB;
    assign excOvAri =  ALUAriOverflow && (
                        ((ALUControl == `ALU_add) && (exAdd[32] != exAdd[31])) ||
                        ((ALUControl == `ALU_sub) && (exSub[32] != exSub[31]))
                    );
    assign excOvDM =  ALUDMOverflow && (
                        ((ALUControl == `ALU_add) && (exAdd[32] != exAdd[31])) ||
                        ((ALUControl == `ALU_sub) && (exSub[32] != exSub[31]))
                    );

endmodule