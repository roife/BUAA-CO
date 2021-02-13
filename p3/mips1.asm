.data
arr:.space 40
.text
addi $t0, $t0, -5
ori $s0,10
loop:
	beq $t0,$s0,loop_out
	subu $t1,$t1,$t1
	subu $t4,$t4,$t4
	lj:
		beq $t1,$s0,ljout
			lw $t3,arr($t4)
			addu $t4,$t4,4
			addu $t3,$t3,$t1
			sw $t3,arr($t4)
		addu $t1,$t1,1
		j lj
	ljout:
	addu $t0,$t0,1
	j loop
loop_out:
