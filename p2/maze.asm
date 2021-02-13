.macro RI(%n)
	li $v0, 5
	syscall
	move %n, $v0
.end_macro

.macro PI(%n)
	li $v0, 1
	move $a0, %n
	syscall
.end_macro

.macro INDEX(%ans, %i, %j)
	sll %ans, %i, 3
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.macro LOAD_LOCAL(%n)
	addi $sp, $sp, 4
	lw %n, 0($sp)
.end_macro

.macro SAVE_LOCAL(%n)
	sw %n, 0($sp)
	subi $sp, $sp, 4
.end_macro

.data
	a: .space 200
	
.text
	RI($s0) # n
	RI($s1) # m
	li $t0, 0 # i
	FORi1:
		beq $t0, $s0, END_FORi1
		li $t1, 0 # j
			FORj1:
				beq $t1, $s1, END_FORj1
				INDEX($t2, $t0, $t1)
				RI($t3)
				sw $t3, a($t2)
				addi $t1, $t1, 1
				j FORj1
			END_FORj1:
		addi $t0, $t0, 1
		j FORi1
	END_FORi1:
	
	RI($s2) # start_i
	RI($s3) # start_j
	RI($s4) # end_i
	RI($s5) # end_j
	subi $s2, $s2, 1
	subi $s3, $s3, 1
	subi $s4, $s4, 1
	subi $s5, $s5, 1
	
	li $s6, 0 # ans
	move $a0, $s2 # a
	move $a1, $s3 # b
	INDEX($t0, $s2, $s3)
	li $t1, 2
	sw $t1, a($t0)
	jal DFS
	
	PI($s6)
	
	li $v0, 10
	syscall
DFS:
	bne $a0, $s4, ELSE1
	bne $a1, $s5, ELSE1
	li $t0, 0
	addi $s6, $s6, 1
	jr $ra
	ELSE1:
		INDEX($t0, $a0, $a1)
		li $t1, 2
		sw $t1, a($t0)
		# left
		beqz $a1, ELSE_LEFT2
		subi $a1, $a1, 1
		INDEX($t0, $a0, $a1)
		lw $t1, a($t0)
		bne $t1, 0, ELSE_LEFT1
		
		SAVE_LOCAL($a0)
		SAVE_LOCAL($a1)
		SAVE_LOCAL($ra)
		
		jal DFS
		
		LOAD_LOCAL($ra)
		LOAD_LOCAL($a1)
		LOAD_LOCAL($a0)
		
		ELSE_LEFT1:
		addi $a1, $a1, 1
		ELSE_LEFT2:
		
		# right
		addi $a1, $a1, 1
		beq $a1, $s1, ELSE_RIGHT1
		INDEX($t0, $a0, $a1)
		lw $t1, a($t0)
		bne $t1, 0, ELSE_RIGHT1
		
		SAVE_LOCAL($a0)
		SAVE_LOCAL($a1)
		SAVE_LOCAL($ra)
		
		jal DFS
		
		LOAD_LOCAL($ra)
		LOAD_LOCAL($a1)
		LOAD_LOCAL($a0)
		
		ELSE_RIGHT1:
		subi $a1, $a1, 1
		
		# up
		beqz $a0, ELSE_UP2
		subi $a0, $a0, 1
		INDEX($t0, $a0, $a1)
		lw $t1, a($t0)
		bne $t1, 0, ELSE_UP1
		
		SAVE_LOCAL($a0)
		SAVE_LOCAL($a1)
		SAVE_LOCAL($ra)
		
		jal DFS
		
		LOAD_LOCAL($ra)
		LOAD_LOCAL($a1)
		LOAD_LOCAL($a0)
		
		ELSE_UP1:
		addi $a0, $a0, 1
		ELSE_UP2:
		
		# down
		addi $a0, $a0, 1
		beq $a0, $s0, ELSE_DOWN1
		INDEX($t0, $a0, $a1)
		lw $t1, a($t0)
		bne $t1, 0, ELSE_DOWN1
		
		SAVE_LOCAL($a0)
		SAVE_LOCAL($a1)
		SAVE_LOCAL($ra)
		
		jal DFS
		
		LOAD_LOCAL($ra)
		LOAD_LOCAL($a1)
		LOAD_LOCAL($a0)
		
		ELSE_DOWN1:
		subi $a0, $a0, 1
			
		INDEX($t0, $a0, $a1)	
		li $t1, 0
		sw $t1, a($t0)
		jr $ra
END_DFS:
	