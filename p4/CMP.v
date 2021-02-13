`timescale 1ns / 1ps
`include "const.v"

module CMP (
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] type,
    output jump
);

    assign jump = (type == `I_beq && RD1 == RD2);

endmodule