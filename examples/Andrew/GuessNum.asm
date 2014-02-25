.data
	scoresFile: .asciiz "/Users/atvaccaro/Google Drive/Programs/MIPS/scores.txt"
	promptLimit: .asciiz "Enter a max number (answer will be 1<=ans<=max): "
	promptGuess: .asciiz "Enter a guess: "
	
	promptCorrect: .asciiz "Correct! It took you "
	promptCorrect2: .asciiz " guesses."
	
	promptLow: .asciiz "That guess is too low."
	promptHigh: .asciiz "That guess is too high."
	
	newline: .asciiz "\n"
.text
	li $s2, 0		#Counter register
	
	la $a0, promptLimit	#Print promptLimit
	li $v0, 4
	syscall
	
	li $v0, 5		#Read in integer
	syscall
	move $s0, $v0		#Store in $s0
	
	li $v0, 30		#Get system time
	syscall
	move $t1, $a0		#Store lower half in $t1
	li $a0, 0		#Specifies PRNG 0
	move $a1, $t1
	li $v0, 40
	syscall
	
	li $a0, 0		#Specifies PRNG 0
	move $a1, $s0
	li $v0, 42
	syscall
	addi $s0, $a0, 1	#Add 1 to the result and store
	
MAIN:
	la $a0, promptGuess	#Prompt for a guess
	li $v0, 4
	syscall
	
	li $v0, 5		#Get a guess
	syscall
	move $s1, $v0
	
	addi $s2, $s2, 1	#Increment counter
	
	beq $s0, $s1, CORRECT	#If correct
	
TOOHIGH:
	blt $s1, $s0, TOOLOW	#If guess is too low
	
	la $a0, promptHigh	#Print incorrect message
	li $v0, 4
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	j MAIN
	
TOOLOW:
	la $a0, promptLow
	li $v0, 4
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	j MAIN

CORRECT:
	la $a0, promptCorrect	#Print first half of correct message
	li $v0, 4
	syscall
	
	move $a0, $s2		#Print counter
	li $v0, 1
	syscall
	
	la $a0, promptCorrect2	#Print second half of correct message
	li $v0, 4
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall

EXIT:
	li $v0, 10
	syscall
