`define sEmpty 4'b0000
`define sBegin1 4'b0001
`define sBegin2 4'b0010
`define sBegin3 4'b0011
`define sBegin4 4'b0100
`define sBegin5 4'b0101
`define sEnd1 4'b0110
`define sEnd2 4'b0111
`define sEnd3 4'b1000
`define sInvalid 4'b1001
`define sChar 4'b1010

module BlockChecker (
                     input       clk,
                     input       reset,
                     input [7:0] in,
                     output      result
                     );

   reg [31:0]                    cur1;
   reg [4:0]                     cur;

   function [7:0] tolower;
      input [7:0]                c;
      begin
         tolower = (c >= "A" && c <= "Z") ? (c - "A" + "a") : c;
      end
   endfunction

   initial begin
      cur1 <= 0;
      cur <= `sEmpty;
   end

   always @(posedge clk, posedge reset) begin
      if (reset) begin
         cur1 <= 0;
         cur <= `sEmpty;
      end else begin
         case (cur)
           `sEmpty: begin
              if (tolower(in) == "b") cur <= `sBegin1;
              else if (tolower(in) == "e") cur <= `sEnd1;
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sBegin1: begin
              if (tolower(in) == "e") cur <= `sBegin2;
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sBegin2: begin
              if (tolower(in) == "g") cur <= `sBegin3;
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sBegin3: begin
              if (tolower(in) == "i") cur <= `sBegin4;
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sBegin4: begin
              if (tolower(in) == "n") begin
                 cur <= `sBegin5;
                 cur1 <= cur1 + 1;
              end
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sBegin5: begin
              if (tolower(in) >= "a" && tolower(in) <= "z") begin
                 cur <= `sChar;
                 cur1 <= cur1 - 1;
              end else begin
                 cur <= `sEmpty;
              end
           end

           `sEnd1: begin
              if (tolower(in) == "n") cur <= `sEnd2;
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sEnd2: begin
              if (tolower(in) == "d") begin
                 cur1 <= cur1 - 1;
                 cur <= `sEnd3;
              end
              else if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end

           `sEnd3: begin
              if (tolower(in) >= "a" && tolower(in) <= "z") begin
                 cur <= `sChar;
                 cur1 <= cur1 + 1;
              end else
                if (cur1[31]) cur <= `sInvalid;
                else cur <= `sEmpty;
           end

           `sInvalid: begin

           end

           `sChar: begin
              if (tolower(in) >= "a" && tolower(in) <= "z") cur <= `sChar;
              else cur <= `sEmpty;
           end
         endcase
      end
   end

   assign result = (cur1 == 0);

endmodule
