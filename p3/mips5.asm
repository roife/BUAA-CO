.text
ori $t1, 10
LABEL:
beq $t0, $t1, END
addi $t0, $t0, 1
j LABEL
END:
jal TEST

TEST:
lui $t1, 0xffff
jr $ra

#ori $t0, $zero, 0
#ori $t1, $zero, 0xffff
#sh $t1, 0($t0)
#ori $t1, $zero, 9
#sh $t1, 2($t0)
#lw $t2, 0($t0)
#lh $t2, 0($t0)
#lhu $t3, 2($t0)

#lui $t0, 0xffff
#addi $t0, $t0, 0xffff
#addi $t0, $t0, 0xffff
#addi $t0, $t0, 0xffff
#lui $t0, 0
#ori $t0, $t0 0xffff

#lui $t0, 0xffff
#ori $t0, $zero, 0xf
#ori $t1, $zero, 0xf
#subu $t0, $t0, $t1
#addu $t0, $t0, $t1
#addu $t0, $t0, $t1
#subu $t0, $t0, $t1
#subu $t0, $t0, $t1
#or $t0, $t0, $t1
#subu $t0, $t0, $t1
#sll $t0, $t0, 2
#lui $t0, 0
#and $t0, $zero, $zero
#slt $t0, $t0, $t1
#slt $t1, $t0, $t1