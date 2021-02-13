//// Instr
`define OP_rtype   6'b000000
`define OP_lb      6'b100000
`define OP_lbu     6'b100100
`define OP_lh      6'b100001
`define OP_lhu     6'b100101
`define OP_lw      6'b100011
`define OP_sb      6'b101000
`define OP_sh      6'b101001
`define OP_sw      6'b101011
`define OP_addi    6'b001000
`define OP_addiu   6'b001001
`define OP_andi    6'b001100
`define OP_beq     6'b000100
`define OP_bgez    6'b000001
`define OP_bgtz    6'b000111
`define OP_blez    6'b000110
`define OP_bltz    6'b000001
`define OP_bne     6'b000101
`define OP_j       6'b000010
`define OP_jal     6'b000011
`define OP_lui     6'b001111
`define OP_ori     6'b001101
`define OP_slti    6'b001010
`define OP_sltiu   6'b001011
`define OP_xori    6'b001110

`define FUNC_add   6'b100000
`define FUNC_addu  6'b100001
`define FUNC_and   6'b100100
`define FUNC_div   6'b011010
`define FUNC_divu  6'b011011
`define FUNC_jalr  6'b001001
`define FUNC_jr    6'b001000
`define FUNC_mfhi  6'b010000
`define FUNC_mflo  6'b010010
`define FUNC_mthi  6'b010001
`define FUNC_mtlo  6'b010011
`define FUNC_mult  6'b011000
`define FUNC_multu 6'b011001
`define FUNC_nor   6'b100111
`define FUNC_or    6'b100101
`define FUNC_sll   6'b000000
`define FUNC_sllv  6'b000100
`define FUNC_slt   6'b101010
`define FUNC_sltu  6'b101011
`define FUNC_sra   6'b000011
`define FUNC_srav  6'b000111
`define FUNC_srl   6'b000010
`define FUNC_srlv  6'b000110
`define FUNC_sub   6'b100010
`define FUNC_subu  6'b100011
`define FUNC_xor   6'b100110

`define RT_bltz    5'b00000
`define RT_bgez    5'b00001

`define I_lb      1
`define I_lbu     2
`define I_lh      3
`define I_lhu     4
`define I_lw      5
`define I_sb      6
`define I_sh      7
`define I_sw      8
`define I_addi    9
`define I_addiu   10
`define I_andi    11
`define I_beq     12
`define I_bgez    13
`define I_bgtz    14
`define I_blez    15
`define I_bltz    16
`define I_bne     17
`define I_j       18
`define I_jal     19
`define I_lui     20
`define I_ori     21
`define I_slti    22
`define I_sltiu   23
`define I_xori    24
`define I_add     25
`define I_addu    26
`define I_and     27
`define I_div     28
`define I_divu    29
`define I_jalr    30
`define I_jr      31
`define I_mfhi    32
`define I_mflo    33
`define I_mthi    34
`define I_mtlo    35
`define I_mult    36
`define I_multu   37
`define I_nor     38
`define I_or      39
`define I_sll     40
`define I_sllv    41
`define I_slt     42
`define I_sltu    43
`define I_sra     44
`define I_srav    45
`define I_srl     46
`define I_srlv    47
`define I_sub     48
`define I_subu    49
`define I_xor     50


//// CU Signal

// ALU
`define ALU_add     4'd0
`define ALU_sub     4'd1
`define ALU_and     4'd2
`define ALU_or      4'd3
`define ALU_xor     4'd4
`define ALU_nor     4'd5
`define ALU_sll     4'd6
`define ALU_srl     4'd7
`define ALU_sra     4'd8
`define ALU_slt     4'd9
`define ALU_sltu    4'd10
`define ALU_lui     4'd11

// DM
`define DM_w    3'b000
`define DM_h    3'b001
`define DM_hu   3'b010
`define DM_b    3'b011
`define DM_bu   3'b100

// Branch
`define BR_pc4      3'b000
`define BR_addr     3'b001
`define BR_reg      3'b010
`define BR_branch   3'b011

// B_type
`define B_beq   3'd0
`define B_bne   3'd1
`define B_blez  3'd2
`define B_bgtz  3'd3
`define B_bgez  3'd4
`define B_bltz  3'd5

// RFWDSel
`define RFWD_ALUout  3'b000
`define RFWD_DMout   3'b001
`define RFWD_PC8     3'b010

// ALUASrc
`define ALUASrcRT       2'b00
`define ALUASrcRS       2'b01

// ALUBSrc
`define ALUBSrcShamt    3'd0
`define ALUBSrcRS_4_0   3'd1
`define ALUBSrcRT       3'd2
`define ALUBSrcExt         3'd3

