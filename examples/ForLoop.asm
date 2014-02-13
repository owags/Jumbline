.data
	newline: .asciiz "\n"

.text
		li $s0, 0		#Initial
	START:
		bge $s0, 5, EXIT	#Jump to EXIT if $t1 >= 5
		
		move $a0, $s0		#Print out contents of $s0
		li $v0, 1
		syscall
		
		la $a0, newline		#Print out newline
		li $v0, 4
		syscall
		
		addi $s0, $s0, 1	#Increment $s0
		
		j START
	
	EXIT: 