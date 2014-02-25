.text
main:

la $s0, MYHEX
lw $t0, 0($s0)
lw $t1, 4($s0)

sub $t0, $t0, $t1
la $s0, RESULT
sw $t0, 0($s0)

add $a0, $zero, $t0
li $v0, 34
syscall

li $v0, 10
syscall
	
.data
MYHEX:	.word 0xCAFE
	.word 0xABBA
	
RESULT:	.word 0
