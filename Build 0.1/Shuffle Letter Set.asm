# Shuffle generated letter set function.
# Input = Letter Array from Let Gen
# Process = Uses randomly generate multiplication factor and a mod function to randomize 
#           the position of current letter in theLetter Array. Uses temp Randomized Array for data.
# Output = Data is copied back into Letter Array for 'Guess Input' to use.
# NO save registers were used.

.data
RandomizedArray: 	.space 7	#Holds new set of letters after randomization
exitString: 		.asciiz "Execution has EXITED."

.text
# reg used: $s5, $a1, $a0
# thrown onto stack
ShuffleLetters:

#li $t9, 7
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
		la $t0, Letters		#store base address of original Letters array
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
		la $t1, Letters			# Load address Letters Array
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

	
