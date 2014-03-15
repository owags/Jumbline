# Word Guessing Screen

#INFO:
#This object file will analyze the user guess and create a binary array from it.

#Nomencalture used:
	#Letters Array: the array of randomly generated letters from previous object file.
	#Input Array: the array containing the user guess.
	#Binary Array: the array that will symbolize the proper use of guessed leters via binary.
		#This array will be used to check if all the letters guess were in the Letters array.


.data
Test: 			.asciiz " "
MatchFoundTest: 	.asciiz "MATCH FOUND :)"
validGuessConfirm: 	.asciiz "Your guess is valid! \n Continue Playing?"
ExitString: 		.ascii "The word you have entered is invalid:\n-Invalid letters used\n OR\n-Too many letters used\n\n Choose YES to guess again."
			.asciiz "\nNO to EXIT"
WordBinaryArray: 	.space 7
Seperator: 		.ascii "y"
Input: 			.space 8






.text
	#Macros:		
		.macro clearArrays

			
			#clear Input Array (8 bytes)
			la $s0, Input		#Reset $s0 to point to start of Input Array
			sb $zero, 0($s0)
			sb $zero, 1($s0)
			sb $zero, 2($s0)
			sb $zero, 3($s0)
			sb $zero, 4($s0)
			sb $zero, 5($s0)
			sb $zero, 6($s0) 
			sb $zero, 7($s0)
	
			#Clear Binary Array (7 bytes)
			la $s1, WordBinaryArray	#Reset $s1 to point to start of Binary Array
			sb $zero, 0($s1)
			sb $zero, 1($s1)
			sb $zero, 2($s1)
			sb $zero, 3($s1)
			sb $zero, 4($s1)
			sb $zero, 5($s1)
			sb $zero, 6($s1)
			
		.end_macro
		
	
#############################
# Validate Guess Input 	    #
#############################	

#Displaying Random Letters and Guessing Input Screen


GuessWord:
la $a0, Letters		# load letter address
la $a1, Input
addi $a2, $t9, 1		#Set max letters read into input array to value in $t9 (holds length chosen by user from previous code)
li $v0, 54
syscall			#calls input dialog to analyze guess

#Analyzing Guess String
	#User guess is an array that starts at input address
	la $s0, Input		#original address for reference 
	la $s1, WordBinaryArray	#original address
	la $s2, Letters		#original address
	
	
	while:
		lb $t0, ($s0)		#load temp Input for comparison
		lb $t2, ($s2)
		beq $t0, 10, validGuess		#If Input Array has new line char, means end reached with no errors, guess is valid
		beq $t0, $zero, validGuess	#First input does not register /n char, therefore if Input Array reaches null, aso valid guess
		beq $t2, $zero, error1		#Checks if Letter Array is null, this means that letter guessed was not found, must exit
		beq $t2, $t0, matchFound	#If Generated letter matches Guessed letter
	
	#else
		addi $s2, $s2, 1	#incriment Input Array to next byte
		addi $s1, $s1, 1	#incriment Binary Array to next byte 
		j while
	
		matchFound:
			#if Binary Array is not empty, that means letter has already been used
			lb $t1, ($s1)
			bne $t1, $zero, skip	#if binary array is not empty, it means this letter has already been used
			j addToBinaryArray	#Since match is found, array at this position must be updated.
			
			skip: 	#This will skip to next position in Letter and Binary array anc continue search
			addi $s2, $s2, 1	#increment Letter Array
			addi $s1, $s1, 1	#increment Binary Array
			j while
		addToBinaryArray:
		#li $v0, 59			#Test to confirm match found
		#la $a0, MatchFoundTest
		#la $a1, Test
		#syscall
		
		sb $t2, ($s1)			#Store the letter match into binary array
		la $s2, Letters			#reset Letters Array to starting position to begin new comparison
		la $s1, WordBinaryArray		#Reset Binary array to original position to being new comparison
		addi $s0, $s0, 1	#incriment Input Array by 1 to next position 
		j while

			
	error1:  #If Letters array reaches null position = invalid letter OR too long: must EXIT/RETRY
	
	li $v0, 50
	la $a0, ExitString
	la $a1, Test
	syscall
	
 	clearArrays #Macro
		
	beq $a0, 0, GuessWord  #if yes is chosen, program branches to top for new guess. Else exit program
	
	exit1:	
	li $v0, 17   #prog terminates
	la $a0, Test
	syscall
	
		#Need To CLEAR Input and Binary arrays to prepare for next guess
		
	
	validGuess: #If Input array reaches null position, this means all letters match those in random Letters Array. guess is valid
	
	li $v0, 50
	la $a0, validGuessConfirm
	syscall
	beq $a0, 1, exit1	#Terminate program if NO chosen
	beq $a0, 2, exit1	#Terminate program if CANCEL chosen
	
	clearArrays #Macro
	
	j GuessWord
	
