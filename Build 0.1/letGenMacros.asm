# Register Convention:
#	$t0 = Number of letters to generate
#	$s0 = Address of letters in dataMIPS.asm
#
.macro letGen
subi $sp, $sp, 8
sw $s0, 0($sp)
sw $s1, 4($sp)

# Get number of letters
LG_input:
	getIntDialog($v0)
	move $a0, $v0	
	blt $a0, 5, LG_inpRngErr	# Check if int 5 <= x <= 7
	bgt $a0, 7, LG_inpRngErr
	move $t0, $a0			# Move input to temp register
	j LG_storeV
	
# Input Range Error
LG_inpRngErr:
	la $a0, LP_IRE_out		# Load error message
	printStr($a0)			# call print string macro
	j LG_input			# get input again

# Store letter is data file
LG_storeV:
	la $s0, lCount			# Load letter count addr
	sw $t0, 0($s0)			# Store value

LG_letAddr:
	la $s0, letters			# load adress for letters
	subi $t0, $t0, 1		# adjust for vowel bias
	add $s1, $s0, $t0		# Calculate end address

# Generator loop	
LG_Generator:
	li $a1, 26			# Load upper bound of random integer range
	li $v0, 42			# load syscall random int range
	syscall				# random integer will be stored in $a0

	add $a0, $a0, 65		# 65 is the ascii offset of letters in decimal form (ASCII Table) + random int from 0 <= x < 26
	sb $a0, 0($s0)			# save bit in letters address
	add $s0, $s0, 1			# calculate address for next letter
	blt $s0, $s1, LG_Generator	# checking if we've reached our last address for loop

	li $a1, 5
	li $v0, 42
	syscall
	
	la $t1, vowel			# load vowel address
	add $a0, $a0, $a0
	add $a0, $a0, $a0
	add $t1, $t1, $a0		# adjust the address for random vowel
	lb $t0, 0($t1)			# retrieve random vowel
	sb $t0, 0($s0)			# store vowel as last letter
	
lw $s0, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8
.end_macro


.macro letGenStatic
# Store letter is data file
LG_storeV:
	la $s0, lCount			# Load letter count addr
	lw $t0, 0($s0)			# Store value

LG_letAddr:
	la $s0, letters			# load adress for letters
	subi $t0, $t0, 1		# adjust for vowel bias
	add $s1, $s0, $t0		# Calculate end address

# Generator loop	
LG_Generator:
	li $a1, 26			# Load upper bound of random integer range
	li $v0, 42			# load syscall random int range
	syscall				# random integer will be stored in $a0

	add $a0, $a0, 65		# 65 is the ascii offset of letters in decimal form (ASCII Table) + random int from 0 <= x < 26
	sb $a0, 0($s0)			# save bit in letters address
	add $s0, $s0, 1			# calculate address for next letter
	blt $s0, $s1, LG_Generator	# checking if we've reached our last address for loop

	li $a1, 5
	li $v0, 42
	syscall
	
	la $t1, vowel			# load vowel address
	add $a0, $a0, $a0
	add $a0, $a0, $a0
	add $t1, $t1, $a0		# adjust the address for random vowel
	lb $t0, 0($t1)			# retrieve random vowel
	sb $t0, 0($s0)			# store vowel as last letter
.end_macro



# Register Convention:
#	$s0 = addr of letters
#	$s1 = addr of lCount
.macro printLetters
la $s0, letters
la $s1, lCount
	
lw $t0, 0($s1)
beqz $t0, PL_noLet

PL_loopLoad:
	lb $a0, 0($s0)
	printChar($a0)
	addi $s0, $s0, 1
	subi $t0, $t0, 1
	bgtz $t0, PL_loopLoad
	j PL_return

PL_noLet:
	la $a0, PL_NL_out
	printStr($s0)
	j PL_return
	
PL_return:
	li $a0, 10
	printChar($a0)
.end_macro 



.macro getIntDialog(%reg)
# Get Input
GID_inp:
	la $a0, HowManyLet
	li $v0, 51
	syscall

	# Check for ok status
	bnez $a1, GID_inpError
	j GID_return

# Handle input error
GID_inpError:
	beq $a1, -1, GID_IE_1
	beq $a1, -2, GID_IE_2
	beq $a1, -2, GID_IE_3
	
	GID_IE_1:
	la $a0, GID_Err1
	printStr($a0)
	j GID_inp
	
	GID_IE_2:
	la $a0, GID_Err2
	printStr($a0)
	j GID_inp
	
	GID_IE_3:
	la $a0, GID_Err3
	printStr($a0)
	j GID_inp

# Move into return integers
GID_return:
	move %reg, $a0
.end_macro 

#****************************************
#****************************************

.data
HowManyLet:	.asciiz "How many letters (5 ~ 7) do you want to generate: "
GID_Err1:	.asciiz "input data cannot be correctly parsed. try again\n"
GID_Err2:	.asciiz "Im sorry, you cannot quit here. try again\n"
GID_Err3:	.asciiz "OK was chosen but no data had been input into field. try again\n"
LP_IRE_out:	.asciiz "The integer you entered is not between 5 and 7. input valid integer\n"
PL_NL_out:	.asciiz "printLetters: Error, there are no letters to print"

vowel:		.word 65
		.word 69
		.word 73
		.word 79
		.word 85
