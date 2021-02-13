`timescale 1ns / 1ps
`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
`define S10 4'b1010
`define S11 4'b1011
`define S12 4'b1100
`define S13 4'b1101
`define S14 4'b1110
`define S15 4'b1111

`define OERROR 2'b00
`define O1 2'b01
`define O2 2'b10

`define ERR0 4'b0000
`define ERR1 4'b0001
`define ERR2 4'b0010
`define ERR3 4'b0100
`define ERR4 4'b1000

module cpu_checker(
	input clk,
	input reset,
	input [7:0] char,
	input [15:0] freq,
	output reg [1:0] format_type,
	output reg [3:0] error_code
    );

	reg [1:0] cur;
	reg [3:0] status, reg_error;
	reg [31:0] count, num;

	initial begin
		format_type <= 2'b00;
		count <= 0;
		status <= `S0;
		cur <= 0;
		reg_error <= 0;
		error_code <= 0;
		num <= 0;
	end

	always @(posedge clk) begin
		if (reset) begin
			format_type <= 2'b00;
			count <= 0;
			status <= `S0;
			cur <= 0;
			reg_error <= 0;
			error_code <= 0;
			num <= 0;
		end
		else begin
			case (status)
				`S0: begin
					format_type <= `OERROR;
					reg_error <= 0;
					error_code <= 0;

					if(char == "^") begin
						status <= `S15;
						num <= 0;
					end
					else status <= `S0;
				end

				`S15: begin
					if(char >= "0" && char <= "9") begin
						status <= `S1;
						count <= 1;
						num <= char ^ 48;
					end
					else status <= `S0;
				end

				`S1: begin
					if(char >= "0" && char <= "9") begin
						count <= count + 1;
						num <= (num << 1) + (num << 3) + (char ^ 48);
					end
					else if(char == "@" && count <= 4) begin
						status <= `S2;

						if((num & ((freq >> 1) - 1)) != 0) reg_error <= reg_error | `ERR1;
					end
					else status <= `S0;
				end

				`S2: begin
					if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
						status <= `S3;
						count <= 1;
						if(char >= "0" && char <= "9") num <= char ^ 48;
						else num <= (char ^ "`") + 9;
					end
					else status <= `S0;
				end

				`S3: begin
					if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
						count = count + 1;
						if(char >= "0" && char <= "9") num <= (num << 4) + (char ^ 48);
						else num <= (num << 4) + (char ^ "`") + 9;
					end
					else if(char == ":" && count == 8) begin
						status <= `S4;

						if ((num & 2'b11) != 0 || !(num >= 32'h0000_3000 && num <= 32'h0000_4fff)) reg_error <= reg_error | `ERR2;
					end
					else status <= `S0;
				end

				`S4: begin
					if(char == " ") begin
						status <= `S4;
					end
					else if(char == "$") begin
						cur <= `O1;
						status <= `S5;
					end
					else if(char == 8'd42) begin
						cur <= `O2;
						status <= `S11;
					end
					else status <= `S0;
				end

				`S5: begin
					if(char >= "0" && char <= "9") begin
						status <= `S6;
						count <= 1;
						num <= char ^ 48;
					end
					else status <= `S0;
				end

				`S6: begin
					if(char >= "0" && char <= "9") begin
						count <= count + 1;
						num <= (num << 1) + (num << 3) + (char ^ 48);
					end
					else if(char == " " && count <= 4) begin
						status <= `S7;

						if(!(num >= 0 && num <= 31)) reg_error <= reg_error | `ERR4;
					end
					else if(char == "<" && count <= 4) begin
						status <= `S8;

						if(!(num >= 0 && num <= 31)) reg_error <= reg_error | `ERR4;
					end
					else status <= `S0;
				end

				`S7: begin
					if(char == " ") begin
						status <= `S7;
					end
					else if(char == "<") begin
						status <= `S8;
					end
					else status <= `S0;
				end

				`S8: begin
					if(char == "=") begin
						status <= `S9;
					end
					else status <= `S0;
				end

				`S9: begin
					if(char == " ") begin
						status <= `S9;
					end
					else if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
						count <= 1;
						status <= `S10;
						if(char >= "0" && char <= "9") num <= char ^ 48;
						else num <= (char ^ "`") + 9;
					end
					else status <= `S0;
				end

				`S10: begin
					if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
						count <= count + 1;
						if(char >= "0" && char <= "9") num <= (num << 4) + (char ^ 48);
						else num <= (num << 4) + (char ^ "`") + 9;
					end
					else if(char == "#" && count == 8) begin
						format_type <= cur;
						status <= `S0;
						error_code <= reg_error;
					end
					else status <= `S0;
				end

				`S11: begin
					if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
						status <= `S12;
						count <= 1;
						if(char >= "0" && char <= "9") num <= char ^ 48;
						else num <= (char ^ "`") + 9;
					end
					else status <= `S0;
				end

				`S12: begin
					if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
						count <= count + 1;
						if(char >= "0" && char <= "9") num <= (num << 4) + (char ^ 48);
						else num <= (num << 4) + (char ^ "`") + 9;
					end
					else if(char == " " && count == 8) begin
						status <= `S7;

						if((num & 3) != 0 || !(num >= 32'h0000_0000 && num <= 32'h0000_2fff)) reg_error <= reg_error | `ERR3;
					end
					else if(char == "<" && count == 8) begin
						status <= `S8;

						if((num & 3) != 0 || !(num >= 32'h0000_0000 && num <= 32'h0000_2fff)) reg_error <= reg_error | `ERR3;
					end
					else status <= `S0;
				end
			endcase
		end
	end

endmodule
