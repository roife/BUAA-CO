`timescale 1ns / 1ps
`include "const.v"

module EXT (
    input [15:0] imm,
    input EXTOp,
    output [31:0] EXTout
);

    function [31:0] sign_ext16;
        input [15:0] in;
        begin
            sign_ext16 = {{16{in[15]}}, in};
        end
    endfunction

    function [31:0] unsign_ext16;
        input [15:0] in;
        begin
            unsign_ext16 = {{16{1'b0}}, in};
        end
    endfunction

    assign EXTout = EXTOp? unsign_ext16(imm) : sign_ext16(imm);

endmodule