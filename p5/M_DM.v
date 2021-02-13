`timescale 1ns / 1ps
`include "const.v"
`define word memory[addr[11:2]]
`define half `word[15 + 16 * addr[1] -:16]
`define half_sign `word[15 + 16 * addr[1] -:1]
`define byte `word[7 + 8 * addr[1:0] -:8]
`define byte_sign `word[7 + 8 * addr[1:0] -:1]

module M_DM (
    input [31:0] pc, // for debugging
    input clk,
    input reset,
    input WE,
    input [2:0] DMType,
    input [31:0] addr,
    input [31:0] WD,
    output [31:0] DMout
);
    reg [31:0] memory [1023:0];

    assign DMout = (DMType == `DM_w) ? `word :
                   (DMType == `DM_h) ? {{16{`half_sign}}, `half} :
                   (DMType == `DM_hu) ? {{16{1'b0}}, `half} :
                   (DMType == `DM_b) ? {{24{`byte_sign}}, `byte} :
                   (DMType == `DM_bu) ? {{24{1'b0}}, `byte} :
                   32'b0;

    integer i; 

    initial begin
        for (i=0; i<1024; i=i+1) memory[i] <= 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<1024; i=i+1) memory[i] <= 0;
        end
        else if (WE) begin
            if (DMType == `DM_w) `word <= WD;
            else if (DMType == `DM_h) `half <= WD[15 + 16 * addr[1:1] -:16];
            else if (DMType == `DM_b) `byte <= WD[7 + 8 * addr[1:0] -:8];

            $display("%d@%h: *%h <= %h", $time, pc, addr, WD);
        end
    end

endmodule