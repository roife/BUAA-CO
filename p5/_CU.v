`timescale 1ns / 1ps
`include "const.v"

module _CU (
    input [31:0] instr,
    // decode
    output [4:0] rs_addr,
    output [4:0] rt_addr,
    output [4:0] rd_addr,
    output [15:0] imm,
    output [25:0] addr,
    // classify
    output load,
    output store,
    output calc_r,
    output calc_i,
    output shiftS,
    output shiftV,
    output branch,
    output j_r,
    output j_addr,
    output j_l,
    // signals
    output [2:0] Br,
    output [2:0] B_type,
    output EXTOp,

    output [3:0] ALUControl,
    output [1:0] ALUASrc,
    output [2:0] ALUBSrc,

    output [2:0] DMType,
    output DMWr,

    output [4:0] RFDst,
    output RFWr,
    output [2:0] RFWDSrc
);

    wire [5:0] opcode = instr[31:26],
               func = instr[5:0];
    assign rs_addr = instr[25:21],
           rt_addr = instr[20:16],
           rd_addr = instr[15:11];
    assign imm = instr[15:0];
    assign addr = instr[25:0];

    wire lb    = (opcode == `OP_lb   );
    wire lbu   = (opcode == `OP_lbu  );
    wire lh    = (opcode == `OP_lh   );
    wire lhu   = (opcode == `OP_lhu  );
    wire lw    = (opcode == `OP_lw   );
    wire sb    = (opcode == `OP_sb   );
    wire sh    = (opcode == `OP_sh   );
    wire sw    = (opcode == `OP_sw   );
    wire addi  = (opcode == `OP_addi );
    wire addiu = (opcode == `OP_addiu);
    wire andi  = (opcode == `OP_andi );
    wire beq   = (opcode == `OP_beq  );
    wire bgtz  = (opcode == `OP_bgtz );
    wire blez  = (opcode == `OP_blez );
    wire bgez  = (opcode == `OP_bgez && rt_addr == `RT_bgez);
    wire bltz  = (opcode == `OP_bltz && rt_addr == `RT_bltz);
    wire bne   = (opcode == `OP_bne  );
    wire j     = (opcode == `OP_j    );
    wire jal   = (opcode == `OP_jal  );
    wire lui   = (opcode == `OP_lui  );
    wire ori   = (opcode == `OP_ori  );
    wire slti  = (opcode == `OP_slti );
    wire sltiu = (opcode == `OP_sltiu);
    wire xori  = (opcode == `OP_xori );

    wire add   = (opcode == `OP_rtype && func == `FUNC_add  );
    wire addu  = (opcode == `OP_rtype && func == `FUNC_addu );
    wire And   = (opcode == `OP_rtype && func == `FUNC_and  );
    wire div   = (opcode == `OP_rtype && func == `FUNC_div  );
    wire divu  = (opcode == `OP_rtype && func == `FUNC_divu );
    wire jalr  = (opcode == `OP_rtype && func == `FUNC_jalr );
    wire jr    = (opcode == `OP_rtype && func == `FUNC_jr   );
    wire mfhi  = (opcode == `OP_rtype && func == `FUNC_mfhi );
    wire mflo  = (opcode == `OP_rtype && func == `FUNC_mflo );
    wire mthi  = (opcode == `OP_rtype && func == `FUNC_mthi );
    wire mtlo  = (opcode == `OP_rtype && func == `FUNC_mtlo );
    wire mult  = (opcode == `OP_rtype && func == `FUNC_mult );
    wire multu = (opcode == `OP_rtype && func == `FUNC_multu);
    wire Nor   = (opcode == `OP_rtype && func == `FUNC_nor  );
    wire Or    = (opcode == `OP_rtype && func == `FUNC_or   );
    wire sll   = (opcode == `OP_rtype && func == `FUNC_sll && (|rd_addr));
    wire sllv  = (opcode == `OP_rtype && func == `FUNC_sllv );
    wire slt   = (opcode == `OP_rtype && func == `FUNC_slt  );
    wire sltu  = (opcode == `OP_rtype && func == `FUNC_sltu );
    wire sra   = (opcode == `OP_rtype && func == `FUNC_sra  );
    wire srav  = (opcode == `OP_rtype && func == `FUNC_srav );
    wire srl   = (opcode == `OP_rtype && func == `FUNC_srl  );
    wire srlv  = (opcode == `OP_rtype && func == `FUNC_srlv );
    wire sub   = (opcode == `OP_rtype && func == `FUNC_sub  );
    wire subu  = (opcode == `OP_rtype && func == `FUNC_subu );
    wire Xor   = (opcode == `OP_rtype && func == `FUNC_xor  );

    assign load   = lw | lh | lhu | lbu | lb;
    assign store  = sw | sh | sb;
    assign branch = beq | bne | blez | bgtz | bgez | bltz;

    assign calc_r = add | addu | sub | subu | slt | sltu |
                    sll | sllv | srl | srlv | sra | srav |
                    And | Or | Xor | Nor; // exclude jr & jalr
    assign calc_i = addi | addiu | andi | ori | xori |
                    slti | sltiu | lui;

    assign shiftS  = sll | srl | sra;
    assign shiftV = sllv | srlv | srav;

    assign j_r = jr | jalr;
    assign j_addr = j | jal;
    assign j_l = jal | jalr;


    ////////////StageD
    assign EXTOp = (addi | addiu | slti | sltiu | load | store); // signed
    // wire unsigned_ext = andi | ori | xori;
    assign Br = branch ? `BR_branch :
                j_addr ? `BR_addr :
                j_r ? `BR_reg :
                `BR_pc4;
    assign B_type = beq  ? `B_beq  :
                    bne  ? `B_bne  :
                    blez ? `B_blez :
                    bgez ? `B_bgez :
                    bgtz ? `B_bgtz :
                    bltz ? `B_bltz :
                    `B_beq;

    ////////////StageE
    assign ALUControl = (sub | subu) ? `ALU_sub :
                        (And | andi) ? `ALU_and :
                        (Or | ori) ? `ALU_or :
                        (Xor | xori) ? `ALU_xor :
                        (Nor) ? `ALU_nor :
                        (sll | sllv) ? `ALU_sll :
                        (srl | srlv) ? `ALU_srl :
                        (sra | srav) ? `ALU_sra :
                        (slt | slti) ? `ALU_slt :
                        (sltu | sltiu) ? `ALU_sltu :
                        (lui) ? `ALU_lui :
                        `ALU_add;
    assign ALUASrc = (shiftS | shiftV) ? `ALUASrcRT : `ALUASrcRS;
    assign ALUBSrc = shiftS ? `ALUBSrcShamt :
                     shiftV ? `ALUBSrcRS_4_0 :
                     (calc_r && !shiftS && !shiftV) ? `ALUBSrcRT :
                     (calc_i | load | store) ? `ALUBSrcExt :
                     `ALUBSrcRT;

    ////////////StageM
    assign DMType = (lw || sw) ? `DM_w :
                    (lh || sh) ? `DM_h :
                    (lhu) ? `DM_hu :
                    (lb || sb) ? `DM_b :
                    (lbu) ? `DM_bu :
                    `DM_w;
    assign DMWr = store;

    ////////////StageW
    assign RFDst   = (calc_r | jalr) ? rd_addr :
                     (calc_i | load) ? rt_addr :
                     (jal) ? 5'd31 :
                     5'd0;
    assign RFWr = calc_r | calc_i | load | j_l;
    assign RFWDSrc = load ? `RFWD_DMout :
                     (jal | jalr) ? `RFWD_PC8 :
                     `RFWD_ALUout;
endmodule