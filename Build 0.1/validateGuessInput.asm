# Word Guessing Screen

#INFO:
#This object file will analyze the user guess and create a binary array from it.

#Nomencalture used:
	#letters Array: the array of randomly generated letters from previous object file.
	#Input Array: the array containing the user guess.
	#Binary Array: the array that will symbolize the proper use of guessed leters. Used as a comparison.
		#This array will be used to check if all the letters guess were in the letters array.


.data
StartGuessMessage: 	.ascii "INPUT RULES:\n\n"
			.ascii "* Input MUST be CAPITALIZED LETTERS ONLY\n"
			.ascii "* Word guesses can be as short as 2 letters.\n"
			.ascii "* To Shuffle: Press Enter with blank input\n"
			.asciiz "* Words must be combinations of following letters: \n\n"
			
RandomizedArray: 	.space 7	#Holds new set of letters after randomization
exitString: 		.asciiz "Execution has EXITED."
			
Test: 			.asciiz " "
MatchFoundTest: 	.asciiz "MATCH FOUND :)"
validGuessConfirm: 	.asciiz "Your guess is valid! \n Continue Playing?"
tooMany:		.asciiz "You have entered too many characters!\n\n Would you like to try again?"
letNotFound:		.asciiz "Character(s) you have used are not allowed.\nPlease use only the letters from generated list.\n\n Would you like to try again?"
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

#Displaying Random letters and Guessing Input Screen


				
.macro validateGuessInput

	clearArrays	#macro to clear all arrays
	
			la $t9, lCount 	# This loads letter count into a global $t9 register
			lw $t9, 0($t9)	
			
#######
# Syscall to display guessing instructions. Needed this to test linear model.
######

	#li $v0, 59			#calls message window to show guessing instructions
	#la $a0, StartGuessMessage
	#la $a1, letters
	#syscall									
									
												
																		
GuessWord:

			
la $a0, letters		# load letter address
la $a1, Input
addi $a2, $t9, 2		#Reads in extra characters to know if too many are present
li $v0, 54
syscall			#calls input dialog to analyze guess
beq $a1, -2, exit1
beq $a1, -3, Shuffleletters

#Analyzing Guess String
	#User guess is an array that starts at input address
	la $s0, Input		#original address for reference 
	la $s1, WordBinaryArray	#original address
	la $s2, letters		#original address
	
	#Check if there are too many characters for input
	add $t0, $t9, $s0	# add base input array + offset,
	lb $t1, 0($t0)		# load byte at current position.
	bgt $t1, 31, tooManyError	# anything above ascii 31 is a potential character
	
	#Force lower case characters to upper case
				# This works by checkin the range for lower case, forcing to upper, and exiting if MAX position is reached
	add $t1, $s0, $t9		#Set $t1 to MAX input postion in array, this keeps track for "exitCondition" below
	loopInputToUpper:
		lb $t0, ($s0)
		bgt $t0, 122, letNotFoundError	#if input ascii is greater than 122 "z" than it is not a lower case letter, jump to error
		bge $t0, 97, letIsLowerCase  	#if input ascii is greater or equal to 97 "a" then it is a lower case
		nextInputLetter: 
			addi $s0, $s0, 1		#If failed, go to next letter	
			beq  $s0, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToUpper
		
		letIsLowerCase: 
			addi $t0, $t0, -32	# force to upper case
			sb $t0 ($s0)		# store into Input Array
			addi $s0, $s0, 1	# increment Input array position
			beq  $s0, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToUpper
			
		exitCondition: 
			la $s0, Input		# make $s0 original address of Input Array
						# if exit, allow to continue with rest of code
		
	
	#Allow "Press Enter to Shuffle" command
	lb $t0, ($s0)			#Load character at base address of Input Array
	beq $t0, $zero, Shuffleletters	#If input is '0' do shuffle command
	
	
	while:
		lb $t0, ($s0)		#load temp Input for comparison,
		lb $t2, ($s2)		#letters Array
		beq $t0, 10, validGuess		#If Input Array has new line char, means end reached with no errors, guess is valid
		beq $t0, $zero, validGuess	#First input does not register /n char, therefore if Input Array reaches null, also valid guess
		beq $t2, $zero, letNotFoundError #Checks if Letter Array is null, this means that letter guessed was not found, must exit
		beq $t2, $t0, matchFound	#If Generated letter matches Guessed letter
	
	#else
		addi $s2, $s2, 1	#incriment Input Array to next byte
		addi $s1, $s1, 1	#incriment Binary Array to next byte 
		j while
	
		matchFound:
			#if Binary Array at current position is not empty, that means letter has already been used
			lb $t1, ($s1)
			bne $t1, $zero, skip	#if binary array is not empty, it means this letter has already been used
			j addToBinaryArray	#Since match is found, array at this position must be updated.
			
			skip: 			#This will skip to next position in Letter and Binary array and continue search
			addi $s2, $s2, 1	#increment Letter Array
			addi $s1, $s1, 1	#increment Binary Array
			j while
		addToBinaryArray:
		
		sb $t2, ($s1)			#Store the letter match into binary array
		la $s2, letters			#reset letters Array to starting position to begin new comparison
		la $s1, WordBinaryArray		#Reset Binary array to original position to being new comparison
		addi $s0, $s0, 1		#incriment Input Array by 1 to next position 
		j while
		
	######	
	#ERROR MESSAGES
	#####
	tooManyError: 		la $a0, tooMany
				j error1
			
	genError: 		la $a0, ExitString
				j error1
			
	letNotFoundError: 	la $a0, letNotFound
			  	j error1
					
	error1:  #If letters array reaches null position = invalid letter OR too long: must EXIT/RETRY
	
		li $v0, 50
		la $a1, Test
		syscall
	
 		clearArrays #Macro
		
		beq $a0, 0, GuessWord  #if yes is chosen, program branches to top for new guess. Else exit program
		beq $a0, 1, exit1	#Terminate program if NO chosen
		beq $a0, 2, exit1	#Terminate program if CANCEL chosen
	
	
	
	
	exit1:	
		li $v0, 17   #prog terminates
		la $a0, Test
		syscall
	

	
	
	
	
	
	
	
	
