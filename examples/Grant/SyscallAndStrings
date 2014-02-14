#

.text
main:
la $a0, Bob	#loads address of Bob into $a0
la $t0, Steve	#loads address of Steve into $t0

li $v0, 4	#defines syscall [Print String] (4)
syscall

move $a0, $t0
li $v0, 4
syscall

li $v0, 10	#defines syscall [Exit] (10)
syscall

.data
Bob: .asciiz "My name is Bob."
Steve: .asciiz "My name is Steve"
