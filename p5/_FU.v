`timescale 1ns / 1ps
`include "const.v"

module _FU (
    input [31:0] D_instr,
    input [31:0] E_instr,
    input [31:0] M_instr,
    input [31:0] W_instr,
    output forwardE,
    output forwardM,
    output forwardW
);

    wire E_j_l;
    _CU _EInterp (
        .instr(E_instr),
        .j_l(E_j_l)
    );

    wire M_j_l, M_calc_r, M_calc_i;
    _CU _MInterp (
        .instr(M_instr),
        .calc_r(M_calc_r),
        .calc_i(M_calc_i),
        .j_l(M_j_l)
    );

    wire W_j_l, W_calc_r, W_calc_i, W_load;
    _CU _WInterp (
        .instr(W_instr),
        .calc_r(W_calc_r),
        .calc_i(W_calc_i),
        .j_l(W_j_l),
        .load(W_load)
    );

    assign forwardE = E_j_l;
    assign forwardM = M_j_l | M_calc_r | M_calc_i;
    assign forwardW = W_j_l | W_calc_r | W_calc_i | W_load;

endmodule