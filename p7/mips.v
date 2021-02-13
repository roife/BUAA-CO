`timescale 1ns / 1ps
`define StartAddrTC1    32'h0000_7f00
`define EndAddrTC1      32'h0000_7f0b
`define StartAddrTC2    32'h0000_7f10
`define EndAddrTC2      32'h0000_7f1b
`define RAddr           {PrAddr, 2'b0}

module mips(
    input clk,
    input reset,
    input interrupt,
    output [31:0] addr
    );

    wire PrWE;
    wire [31:0] PrWD, PrRD, M_pc;
    wire [31:2] PrAddr;

    CPU CPU(
        .clk(clk),
        .reset(reset),
        .HWInt(HWInt),
        .PrRD(PrRD),
        .PrWE(PrWE),
        .PrAddr(PrAddr),
        .PrWD(PrWD),
        .M_PCout(M_pc)
    );

    assign addr = M_pc;

    // Timer
    wire selTC1 = (`RAddr >= `StartAddrTC1) && (`RAddr <= `EndAddrTC1),
         selTC2 = (`RAddr >= `StartAddrTC2) && (`RAddr <= `EndAddrTC2);
    wire TCwe1 = selTC1 && PrWE,
         TCwe2 = selTC2 && PrWE;
    wire [31:0] TCout1, TCout2;
    wire IRQ1, IRQ2;
    assign PrRD =   selTC1 ? TCout1 :
                    selTC2 ? TCout2 :
                    0;
    wire [5:0] HWInt = {3'b0, interrupt, IRQ2, IRQ1};

    TC TC1(
        .clk(clk),
        .reset(reset),
        .Addr(PrAddr),
        .WE(TCwe1),
        .Din(PrWD),
        .pc(M_pc),
        .Dout(TCout1),
        .IRQ(IRQ1)
    );

    TC TC2(
        .clk(clk),
        .reset(reset),
        .Addr(PrAddr),
        .WE(TCwe2),
        .Din(PrWD),
        .pc(M_pc),
        .Dout(TCout2),
        .IRQ(IRQ2)
    );

endmodule
