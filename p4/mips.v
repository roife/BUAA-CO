`timescale 1ns / 1ps
`include "const.v"

module mips (
    input clk,
    input reset
);

    wire [31:0] pc, instr, npc;
    wire [31:0] PC4, RD1, RD2, EXTout, type, DMout, ALUout;
    wire [4:0] rs, rt, rd;
    wire [15:0] imm;
    wire [25:0] imm26;
    wire [5:0] func, opcode, shamt;

    wire [2:0] DMType, Br, A3Sel, WDSel;
    wire RFWr, EXTOp, ALUBSel, DMWr, ALUBSelImm;
    wire [3:0] ALUControl;
    wire jump;

    IFU Ifu(.clk(clk),
            .reset(reset),
            .npc(npc),
            .instr(instr),
            .pc(pc),
            .rs(rs),
            .rt(rt),
            .rd(rd),
            .imm(imm),
            .imm26(imm26),
            .func(func),
            .opcode(opcode),
            .shamt(shamt));

    NPC Npc(.pc(pc),
            .imm26(imm26),
            .RD2(RD2),
            .Br(Br),
            .jump(jump),
            .PC4(PC4),
            .npc(npc));

    EXT Ext(.imm(imm),
            .EXTOp(EXTOp),
            .EXTout(EXTout));

    CMP Cmp(.RD1(RD1),
            .RD2(RD2),
            .type(type),
            .jump(jump));

    GRF Grf(.pc(pc),
            .clk(clk),
            .reset(reset),
            .RFWr(RFWr),
            .A1(rs),
            .A2(rt),
            .A3((A3Sel == `A3Sel_rd) ? rd :
                (A3Sel == `A3Sel_rt) ? rt :
                (A3Sel == `A3Sel_ra) ? 5'd31 :
                5'd0),
            .WD((WDSel == `WDSel_ALUout) ? ALUout :
                (WDSel == `WDSel_DMout) ? DMout :
                (WDSel == `WDSel_PC4) ? PC4 :
                0),
            .RD1(RD1),
            .RD2(RD2));

    ALU Alu(.ALUControl(ALUControl),
            .A(RD1),
            .B(ALUBSelImm ? EXTout : RD2),
            .shamt(shamt),
            .ALUout(ALUout));

    DM Dm(.pc(pc),
          .clk(clk),
          .reset(reset),
          .DMWr(DMWr),
          .DMType(DMType),
          .addr(ALUout),
          .WD(RD2),
          .DMout(DMout));

    CU Cu(.opcode(opcode),
          .func(func),
          .type(type),
          .DMType(DMType),
          .Br(Br),
          .A3Sel(A3Sel),
          .WDSel(WDSel),
          .RFWr(RFWr),
          .EXTOp(EXTOp),
          .ALUBSelImm(ALUBSelImm),
          .DMWr(DMWr),
          .ALUControl(ALUControl));

endmodule