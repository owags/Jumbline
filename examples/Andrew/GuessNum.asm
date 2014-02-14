.data
	promptLimit: .asciiz "Enter a max number (answer will be 1<=ans<=max): "
	promptGuess: .asciiz "Enter a guess: "
	
	promptCorrect: .asciiz "Correct! It took you "
	promptCorrect2: .asciiz " guesses."
	
	promptIncorrect: .asciiz "That guess is incorrect."
	
	newline: .asciiz "\n"
.text
	la $a0, promptLimit	#Print initial prompt
	li $v0, 4
	syscall
	
	li $v0, 5		#Read in integer
	syscall
	move $s0, $v0		#Store in $s0
	
	li $a0, 0		#Specifies PRNG 0
	li $a1, 1		#Sets seed of PRNG 0
	li $v0, 40
	syscall
	
	li $a0, 0		#Specifies PRNG 0
	move $a1, $s0
	li $v0, 42
	syscall
	addi $s0, $a0, 1	#Add 1 to the result and store
	
	move $a0, $s0		#Test print
	li $v0, 1
	syscall
	