`define sEmpty 2'b00
`define sNum 2'b01
`define sOp 2'b10
`define sInvalid 2'b11

module string (
               input       clk,
               input       clr,
               input [7:0] in,
               output      out
               );

   reg [1:0]               cur;

   initial begin
      cur <= `sEmpty;
   end

   always @(posedge clk, posedge clr) begin
      if (clr) begin
         cur <= `sEmpty;
      end else begin
         case (cur)
           `sEmpty: begin
              if (in >= "0" && in <= "9") cur <= `sNum;
              else cur <= `sInvalid;
           end

           `sNum: begin
              if (in >= "0" && in <= "9") cur <= `sInvalid;
              else if (in == "+" || in == "*") cur <= `sOp;
              else cur <= `sInvalid;
           end

           `sOp: begin
              if (in >= "0" && in <= "9") cur <= `sNum;
              else cur <= `sInvalid;
           end

           default: cur <= `sInvalid;
         endcase
      end
   end

   assign out = (cur == `sNum);

endmodule
