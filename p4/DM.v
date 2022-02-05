`timescale 1ns / 1ps
`include "const.v"
`define word memory[waddr]
`define half `word[15 + 16 * addr[1] -:16]
`define byte `word[7 + 8 * addr[1:0] -:8]

module DM (
    input [31:0] pc, // for debugging
    input clk,
    input reset,
    input DMWr,
    input [2:0] DMType,
    input [31:0] addr,
    input [31:0] WD,
    output [31:0] DMout
);

    function [31:0] sign_ext16;
        input [15:0] in;
        begin
            sign_ext16 = {{16{in[15]}}, in};
        end
    endfunction

    function [31:0] unsign_ext16;
        input [15:0] in;
        begin
            unsign_ext16 = {{16{1'b0}}, in};
        end
    endfunction

    function [31:0] sign_ext8;
        input [7:0] in;
        begin
            sign_ext8 = {{24{in[7]}}, in};
        end
    endfunction

    function [31:0] unsign_ext8;
        input [7:0] in;
        begin
            unsign_ext8 = {{24{1'b0}}, in};
        end
    endfunction

    reg [31:0] memory [1023:0];
    integer i;

    wire [9:0] waddr;
    assign waddr = addr[11:2];

    assign DMout = (DMType == `DM_w) ? `word :
                   (DMType == `DM_h) ? sign_ext16(`half) :
                   (DMType == `DM_hu) ? unsign_ext16(`half) :
                   (DMType == `DM_b) ? sign_ext8(`byte) :
                   (DMType == `DM_bu) ? unsign_ext8(`byte) :
                   32'b0;

    initial begin
        for (i=0; i<1023; i=i+1) memory[i] <= 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<1023; i=i+1) memory[i] <= 0;
        end
        else if (DMWr) begin
            if (DMType == `DM_w) `word <= WD;
            else if (DMType == `DM_h) `half <= WD[15:0];
            else if (DMType == `DM_b) `byte <= WD[7:0];

            $display("@%h: *%h <= %h", pc, addr, WD);
        end
    end

endmodule