.data
num1: .word 0 #we initialize words (bytes) to 0 because we're changing them anyways
num2: .word 0

str1: .space 50

prompt1: .asciiz "Enter str1: "
prompt2: .asciiz "Enter num1: "
prompt3: .asciiz "Enter num2: "

msg1: .asciiz "You entered the string: "
msg2: .asciiz "You entered the numbers "
msg3: .asciiz " and "
newline: .asciiz "\n"

.text
main:
	la $a0, prompt1 #load the address of prompt1 and output it to string
	li $v0, 4
	syscall
	
	la $a0, str1 #load our empty string that will be used as an input buffer
	li $a1, 51 #tells the computer the length of string to expect; why 51??
	li $v0, 8 #call to input a string
	syscall
	
	la $a0, msg1 #print out msg1
	li $v0, 4
	syscall
	
	la $a0, str1 #print out str1 (which now holds actual characters)
	li $v0, 4
	syscall
	
	la $a0, prompt2 #print out prompt2
	li $v0, 4
	syscall

	li $v0, 5 #to read in an integer
	syscall
	sw $v0, num1 #stores integer in num1 RAM location
	
	la $a0, prompt3 #print out prompt3
	li $v0, 4
	syscall
	
	li $v0, 5 #read in integer and store in num2
	syscall
	sw $v0, num2
	
	la $a0, msg2 #print out msg2 to the screen
	li $v0, 4
	syscall
	
	lw $a0, num1 #print out num1
	li $v0, 1
	syscall
	
	la $a0, msg3 #print out msg3, " and "
	li $v0, 4
	syscall
	
	lw $a0, num2 #print out num2
	li $v0, 1
	syscall
	
	la $a0, newline #print out newline
	li $v0, 4
	syscall
	
	li $v0, 10 #exit program
	syscall

