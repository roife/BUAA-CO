.data
a:.space 40
.text
jal F
ori $a0, $zero, 0

F:
beq $a0, 10, END_F
addi $a0, $a0, 1
sw $ra, a($t0)
addi $t0, $t0, 4
jal F
addi $t0, $t0, -4
lw $ra, a($t0)
END_F:
jr $ra