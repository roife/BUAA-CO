.text
ori $t0, $zero, 0
ori $t1, $zero, 0xffff
sh $t1, 0($t0)
ori $t1, $zero, 9
sh $t1, 2($t0)
lw $t2, 0($t0)
lh $t2, 0($t0)
lhu $t3, 2($t0)
