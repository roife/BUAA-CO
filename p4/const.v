`default_nettype none

//// FUNCcode & nc
`define OP_rtype 6'b000000
`define OP_beq  6'b000100
`define OP_blez 6'b000110
`define OP_j  6'b000010
`define OP_jal  6'b000011
`define OP_lb  6'b100000
`define OP_lbu 6'b100100
`define OP_lh 6'b100001
`define OP_lhu 6'b100101
`define OP_lui  6'b001111
`define OP_lw 6'b100011
`define OP_ori  6'b001101
`define OP_sw 6'b101011
`define OP_sh 6'b101001
`define OP_sb 6'b101000

`define OP_slti 6'b001010

`define FUNC_addu 6'b100001
`define FUNC_and 6'b100100
`define FUNC_jalr 6'b001001
`define FUNC_jr 6'b001000
`define FUNC_or 6'b100101
`define FUNC_sll 6'b000000
`define FUNC_sllv 6'b000100
`define FUNC_slt 6'b101010
`define FUNC_subu 6'b100011

//// instructions
`define I_beq  0
`define I_blez 1
`define I_j  2
`define I_jal  3
`define I_lb  4
`define I_lbu 5
`define I_lh 6
`define I_lhu 7
`define I_lui  8
`define I_lw 9
`define I_ori  10
`define I_sw 11
`define I_sh 12
`define I_sb 13

`define I_slti 14

`define I_addu 15
`define I_and 16
`define I_jalr 17
`define I_jr 18
`define I_or 19
`define I_sllv 20
`define I_slt 21
`define I_subu 22
`define I_sll 23

//// CU Signal

// ALU
`define ALU_add 5'b00000
`define ALU_sub 5'b00001
`define ALU_and 5'b00010
`define ALU_or 5'b00011
`define ALU_sll 5'b00100
`define ALU_slt 5'b00101
`define ALU_lui 5'b00110
`define ALU_sllv 5'b00111

// DM
`define DM_w 3'b000
`define DM_h 3'b001
`define DM_hu 3'b010
`define DM_b 3'b011
`define DM_bu 3'b100

// Branch
`define BR_pc4 3'b000
`define BR_j 3'b001
`define BR_jr 3'b010
`define BR_beq 3'b011

// A3Sel
`define A3Sel_rt 3'b000
`define A3Sel_rd 3'b001
`define A3Sel_ra 3'b010

// WDSel
`define WDSel_ALUout 3'b000
`define WDSel_DMout 3'b001
`define WDSel_PC4 3'b010
