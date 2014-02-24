.text
la $s0, mydata

lw $t0, 0($s0)
lw $t1, 4($s0)

add $t2, $t0, $t1

la $s0, trouble
sw $t2, 0($s0)

li $v0, 1
add $a0, $zero, $t2
syscall

li $v0, 10
syscall

.data
mydata: .word 0xBAD
	.word 0xBABE
	
trouble: .word 0
