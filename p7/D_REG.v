`timescale 1ns / 1ps
`include "const.v"

module D_REG (
    input req,
    input stall,
    input [4:0] excCode_in,
    input bd_in,
    output reg [4:0] excCode_out,
    output reg bd_out,

    input clk,
    input reset,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
        if (reset | req) begin
            instr_out   <= 0;
            pc_out      <= req ? 32'h0000_4180 : 0;
            excCode_out <= 0;
            bd_out      <= 0;
        end else if(WE) begin
            instr_out   <= instr_in;
            pc_out      <= pc_in;
            excCode_out <= excCode_in;
            bd_out      <= bd_in;
        end
    end

endmodule