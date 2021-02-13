`timescale 1ns / 1ps
`include "const.v"

module D_EXT (
    input [15:0] imm,
    input EXTOp,
    output [31:0] EXTout
);

    assign EXTout = EXTOp? {{16{imm[15]}}, imm} : {{16{1'b0}}, imm}; // signed : unsigned

endmodule