.data
stringstore:	.space 20

.text
main:
	la $s0, stringstore #Loads the address of stringstore into $s0, which is a saved register
	
	li $t1, 'H' #loads a literal 'H' into $t1
	sb $t1, ($s0) #stores the contents of $t1 at the address held by $s0, not $s0 itself
	addi $s0, $s0, 1 #increments the address stored at $s0
	
	li $t1, 'e'
	sb $t1, ($s0)
	addi $s0 $s0 1
	
	li $t1 'l'
	sb $t1 ($s0)
	addi $s0 $s0 1
	sb $t1 ($s0) #don't have to put 'l' into $t1, cause it's already there
	addi $s0 $s0 1
	
	li $t1 'o'
	sb $t1 ($s0)
	addi $s0 $s0 1
	
	li $t1, '\n' #newline, may or may not work
	sb $t1, ($s0)
	addi $s0, $s0, 1
	
	sb $zero, ($s0) #store null terminator in last space of array
	
	la $a0, stringstore #loads address of complete string for output; $a0 is the first argument for syscalls
	
	li $v0, 4 #for outputting a string
	syscall
	
	li $v0, 10 #exit the program
    	syscall
	
	
