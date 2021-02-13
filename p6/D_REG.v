`timescale 1ns / 1ps
`include "const.v"

module D_REG (
    input clk,
    input reset,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
        if (reset) begin
            instr_out   <= 0;
            pc_out      <= 0;
        end else if(WE) begin
            instr_out   <= instr_in;
            pc_out      <= pc_in;
        end
    end

endmodule