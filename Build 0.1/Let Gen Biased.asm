.text

main:
la $a0, HowMany		# set string for dialog
li $v0, 51		# InputDialogInt
syscall

beq $a1, -1, intBadParse	# branch IntDialog error -1
beq $a1, -2, exit		# cancel was selected: exit
beq $a1, -3, noInput		# branch if no value stored
ble $a0, 4, intOutOfRange	# branch if input out of range
bgt $a0, 7, intOutOfRange	# branch if input out of range
add $t9, $a0, $zero		# Stores chosen word length to be used in limiting guess size


la $s0, Letters			# load adress for letters
subi $t0, $a0, 1		# (N - 1) ADJUSTING LETER GENERATOR FOR VOWEL BIAS
add $s1, $t0, $s0		# $s1 the address after the last letter

Generator: 			# Generator loop
li $a1, 26			# Load upper bound of random integer range
li $v0, 42			# load syscall random int range
syscall				# random integer will be stored in $a0

add $t0, $a0, 65		# 65 is the ascii offset of letters in decimal form (ASCII Table) + random int from 0 <= x < 26
sb $t0, 0($s0)			# save bit in letters address
add $s0, $s0, 1			# calculate address for next letter
blt $s0, $s1, Generator		# checking if we've reached our last address for loop


li $a1, 5
li $v0, 42
syscall

la $t1, vowel			# load vowel address
add $a0, $a0, $a0		# double the value for Half Word
add $a0, $a0, $a0		# double the valur for Word
add $t1, $t1, $a0		# adjust the address for random vowel
lw $t0, 0($t1)			# retrieve random vowel
sb $t0, 0($s1)			# store vowel as last letter

Output:

li $v0, 59			#calls message window to show guessing instructions
la $a0, StartGuessMessage
la $a1, Letters
syscall				

j GuessWord			# Jumps to GuessWord code located in included file
				#   where result is displayed and guessing begins

#la $a0, Letters			# load letter address
#li $a1, 1
#li $v0, 55
#syscall

#j exit

# ******************************************
# Below are precautions for input error and exit function
# ******************************************

intOutOfRange:
la $a0, IOOR		# set string for dialog IOOR
li $v0, 50		# ConfirmDialog
syscall

bgtz $a0, exit		# if select (no or cancel), exit
j main			# else: start over


intBadParse:
la $a0, IBP		# set string for dialog IBP
li $v0, 50		# ConfirmDialog

bgtz $a0, exit		# if select (no or cancel), exit
j main			# else: start over


noInput:
la $a0, NoInp		# set string for dialog IOOR
li $v0, 50		# ConfirmDialog
syscall

bgtz $a0, exit		# if select (no or cancel), exit
j main			# else: start over


exit:
li $v0, 10
syscall

.data

HowMany: 	.asciiz "How many letters would you like generated? (Min 5 <-> Max 7)"
IOOR:		.asciiz "Integer enetered is out of range. Try again?"
IBP:		.asciiz "Error -1: input data cannot be correctly parsed"
NoInp:		.asciiz "Woops! you didn't enter anything, Try again?"
StartGuessMessage: 	.ascii "INPUT RULES:\n\n"
			.ascii "* Input MUST be CAPITALIZED LETTERS ONLY\n"
			.ascii "* Word guesses can be as short as 2 letters.\n"
			.ascii "* To Shuffle: Press Enter with blank input\n"
			.asciiz "* Words must be combinations of following letters: \n\n"

Letters:	.space 8


vowel:		.word 65	# A
		.word 69	# E
		.word 73	# I
		.word 79	# 0
		.word 85	# u
		

