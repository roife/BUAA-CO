`timescale 1ns / 1ps
`include "const.v"

module E_REG (
    input req,
    input [4:0] excCode_in,
    input bd_in,
    output reg [4:0] excCode_out,
    output reg bd_out,

    input clk,
    input reset,
    input stall,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input [31:0] EXT_in,
    input [31:0] rs_in,
    input [31:0] rt_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] EXT_out,
    output reg [31:0] rs_out,
    output reg [31:0] rt_out
);

    always @(posedge clk) begin
        if (reset || stall || req) begin
            instr_out   <= 0;
            pc_out      <= stall ? pc_in : (req ? 32'h0000_4180 : 0);
            EXT_out     <= 0;
            rs_out      <= 0;
            rt_out      <= 0;
            excCode_out <= 0;
            bd_out      <= stall ? bd_in : 0;
        end else if(WE) begin
            instr_out   <= instr_in;
            pc_out      <= pc_in;
            EXT_out     <= EXT_in;
            rs_out      <= rs_in;
            rt_out      <= rt_in;
            excCode_out <= excCode_in;
            bd_out      <= bd_in;
        end
    end

endmodule