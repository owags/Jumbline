.data
	fileName: .asciiz "/Users/atvaccaro/Google Drive/Programs/MIPS/stuff.txt"
	inputBuffer: .space 20
	newline: .asciiz "\n"

.text
	la $a0, fileName	#Test print out file name
	li $v0, 4
	syscall
	
	la $a0, fileName	#Load name of file
	li $a1, 0		#Read-only flag
	li $a2, 0		#MARS ignores mode anyways, so not needed?
	li $v0, 13		#Open file; file descriptor is now contained in $v0
	syscall
	move $s0, $v0		#Save file descriptor
	
	la $a0, newline		#Print newline
	li $v0, 4
	syscall
	
	move $a0, $s0		#Test print
	li $v0, 1
	syscall
	
	move $a0, $s0		#Transfer file descriptor to $a0
	la $a1, inputBuffer	#Load address of input buffer
	li $a2, 20		#Specify max number of characters to read
	li $v0, 14		#Read the file
	syscall
	move $s1, $v0		#Save how many chars read
	
	la $a0, newline		#Print newline
	li $v0, 4
	syscall
	
	addi $a0, $s1, 0	#Print how many characters read
	li $v0, 1
	syscall
	
	la $a0, newline		#Print newline
	li $v0, 4
	syscall
	
	la $a0, inputBuffer	#Load address of input buffer
	li $v0, 4		#Output the string
	syscall
	
	li $v0, 10		#Exit program
	syscall
