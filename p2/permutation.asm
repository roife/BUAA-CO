.macro RI(%n)
	li $v0, 5
	syscall
	move %n, $v0
.end_macro

.macro SAVE_LOCAL(%var)
	sw %var 0($sp)
	subi $sp, $sp, 4
.end_macro

.macro LOAD_LOCAL(%var)
	addi $sp, $sp, 4
	lw %var 0($sp)
.end_macro

.macro PI(%n)
    li $v0, 1
    move $a0, %n
    syscall
.end_macro

.macro PSPACE
	la $a0, str_space
	li $v0, 4
	syscall
.end_macro

.macro PENTER
	la $a0, str_enter
	li $v0, 4
	syscall
.end_macro


.data
	arr: .space 24
	sym: .space 24
	str_space: .asciiz " "
	str_enter: .asciiz "\n"

.text
	RI($s0)
	li $a0, 0
	jal FullArray
	li $v0, 10
	syscall

FullArray:
	IF1:
	bne $a0, $s0, ELSE1
	li $t0, 0
	FOR_i1:
		beq $t0, $s0, END_FOR_i1
		sll $t1, $t0, 2
		lw $t2, arr($t1)
		PI($t2)
		PSPACE
		addi $t0, $t0, 1
		j FOR_i1
	END_FOR_i1:
	PENTER
	jr $ra
	ELSE1:
		li $t0, 0
		FOR_i2:
			beq $t0, $s0, END_FOR_i2
			sll $t1, $t0, 2 
			lw $t2, sym($t1)
			bnez $t2, ELSE2
			sll $t3, $a0, 2
			addi $t4, $t0, 1
			sw $t4, arr($t3)
			li $t2, 1
			sw $t2, sym($t1)
			
			SAVE_LOCAL($a0)
			SAVE_LOCAL($t2)
			SAVE_LOCAL($t0)
			SAVE_LOCAL($t1)
			SAVE_LOCAL($ra)
			
			addi $a0, $a0, 1
			jal FullArray
			
			LOAD_LOCAL($ra)
			LOAD_LOCAL($t1)
			LOAD_LOCAL($t0)
			LOAD_LOCAL($a2)
			LOAD_LOCAL($a0)
			
			li $t2, 0
			sw $t2, sym($t1)
			ELSE2:
			addi $t0, $t0, 1
			j FOR_i2
		END_FOR_i2:
		jr $ra
END_FullArray: