.data
	mat1: .space 256
	mat2: .space 256
	str_space: .asciiz " "
	str_enter: .asciiz "\n"

.macro INDEX(%ans, %i, %j, %rank)
	multu %i, %rank
	mflo %ans
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

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

.text
	RI($s0)
	li $t0, 0
	FOR_i1:
		beq $t0, $s0, END_FOR_i1
		li $t1, 0
		FOR_j1:
			beq $t1, $s0, END_FOR_j1
			li $t2, 8
			INDEX($t3, $t0, $t1, $t2)
			RI($t4)
			sw $t4, mat1($t3)
			addi $t1, $t1, 1
			j FOR_j1
		END_FOR_j1:
		addi $t0, $t0, 1
		j FOR_i1
	END_FOR_i1:
	
	li $t0, 0
	FOR_i2:
		beq $t0, $s0, END_FOR_i2
		li $t1, 0
		FOR_j2:
			beq $t1, $s0, END_FOR_j2
			li $t2, 8
			INDEX($t3, $t0, $t1, $t2)
			RI($t4)
			sw $t4, mat2($t3)
			addi $t1, $t1, 1
			j FOR_j2
		END_FOR_j2:
		addi $t0, $t0, 1
		j FOR_i2
	END_FOR_i2:
	
	li $t0, 0
	FOR_i3:
		beq $t0, $s0, END_FOR_i3
		li $t1, 0
		FOR_j3:
			beq $t1, $s0, END_FOR_j3
			li $t2, 8
			INDEX($t3, $t0, $t1, $t2)
			li $t4, 0
			li $t5, 0
			FOR_k3:
				beq $t4, $s0, END_FOR_k3
				INDEX($t6, $t0, $t4, $t2)
				lw $t7, mat1($t6)
				INDEX($t6, $t4, $t1, $t2)
				lw $t8, mat2($t6)
				
				mult $t7, $t8
				mflo $t7
				add $t5, $t5, $t7
				addi $t4, $t4, 1
				j FOR_k3
			END_FOR_k3:
			PI($t5)
			
			la $a0, str_space
			li $v0, 4
			syscall
			
			addi $t1, $t1, 1
			j FOR_j3
		END_FOR_j3:
		
		la $a0, str_enter
		li $v0, 4
		syscall
		addi $t0, $t0, 1
		j FOR_i3
	END_FOR_i3:
	