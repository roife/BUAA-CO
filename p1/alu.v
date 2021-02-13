module alu(
	input [31:0] A,
	input [31:0] B,
	input [2:0] ALUOp,
	output reg [31:0] C
);
	always @(*) begin
		case (ALUOp)
			3'b000: C <= A + B;
			3'b001: C <= A - B;
			3'b010: C <= A & B;
			3'b011: C <= A | B;
			3'b100: C <= A >> B;
			3'b101: C <= $signed(A) >>> B;
			default: C <= 0;
		endcase
	end
endmodule
