`timescale 1ns / 1ps
`include "const.v"

module GRF (
    input [31:0] pc, // for debugging
    input clk,
    input reset,
    input RFWr,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2
);

    reg [31:0] grf [31:0];

    assign RD1 = grf[A1];
    assign RD2 = grf[A2];

    integer i;

    initial begin
        for (i=0; i<32; i=i+1) grf[i] <= 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<32; i=i+1) grf[i] <= 0;
        end
        else if (RFWr) begin
            if (A3) begin
                grf[A3] <= WD;
                $display("@%h: $%d <= %h", pc, A3, WD);
            end
        end
    end

endmodule