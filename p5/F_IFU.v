`timescale 1ns / 1ps
`include "const.v"

module F_IFU (
    input clk,
    input reset,
    input WE,
    input [31:0] npc,
    output [31:0] instr,
    output reg [31:0] pc
);

    reg [31:0] im [0:1023];

    assign instr = im[pc[11:2]];
    
    initial begin
        pc <= 32'h0000_3000;
        $readmemh("code.txt", im);
    end
    
    always @(posedge clk) begin
        if (reset) pc <= 32'h0000_3000;
        else if(WE) pc <= npc;

    end

    _DASM Dasm(
        .pc(pc),
        .instr(instr),
        .imm_as_dec(1'b1),
        .reg_name(1'b0),
        .asm()
    );
endmodule