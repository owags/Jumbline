# this will print the word bank
.macro printWordBank
li $t0, 0

pwb_loop:
lb $t1, wordBank($t0)
addi $t0, $t0, 1
printChar($t1)
blt $t0, 140, pwb_loop

li $t0, 10
printChar($t0)
.end_macro



# This will reset a bool check for which words have been guessed
#	1 = guessed
#	0 = not guessed
.macro reset_wlBoolCheck
subi $sp, $sp, 8
sw $t0, 0($sp)
sw $t1, 4($sp)

la $t0, wlBoolCheck
addi $t1, $t0, 20
res_loop:
sb $zero, 0($t0)
addi $t0, $t0, 1
blt $t0, $t1, res_loop

lw $t0, 0($sp)
lw $t1, 4($sp)
addi $sp, $sp, 8
.end_macro




# Called if the input matches a given word in the word bank
# This will set the words current position to guessed with the boolcheck
#	1 = word hasn't been guessed
#	0 = word already guessed
.macro wlSetBool(%bool)
lw $t0, wbBuffOff($zero)
div $t1, $t0, 7
lb $t0, wlBoolCheck($t1)
bnez $t0, alreadyGuessed
addi $t0, $t0, 1
sb $t0, wlBoolCheck($t1)
j wlsb_return

alreadyGuessed:
add $t0, $zero, $zero
j wlsb_return

wlsb_return:
move %bool, $t0
.end_macro




# gets the next word in the wordBank
#	return 0 if there was nothing read (end of word bank)
#	return 1 if read was successful
.macro nextBankWord(%bool)
subi $sp, $sp, 4

# if the the wbCount * 7 = wbBuffOff. then there are no more words
lw $t1, wbCount($zero)
li $t2, 7
mult $t1, $t2		
mflo $t1
lw $t0, wbBuffOff($zero)
beq $t1, $t0, nbw_end

lw $t1, wbBuffOff
la $t0, wordBank
add $t0, $t0, $t1	# t0 = word address
la $t1, wbBuffer	# t1 = buffered word
addi $t2, $t1, 7	# t2 = end of t1 addr

nbw_loop:
lb $t3, 0($t0)
sb $t3, 0($t1)
addi $t0, $t0, 1
addi $t1, $t1, 1
blt $t1, $t2, nbw_loop

lw $t1, wbBuffOff	# add 7 to offset
addi $t1, $t1, 7
sw $t1, wbBuffOff

li $t0, 1		# set bool to 1
move %bool, $t0
j nbw_return

nbw_end:	
sw $zero, wbBuffOff	# reset offset, since theres no more to read
move %bool, $zero	# set bool to 0

nbw_return:
addi $sp, $sp, 4
.end_macro





# Compares Words
#	0 = words do not match
#	1 = words match
.macro compWord(%bool)
subi $sp, $sp, 12
la $t0, inputBuffer
sw $t0, 0($sp)
la $t0, wbBuffer
sw $t0, 4($sp)
addi $t0, $t0, 7
sw $t0, 8($sp)

cw_loop:
lw $t0, 0($sp)
lb $t1, 0($t0)
addi $t0, $t0, 1
sw $t0, 0($sp)
blt $t1, 91, continue
subi $t1, $t1, 32
continue:
lw $t0, 4($sp)
lb $t2, 0($t0)
addi $t0, $t0, 1
sw $t0, 4($sp)
sub $t1, $t1, $t2
bnez $t1, notSame
lw $t0, 4($sp)
lw $t1, 8($sp)
blt $t0, $t1, cw_loop
j SameWord

notSame:
move %bool, $zero
j cw_return

SameWord:
addi $t0, $zero, 1
move %bool, $t0

cw_return:
addi $sp, $sp, 12
.end_macro




# Iterates through the word bank and tallies the lengths of each word
# This will be used to initialize the words left tracker
.macro tallyLengths
subi $sp, $sp, 4
sw $v0, 0($sp)

# clear lengths with new generation
li $t0, 0
tl_clearLoop:
sb $zero, wordsLeft($t0)
addi $t0, $t0, 1
blt $t0, 6, tl_clearLoop

tl_loop:
nextBankWord($v0)
printInt($v0)		#DEBGGING
beqz $v0, tl_return
bankWordLength($v0)	# returns the length of word
move $t0, $v0
printInt($t0)		#DEBGGING
endl			#DEBGGING
subi $t0, $t0, 2	# acquire offset for tally
lb $t1, wordsLeft($t0)	#get current count for length
addi $t1, $t1, 1	# add 1
sb $t1, wordsLeft($t0)	# store plus 1 value
j tl_loop

tl_return:
endl
lw $v0, 0($sp)
addi $sp, $sp, 4
.end_macro




#print Words left
.macro printTally
li $t0, 0
pt_loop:
lb $t1, wordsLeft($t0)
addi $t0, $t0, 1
printInt($t1)
blt $t0, 6, pt_loop
endl
.end_macro




# Finds the length of the word in wbBuffer
.macro bankWordLength(%length)
add $t1, $zero, $zero

bwl_loop:
lb $t2, wbBuffer($t1)
beq $t2, 32, bwl_return
addi $t1, $t1, 1
blt $t1, 7, bwl_loop

bwl_return:
move %length, $t1
.end_macro




# With the input recieved this will iterate through the wordBank
# looking for a matching word
#	0 = no match
#	1 = MATCH!
.macro compareInput(%bool)
ci_loop:
nextBankWord($v0)
beqz $v0, ci_noMatch
compWord($v0)
beq $v0, 1, ci_match
j ci_loop

ci_noMatch:
add $t0, $zero, $zero
j ci_return

ci_match:
wlSetBool($v0)
beqz $v0, ci_loop
bankWordLength($v0)
lb $t0, wordsLeft($v0)
subi $t0, $t0, 1
sb $t0, wordsLeft($v0)
addi $t0, $zero, 1
j ci_return

ci_return:
move %bool, $t0
.end_macro
