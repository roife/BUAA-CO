`timescale 1ns / 1ps
`include "const.v"

module IFU (
    input clk,
    input reset,
    input [31:0] npc,
    output [31:0] instr,
    output reg [31:0] pc,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm,
    output [25:0] imm26,
    output [5:0] func,
    output [5:0] opcode,
    output [5:0] shamt
);

    reg [31:0] im [0:1023];

    assign instr = im[pc[11:2]];

    assign opcode = instr[31:26];
    assign func = instr[5:0];
    assign imm26 = instr[25:0];
    assign imm = instr[15:0];
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    assign shamt = instr[10:6];

    DASM Dasm(
        .pc(pc),
        .instr(instr),
        .imm_as_dec(1'b1),
        .reg_name(1'b0),
        .asm()
    );

    initial begin
        pc <= 32'h0000_3000;
        $readmemh("code.txt", im);
        $display("%h", im[pc]);
    end

    always @(posedge clk) begin
        if (reset) pc <= 32'h0000_3000;
        else pc <= npc;

    end
endmodule