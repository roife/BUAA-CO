`timescale 1ns / 1ps
`include "const.v"
`define HIGH_BYTE 15
`define DM_SIZE (1<<`HIGH_BYTE)

`define word memory[addr[`HIGH_BYTE:2]]
`define half `word[15 + 16 * addr[1] -:16]
`define half_sign `word[15 + 16 * addr[1] -:1]
`define byte `word[7 + 8 * addr[1:0] -:8]
`define byte_sign `word[7 + 8 * addr[1:0] -:1]

`define StartAddrDM     32'h0000_0000
`define EndAddrDM       32'h0000_2fff
`define StartAddrTC1    32'h0000_7f00
`define EndAddrTC1      32'h0000_7f0b
`define StartAddrTC2    32'h0000_7f10
`define EndAddrTC2      32'h0000_7f1b

module M_DM (
    input excOvDM,
    output excAdEL,
    output excAdES,

    input [31:0] pc, // for debugging
    input clk,
    input reset,
    input WE,
    input load,
    input store,
    input [2:0] DMType,
    input [31:0] addr,
    input [31:0] WD,
    output [31:0] DMout
);
    reg [31:0] memory [`DM_SIZE - 1:0];

    assign DMout = (DMType == `DM_w) ? `word :
                   (DMType == `DM_h) ? {{16{`half_sign}}, `half} :
                   (DMType == `DM_hu) ? {{16{1'b0}}, `half} :
                   (DMType == `DM_b) ? {{24{`byte_sign}}, `byte} :
                   (DMType == `DM_bu) ? {{24{1'b0}}, `byte} :
                   32'b0;


    ////// Exceptions
    wire ErrAlign = ((DMType == `DM_w) && (|addr[1:0])) ||
                    (((DMType == `DM_h) || (DMType == `DM_hu)) && (addr[0]));
    wire ErrOutOfRange = !( ((addr >= `StartAddrDM) && (addr <= `EndAddrDM)) ||
                            ((addr >= `StartAddrTC1) && (addr <= `EndAddrTC1)) ||
                            ((addr >= `StartAddrTC2) && (addr <= `EndAddrTC2)));
    wire ErrTimer = (DMType != `DM_w) && (addr >= `StartAddrTC1);
    wire ErrSaveTimer = (addr >= 32'h0000_7f08 && addr <= 32'h0000_7f0b) ||
                        (addr >= 32'h0000_7f18 && addr <= 32'h0000_7f1b);
    assign excAdEL = load && (ErrAlign || ErrOutOfRange || ErrTimer || excOvDM);
    assign excAdES = store && (ErrAlign || ErrOutOfRange || ErrTimer || ErrSaveTimer || excOvDM);
    ////// EndExceptions

    integer i;
    initial begin
        for (i=0; i<`DM_SIZE; i=i+1) memory[i] <= 0;
    end

    function [31:0] F_H_OUT;
        input [31:0] WD;
        input [31:0] word;
    begin
        F_H_OUT = word;
        F_H_OUT[15 + 16 * addr[1] -:16] = WD[15:0];
    end
    endfunction

    function [31:0] F_B_OUT;
        input [31:0] WD;
        input [31:0] word;
    begin
        F_B_OUT = word;
        F_B_OUT[7 + 8 * addr[1:0] -:8] = WD[7:0];
    end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<`DM_SIZE; i=i+1) memory[i] <= 0;
        end
        else if (WE && (addr >= `StartAddrDM) && (addr <= `EndAddrDM)) begin
            if (DMType == `DM_w) begin
                `word <= WD;
                $display("%d@%h: *%h <= %h", $time, pc, addr&(`DM_SIZE-1), WD);
            end else if (DMType == `DM_h) begin
                `half <= WD[15:0];
                $display("%d@%h: *%h <= %h", $time, pc, {addr[31:2], 2'b00}&(`DM_SIZE-1), F_H_OUT(WD, memory[addr[`HIGH_BYTE:2]]));
            end else if (DMType == `DM_b) begin
                `byte <= WD[7:0];
                $display("%d@%h: *%h <= %h", $time, pc, {addr[31:2], 2'b00}&(`DM_SIZE-1), F_B_OUT(WD, memory[addr[`HIGH_BYTE:2]]));
            end
        end
    end

endmodule