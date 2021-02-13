`define SIZE 3
module gray (
             input                    Clk,
             input                    Reset,
             input                    En,
             output reg [`SIZE - 1:0] Output,
             output reg               Overflow
             );

   reg [`SIZE - 1:0]                  cnt;
   reg                                flag;

   parameter ZERO = {`SIZE{1'b0}};
   parameter ONE = {{(`SIZE - 1){1'b0}}, 1'b1};
   parameter INF = {`SIZE{1'b1}};

   initial begin
      Output <= ZERO;
      cnt <= ZERO;
      Overflow <= 1'b0;
      flag <= 1'b0;
   end

   always @(posedge Clk) begin
      if (Reset) begin
         Output <= ZERO;
         cnt <= ZERO;
         Overflow <= 1'b0;
         flag <= 1'b0;
      end else if (En) begin
         if (cnt == INF) begin
            Output <= ZERO;
            cnt <= ZERO;
            Overflow <= 1'b1;
            flag <= 1'b0;
         end else begin
            if (flag) begin
               flag <= ~flag;
               Output <= Output ^ (((Output & ((~Output) + 1))) << 1);
               cnt <= cnt + 1;
            end else begin
               flag <= ~flag;
               Output <= Output ^ ONE;
               cnt <= cnt + 1;
            end
         end
      end
   end

endmodule
