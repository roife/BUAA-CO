`timescale 1ns / 1ps
`define IM SR[15:10]    // allow 6 hardware ints
`define EXL SR[1]       // in int (cannot int/exc)
`define IE SR[0]        // allow int
`define BD Cause[31]
`define hwint_pend Cause[15:10]
`define ExcCode Cause[6:2]

module CP0(
    input [4:0] A1,         // read reg addr (mfc0)
    input [4:0] A2,         // write reg addr (mtc0)
    input bdIn,             // exc happens in branch delay slot
    input [31:0] DIn,       // write data (mfc0 - grf)
    input [31:2] PC,        // affected pc
    input [4:0] ExcCodeIn,  // int|excn code
    input [5:0] HWInt,      // 6 hardware int
    input WE,
    // input EXLSet,           // sr.exl <= 1 (M stage)
    input EXLClr,           // sr.exl <= 0 (eret)
    input clk,
    input reset,
    output Req,
    output [31:0] EPCout,   // EPC
    output [31:0] Dout      // read from cp0
);

    //////////// Reg
    reg [31:0] SR;
    reg [31:0] Cause;
    reg [31:2] EPCreg;
    reg [31:0] PrID;
    //////////// EndReg

    wire IntReq = (|(HWInt & `IM)) & !`EXL & `IE;
    wire ExcReq = (|ExcCodeIn) & !`EXL;
    assign Req  = IntReq | ExcReq;

    wire [31:2] tempEPC = (Req) ? (bdIn ? PC[31:2]-1 : PC[31:2])
                                : EPCreg;

    assign EPCout = {tempEPC, 2'b0};

    initial begin
        SR      <= 0;
        Cause   <= 0;
        EPCreg  <= 0;
        PrID    <= 32'h1937_3189;
    end

    assign Dout =   (A1 == 12) ? SR:
                    (A1 == 13) ? Cause:
                    (A1 == 14) ? EPCout:
                    (A1 == 15) ? PrID:
                    0;

    always@(posedge clk or posedge reset)begin
        if(reset)begin
            SR      <= 0;
            Cause   <= 0;
            EPCreg  <= 0;
            PrID    <= 32'h1937_3189;
        end else begin
            if (EXLClr) `EXL <= 1'b0;

            if (Req) begin // int|exc
                `ExcCode <= IntReq ? 5'b0 : ExcCodeIn;
                `EXL <= 1'b1;
                EPCreg <= tempEPC;
                `BD <= bdIn;
            end else if (WE) begin // mtc0 & !(int|exc)
                if (A2 == 12) SR <= DIn;
                else if (A2 == 14) EPCreg <= DIn[31:2];
            end
            `hwint_pend <= HWInt;
      end
   end

endmodule
