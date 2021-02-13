`timescale 1ns / 1ps
`include "const.v"

module E_REG (
    input clk,
    input reset,
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
        if (reset) begin
            instr_out   <= 0;
            pc_out      <= 0;
            EXT_out     <= 0;
            rs_out      <= 0;
            rt_out      <= 0;
        end else if(WE) begin
            instr_out   <= instr_in;
            pc_out      <= pc_in;
            EXT_out     <= EXT_in;
            rs_out      <= rs_in;
            rt_out      <= rt_in;
        end
    end

endmodule