`timescale 1ns / 1ps
`include "const.v"

module D_CMP (
    input [31:0] rs,
    input [31:0] rt,
    input [2:0] type,
    output b_jump
);
    wire equal = (rs == rt);
    wire eq0 = !(|rs);
    wire gt0 = (!rs[31]) && !eq0;
    wire le0 = (rs[31]) && !eq0;

    assign b_jump = (type == `B_beq && equal) ||
                    (type == `B_bne && !equal) ||
                    (type == `B_blez && (le0 || eq0)) ||
                    (type == `B_bgez && (gt0 || eq0)) ||
                    (type == `B_bgtz && gt0) ||
                    (type == `B_bltz && le0);

endmodule