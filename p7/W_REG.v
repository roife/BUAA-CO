`timescale 1ns / 1ps
`include "const.v"

module W_REG (
    input req,
    input [31:0] CP0_in,
    output reg [31:0] CP0_out,

    input clk,
    input reset,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input [31:0] ALU_in,
    input [31:0] DM_in,
    input [31:0] HILO_in,
    input [31:0] EXT_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] ALU_out,
    output reg [31:0] DM_out,
    output reg [31:0] HILO_out,
    output reg [31:0] EXT_out
);

    always @(posedge clk) begin
        if (reset || req) begin
            instr_out   <= 0;
            pc_out      <= req ? 32'h0000_4180 : 0;
            ALU_out     <= 0;
            DM_out      <= 0;
            HILO_out    <= 0;
            EXT_out     <= 0;
            CP0_out     <= 0;
        end else if(WE) begin
            instr_out    <= instr_in;
            pc_out       <= pc_in;
            ALU_out      <= ALU_in;
            DM_out       <= DM_in;
            HILO_out     <= HILO_in;
            EXT_out      <= EXT_in;
            CP0_out      <= CP0_in;
        end
    end

endmodule