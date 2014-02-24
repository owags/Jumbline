.text
la $s6, HEX

lw $s0, 0($s6)
lw $s1, 4($s6)
lw $s2, 8($s6)

sub $s0, $s0, $s1
sub $s0, $s0, $s2
add $s0, $s0, $s1

add $a0, $s0, $zero
li $v0, 34
syscall

li $v0, 10
syscall

.data

HEX:	.word 0xa
	.word 0x14
	.word 0x32