#############################
# Shuffle Letters Function  #
#############################
	
# Shuffle generated letter set function.
# Input = Letter Array from Let Gen
# Process = Uses randomly generate multiplication factor and a mod function to randomize 
#           the position of current letter in theLetter Array. Uses temp Randomized Array for data.
# Output = Data is copied back into Letter Array for 'Guess Input' to use.
# NO save registers were used.	
	
	
	
	
	
	
	
Shuffleletters:
	
	RandFactorGen:		#These instructions will generate a random number to be used as a factor for letter position randomization
	move $a1, $t9		#set $a1 as upper bound, $t9 is length of word generated
	 
	li $v0, 42
	syscall			#generates a number 0 - $t9, sores in $a0
	
	beq $a0, $zero, RandFactorGen	# we don't want 0, if generated, redo
	
	
	RandLoop:
	li $t5, 0		# $t5 will be the index, set to 0 initial
	
	Lc1: 
	beq $t5, $t9, CopyToLettersArray	# If index is max, branch to exit (do while index < max), branch to copy array back into Letters
		traverse:		#Traverse Letters Array
		la $t0, letters		#store base address of original Letters array
		add $t0, $t0, $t5	#add index to address value to be able to traverse
		lb $t2, 0($t0)		# load letter into $t2
		
		transferToRandomizedArray:	#store current letter into new position in Randomized Array
		la $t0, RandomizedArray
			jal factorization
		
		add $t0, $t0, $v0 	# Add factor value #v0, to base address $t0, and store in $t1
		sb $t2, 0($t0)		# store letter in $t2, into randomized array at position $t1
		
		
		
	addi $t5, $t5, 1	# Increments index 0 to max($t9)
	j Lc1			#loop back around unitl max value is reached
	

CopyToLettersArray:		# Copy Randomized Array into Letter Array
	li $t5, 0		#initialize index $t5 to 0
	
	Lc2: 			# Loop will copy Randomized Array into Letter Array
	beq $t5, $t9, GuessWord
		la $t0, RandomizedArray		# load address Randomized Array
		la $t1, letters			# Load address Letters Array
		add $t0, $t0, $t5		# Index offset + Randomized Array base address, store in $t0
		lb $t2, 0($t0)			# Load character in Randomized Array into $t2
		add $t0, $t1, $t5		# Index offset + Letters Array base address, store in $t0
		sb $t2, 0($t0)			# Store character in Letters Array
	addi $t5,$t5, 1
	j Lc2 
	
	
	
	
	
	
	
	##Subroutines##
	
	
	factorization: 			#purpose: generate new position for letters to be stored in
	
		beq $t9, 6, factorization2
		mulou $v0, $a0, $t5	#Multiplication factor = random value(a0) x index($t5)
		addi $v0, $v0, 1	#Addition factor = current value + 1
		div  $v0, $t9		# modulo new factored value (value mod max)
		mfhi $v0		# store modulo value (hi register) into result $v0
		jr $ra			# return to caller
	
	####
	# $t9 = 6 means, X mod 6, this creates problems since 6 is NOT PRIME. 
	# Special case when 6, using mod 7 gives most ramoized results when combines with constant 2
	####	
	
	factorization2:			
		li $a0, 2		# set random factor to a constant 2
		li $t8, 7		#set $t8 to 7, will be used as mod
		mulou $v0, $a0, $t5	#Multiplication factor = random value(a0) x index($t5)
		addi $v0, $v0, 1	#Addition factor = current value + 1
		div $v0, $t8		# modulo new factored value (value mod 7)
		mfhi $v0		# store modulo value (hi register) into result $v0
		jr $ra			# return to caller
		
	
		
	#.include "Shuffle Letter Set.asm"
	

	validGuess:
		#If guess is valid. End the macro.
		# Correct input is stored in Input Array
.end_macro 
	

