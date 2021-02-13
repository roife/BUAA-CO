`timescale 1ns / 1ps
`include "const.v"
`define N 4096
`define StartInstr  32'h0000_3000
`define EndInstr    32'h0000_4fff

module F_IFU (
    input req,
    input D_eret,
    input [31:0] EPC,
    output excAdEL,

    input clk,
    input reset,
    input WE,
    input [31:0] npc,
    output [31:0] instr,
    output [31:0] pc
);

    reg [31:0] im [0:`N-1];
    reg [31:0] tempPC;

    integer i;
    initial begin
        for (i=0; i<`N; i=i+1) im[i] = 0;
        tempPC = 32'h0000_3000;
        $readmemh("code.txt", im);
        $readmemh("code_handler.txt", im, 1120, 2047);
    end

    // ??????????????? Different
    assign excAdEL = ((|pc[1:0]) | (pc < `StartInstr) | (pc > `EndInstr)) && !D_eret;
    assign pc = D_eret ? EPC : tempPC;
    assign instr =  (excAdEL) ? 0 : im[pc[14:2] - 12'hc00];

    always @(posedge clk) begin
        if (reset) tempPC <= 32'h0000_3000; 
        else if(req | WE) tempPC <= npc;
    end

    _DASM Dasm(
        .pc(pc),
        .instr(instr),
        .imm_as_dec(1'b1),
        .reg_name(1'b0),
        .asm()
    );
endmodule