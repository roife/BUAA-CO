`timescale 1ns / 1ps
`include "const.v"

module M_REG (
    input req,
    input [4:0] excCode_in,
    input bd_in,
    input excOvDM_in,
    output reg [4:0] excCode_out,
    output reg bd_out,
    output reg excOvDM_out,

    input clk,
    input reset,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input [31:0] ALU_in,
    input [31:0] rt_in,
    input [31:0] HILO_in,
    input [31:0] EXT_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] ALU_out,
    output reg [31:0] rt_out,
    output reg [31:0] HILO_out,
    output reg [31:0] EXT_out
);

    always @(posedge clk) begin
        if (reset || req) begin
            instr_out    <= 0;
            pc_out       <= req ? 32'h0000_4180 : 0;
            ALU_out      <= 0;
            rt_out       <= 0;
            HILO_out     <= 0;
            EXT_out      <= 0;
            excCode_out  <= 0;
            bd_out       <= 0;
            excOvDM_out  <= 0;
        end else if(WE) begin
            instr_out    <= instr_in;
            pc_out       <= pc_in;
            ALU_out      <= ALU_in;
            rt_out       <= rt_in;
            HILO_out     <= HILO_in;
            EXT_out      <= EXT_in;
            excCode_out  <= excCode_in;
            bd_out       <= bd_in;
            excOvDM_out  <= excOvDM_in;
        end
    end

endmodule