`timescale 1ns / 1ps
`include "const.v"

module CU (
    input [5:0] opcode,
    input [5:0] func,
    output [31:0] type,
    output [2:0] DMType,
    output [2:0] Br,
    output [2:0] A3Sel,
    output [2:0] WDSel,
    output RFWr,
    output EXTOp,
    output ALUBSelImm,
    output DMWr,
    output [3:0] ALUControl
);

    wire _rtype, _load, _store, _branch;
    wire beq, blez, j, jal, lb, lbu, lh, lhu, lui, lw, ori, sw, sh, sb, slti, addu, And, jalr, jr, Or, sll, sllv, slt, subu;

    assign _rtype = (opcode == `OP_rtype);
    assign _load = lw || lh || lhu || lbu || lb;
    assign _store = sw || sh || sb;
    assign _branch = beq || blez;

    assign type = (opcode == `OP_beq) ? `I_beq :
                  (opcode == `OP_blez) ? `I_blez :
                  (opcode == `OP_j ) ? `I_j :
                  (opcode == `OP_jal) ? `I_jal :
                  (opcode == `OP_lb) ? `I_lb :
                  (opcode == `OP_lbu) ? `I_lbu :
                  (opcode == `OP_lh) ? `I_lh :
                  (opcode == `OP_lhu) ? `I_lhu :
                  (opcode == `OP_lui) ? `I_lui :
                  (opcode == `OP_lw) ? `I_lw :
                  (opcode == `OP_ori) ? `I_ori :
                  (opcode == `OP_sw) ? `I_sw :
                  (opcode == `OP_sh) ? `I_sh :
                  (opcode == `OP_sb) ? `I_sb :
                  (opcode == `OP_slti) ? `I_slti :
                  (func == `FUNC_addu) ? `I_addu :
                  (func == `FUNC_and) ? `I_and :
                  (func == `FUNC_jalr) ? `I_jalr :
                  (func == `FUNC_jr) ? `I_jr :
                  (func == `FUNC_or) ? `I_or :
                  (func == `FUNC_sll) ? `I_sll :
                  (func == `FUNC_sllv) ? `I_sllv :
                  (func == `FUNC_slt) ? `I_slt :
                  (func == `FUNC_subu) ? `I_subu :
                  0;

    assign beq = (type == `I_beq);
    assign blez = (type == `I_blez);
    assign j = (type == `I_j);
    assign jal = (type == `I_jal);
    assign lb = (type == `I_lb);
    assign lbu = (type == `I_lbu);
    assign lh = (type == `I_lh);
    assign lhu = (type == `I_lhu);
    assign lui = (type == `I_lui);
    assign lw = (type == `I_lw);
    assign ori = (type == `I_ori);
    assign sw = (type == `I_sw);
    assign sh = (type == `I_sh);
    assign sb = (type == `I_sb);
    assign slti = (type == `I_slti);
    assign addu = (type == `I_addu);
    assign And = (type == `I_and);
    assign jalr = (type == `I_jalr);
    assign jr = (type == `I_jr);
    assign Or = (type == `I_or);
    assign sllv = (type == `I_sllv);
    assign sll = (type == `I_sll);
    assign slt = (type == `I_slt);
    assign subu = (type == `I_subu);

    assign ALUControl = (subu) ? `ALU_sub :
                        (And) ? `ALU_and :
                        (Or || ori) ? `ALU_or :
                        (sll) ? `ALU_sll :
                        (slt || slti) ? `ALU_slt :
                        (lui) ? `ALU_lui :
                        (sllv) ? `ALU_sllv :
                        `ALU_add;
    assign Br = (_branch) ? `BR_beq :
                (j || jal || jalr) ? `BR_j :
                (jr) ? `BR_jr :
                `BR_pc4;
    assign A3Sel = (_rtype) ? `A3Sel_rd :
                   (jr || jalr) ? `A3Sel_ra :
                   `A3Sel_rt;
    assign WDSel = (_load) ? `WDSel_DMout :
                   (jal || jalr) ? `WDSel_PC4 :
                   `WDSel_ALUout;
    // 不写 reg 的指令
    assign RFWr = !_store && !_branch && !j && !jr;
    assign EXTOp = _store;
    // 不用 imm 的指令
    assign ALUBSelImm = !_rtype && !_branch && !j && !jal && !jalr;
    assign DMWr = _store;
    assign DMType = (lw || sw) ? `DM_w :
                    (lh || sh) ? `DM_h :
                    (lhu) ? `DM_hu :
                    (lb || sb) ? `DM_b :
                    (lbu) ? `DM_bu :
                    `DM_w;

endmodule