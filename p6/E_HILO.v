`timescale 1ns / 1ps
`include "const.v"

module E_HILO (
    input clk,
    input reset,
    input [31:0] rs,
    input [31:0] rt,
    input [3:0] HILOtype,
    output HILObusy,
    output [31:0] HILOout
);

    integer state = 0;
    reg [31:0] hi, lo, temp_hi, temp_lo;
    wire    mult = (HILOtype == `HILO_mult),
            multu = (HILOtype == `HILO_multu),
            div = (HILOtype == `HILO_div),
            divu = (HILOtype == `HILO_divu),
            mflo = (HILOtype == `HILO_mflo),
            mfhi = (HILOtype == `HILO_mfhi),
            mtlo = (HILOtype == `HILO_mtlo),
            mthi = (HILOtype == `HILO_mthi);
    
    wire start =  mult | multu | div | divu;
    reg busy;
    
    assign HILObusy = start | busy;
    assign HILOout =   mflo ? lo:
                       mfhi ? hi:
                       0;
                    
    initial begin
        state <= 0;
        busy <= 0;
        hi <= 0;
        lo <= 0;
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            busy <= 0;
            hi <= 0;
            lo <= 0;
        end else begin
            if (state == 0) begin
                if (mtlo) lo <= rs;
                else if (mthi) hi <= rs;
                else if (mult) begin
                    busy <= 1;
                    state <= 5;
                    {temp_hi, temp_lo} <= $signed(rs) * $signed(rt);
                end else if (multu) begin
                    busy <= 1;
                    state <= 5;
                    {temp_hi, temp_lo} <= rs * rt;
                end else if (div) begin
                    busy <= 1;
                    state <= 10;
                    temp_lo <= $signed(rs) / $signed(rt);
                    temp_hi <= $signed(rs) % $signed(rt);
                end else if (divu) begin
                    busy <= 1;
                    state <= 10;
                    temp_lo <= rs / rt;
                    temp_hi <= rs % rt;
                end
            end else if (state == 1) begin
                state <= 0;
                busy <= 0;
                hi <= temp_hi;
                lo <= temp_lo;
            end else begin
                state <= state - 1;
            end
        end
    end

endmodule
