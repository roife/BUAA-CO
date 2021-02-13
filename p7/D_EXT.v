`timescale 1ns / 1ps
`include "const.v"

module D_EXT (
    input [15:0] imm,
    input [2:0] EXTOp,
    output [31:0] EXTout
);

    assign EXTout = (EXTOp == `EXT_signed) ? {{16{imm[15]}}, imm} :
                    (EXTOp == `EXT_lui) ? {imm, 16'b0} :
                    {{16{1'b0}}, imm};

endmodule