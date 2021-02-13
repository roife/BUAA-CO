`timescale 1 ns / 100 ps
module BlockChecker (
                     input       clk,
                     input       reset,
                     input [7:0] in,
                     output      result
                     );

   reg [31:0]                    cnt;
   reg                           valid;
   reg [255:0]                   bfr;

   initial begin
      cnt <= 0;
      valid <= 1'b1;
      bfr = "";
   end

   always @(posedge clk, posedge reset) begin
      if (reset) begin
         cnt <= 0;
         valid <= 1'b1;
         bfr = "";
      end else begin
         bfr = (bfr << 8) | in | 8'h20;

         if (valid) begin
            if (bfr[47:0] == " begin") cnt <= cnt + 1;
            else if (bfr[55:8] == " begin" && bfr[7:0] != " ") cnt <= cnt - 1;
            else if (bfr[31:0] == " end") cnt <= cnt - 1;
            else if (bfr[39:8] == " end" && bfr[7:0] != " ") cnt <= cnt + 1;
            else if (bfr[39:8] == " end" && bfr[7:0] == " " && cnt[31]) valid <= 1'b0;
         end
      end
   end

   assign result = ((cnt == 0) && valid);

endmodule
