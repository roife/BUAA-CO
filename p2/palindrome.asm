.macro RI(%n)
	li $v0, 5
	syscall
	move %n, $v0
.end_macro

.macro RC(%c)
	li $v0, 12
	syscall
	move %c, $v0
.end_macro

.macro PI(%n)
	move $a0, %n
	li $v0, 1
	syscall
.end_macro

.data
	str: .byte 20

.text
	RI($s0)
	li $t0, 0
	
	FOR_i1:
		beq $t0, $s0, END_FOR_i1
		RC($t1)
		sb $t1, str($t0)
		addi $t0, $t0, 1
		j FOR_i1
	END_FOR_i1:
	
	li $t0, 0
	subi $t1, $s0, 1
	
	WHILE:
		bge $t0, $t1, END_WHILE_OK
		lb $t2, str($t0)
		lb $t3, str($t1)
		bne $t2, $t3, END_WHILE
		addi $t0, $t0, 1
		subi $t1, $t1, 1
		j WHILE
	END_WHILE:
	li $t0, 0
	PI($t0)
	li $v0, 10
	syscall
	
	END_WHILE_OK:
	li $t0, 1
	PI($t0)
	li $v0, 10
	syscall