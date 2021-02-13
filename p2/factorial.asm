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

.data
	a: .space 800

.text
	RI($s0) # read(n)
	li $t1, 1
	sw $t1, a($zero) # a[0] = 0
	li $s1, 1 # end = 0
	li $t0, 2 # i = 2
	FORi1:
		bgt $t0, $s0, END_FOR_i1
		
		lw $t1, a($zero) # $t2 = a[0]
		mult $t1, $t0 
		mflo $t1
		sw $t1, a($zero)
		
		li $t2, 1 # j = 1
		FORj1:
			bgt $t2, $s1, END_FORj1
			
			sll $t5, $t2, 2
			lw $t1, a($t5)
			mult $t1, $t0
			mflo $t1 # t1 = a[j]*i
			
			subi $t2, $t2, 1
			sll $t5, $t2, 2
			lw $t3, a($t5) # t3 = a[j-1]
			div $t3, $t3, 1000000
			
			mflo $t3 # a[j-1]/1000000
			add $t1, $t1, $t3
			mfhi $t3 # a[j-1]%1000000
			sll $t5, $t2, 2
			sw $t3, a($t5) # a[j-1]
			addi $t2, $t2, 1
			sll $t5, $t2, 2
			sw $t1, a($t5) # a[j]
			
			addi $t2, $t2, 1
			j FORj1
		END_FORj1:
		
		sll $t5, $s1, 2
		lw $t1, a($t5) # a[end+1]
		beqz $t1, ELSE_END
		addi $s1, $s1, 1
		ELSE_END:
		
		addi $t0, $t0, 1
		j FORi1
	END_FOR_i1:
	
	subi $s1, $s1, 1
	move $s2, $s1
	WHILE:
		sll $t5, $s1, 2
		lw $t0, a($t5)
		li $t1, 0
		beq $s1, $s2, END_P
		bgt $t0, 100000, END_P
		PI($t1)
		bgt $t0, 10000, END_P
		PI($t1)
		bgt $t0, 1000, END_P
		PI($t1)
		bgt $t0, 100, END_P
		PI($t1)
		bgt $t0, 10, END_P
		PI($t1)
		END_P:
		
		PI($t0)
		beq $s1, 0, END_WHILE
		subi $s1, $s1, 1
		j WHILE
	END_WHILE:
	
	li $v0, 10
	syscall