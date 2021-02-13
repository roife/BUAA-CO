.data
	mat1: .space 400
	mat2: .space 400
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
	RI($s0) # m1
	RI($s1) # n1
	RI($s2) # m2
	RI($s3)	# n2
	li $t0, 0
	FOR_i1:
		beq $t0, $s0, END_FOR_i1
		li $t1, 0
		FOR_j1:
			beq $t1, $s1, END_FOR_j1
			li $t2, 10
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
		beq $t0, $s2, END_FOR_i2
		li $t1, 0
		FOR_j2:
			beq $t1, $s3, END_FOR_j2
			li $t2, 10
			INDEX($t3, $t0, $t1, $t2)
			RI($t4)
			sw $t4, mat2($t3)
			addi $t1, $t1, 1
			j FOR_j2
		END_FOR_j2:
		addi $t0, $t0, 1
		j FOR_i2
	END_FOR_i2:
	
	li $t0, 0 # i
	sub $s0, $s0, $s2
	addi $s0, $s0, 1
	sub $s1, $s1, $s3
	addi $s1, $s1, 1
	FOR_i3:
		beq $t0, $s0, END_FOR_i3
		li $t1, 0 # j
		FOR_j3:
			beq $t1, $s1, END_FOR_j3
			li $t3, 0 # sum
			
			li $t4, 0 # k
			FOR_k3:
				beq $t4, $s2, END_FOR_k3
				li $t5, 0 # l
				
				FOR_l3:
					beq $t5, $s3, END_FOR_l3
					add $t6, $t0, $t4
					add $t7, $t1, $t5
					li $t8, 10
					INDEX($t9, $t6, $t7, $t8)
					lw $s4, mat1($t9)

					li $t8, 10
					INDEX($t9, $t4, $t5, $t8)
					lw $s5, mat2($t9)
					
					mult $s4, $s5
					mflo $s6
					
					add $t3, $t3, $s6
					
					addi $t5, $t5, 1
					j FOR_l3
				END_FOR_l3:
				
				addi $t4, $t4, 1
				j FOR_k3
			END_FOR_k3:
			
			PI($t3)
			
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
	
	li $v0, 10
	syscall
	