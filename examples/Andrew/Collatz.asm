.data
	prompt1: .asciiz "Enter a number: "
	newline: .asciiz "\n"

.text
	la $a0, prompt1		#Print prompt
	li $v0, 4
	syscall
	
	li $v0, 5		#Get integer, store in $s0
	syscall
	move $s0, $v0

START:
	move $a0, $s0		#Print out $s0
	li $v0, 1
	syscall
	
	la $a0, newline		#Print newline
	li $v0, 4
	syscall
	
	beq  $s0, 1, EXIT	#If $s0 == 1, EXIT; otherwise, continue
	
	li $t0, 2		#Obtain $s0 mod $t0 and store it in $t1
	div $s0, $t0
	mfhi $t1
	
	beq $t1, 1, IFODD	#If number is odd
	
	div $s0, $s0, 2		#Else, if even divide by two
	j START			#Jump to START
	
IFODD:
	mul $s0, $s0, 3		#Multiply by 3
	addi $s0, $s0, 1	#Add 1
	
	j START			#Jump to START
	
EXIT:
	li $v0, 10		#Exit program
	syscall
