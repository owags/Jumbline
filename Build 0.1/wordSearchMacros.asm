
.data
dict_file:	.asciiz "linuxDict.txt"
dict_buff:	.space 120000
DTM_err1_str:	.asciiz "Error [macro dictToMem]: error thrown opening dictionary"
DTM_err2_str:	.asciiz "Error [macro dictToMem]: error thrown reading dictionary"
DTM_eof_str:	.asciiz "Warning [macro dictToMem]: End of File"

debug_let:	.asciiz "Letters: "
debug_word:	.asciiz "Words:\n"


curWord:	.space 7
curOffset:	.word 0
boolChk:	.space 7

.macro dictToMem
li $v0, 13
la $a0, dict_file
add $a1, $zero, $zero
add $a2, $zero, $zero
syscall

bltz $v0, DTM_err1
subi $sp, $sp, 4
sw $v0, 0($sp)

li $v0, 14
lw $a0, 0($sp)
addi $sp, $sp, 4
la $a1, dict_buff
addi $a2, $zero, 100000
addi $a2, $a2, 20000
syscall

bltz $v0, DTM_err2
beqz $v0, DTM_eof
j DTM_close

DTM_err1:
la $a0, DTM_err1_str
printStr($a0)
j DTM_close

DTM_err2:
la $a0, DTM_err2_str
printStr($a0)
j DTM_close

DTM_eof:
la $a0, DTM_eof_str
printStr($a0)
j DTM_close

DTM_close:
move $a0, $s0
li $v0, 16
syscall
.end_macro



.macro nextWord
subi $sp, $sp, 12	#
la $s0, curOffset
lw $s1, 0($s0)
la $s0, dict_buff
add $s0, $s0, $s1	# address with offset
sw $s0, 0($sp)		# save current dict_buff in stack (0)

addi $s0, $s0, 7	# find end of buffer
sw $s0, 4($sp)		# save end of buffer in stack (4)

la $s0, curWord
sw $s0, 8($sp)		# save curWord position in stack (8)

moveWord:
lw $s0, 0($sp)		# pull buffer from stack
lb $s1, 0($s0)		# get letter
addi $s0, $s0, 1	# adjust for next byte
sw $s0, 0($sp)		# save back in stack

lw $s0, 8($sp)		# pull curWord from stack
sb $s1, 0($s0)		# save letter
addi $s0, $s0, 1	# adjust for next letter
sw $s0, 8($sp)		# save curWord back in stack

lw $s0, 0($sp)
lw $s1, 4($sp)
blt $s0, $s1, moveWord
j cleanup

cleanup:
addi $sp, $sp, 12	# move stack back to starting position
la $s0, curOffset	# get offset, add 7 for next word
lw $s1, 0($s0)
addi $s1, $s1, 7
sw $s1, 0($s0)
.end_macro
 
 
 
.macro printWord
la $s0, curWord
addi $s1, $s0, 7

PW_loop:
lb $s2, 0($s0)
addi $s0, $s0, 1
printChar($s2)
blt $s0, $s1, PW_loop

addi $s2, $zero, 10
printChar($s2)
.end_macro



.macro dictEOF(%bool)
move $s2, %bool
la $s0, curWord
lb $s1, 0($s0)
bne $s1, $zero, no_EOF
j yes_EOF

no_EOF:
add $s2, $zero, $zero
j EOF_return

yes_EOF:
addi $s2, $zero, 1
j EOF_return

EOF_return:
move %bool, $s2
.end_macro



.macro validWord(%bool)
move $a0, %bool
subi $sp, $sp, 24
la $s0, curWord
sw $s0, 0($sp)

addi $s2, $zero, 1
lenWord:
addi $s0, $s0, 1
addi $s2, $s2, 1
lb $s1, 0($s0)
beq $s2, 7, mesLen
bne $s1, 32, lenWord

mesLen:
sw $s0, 4($sp)
lw $s1, 0($sp)
sub $s0, $s0, $s1
sw $s0, 8($sp)		#save length in stack

la $s0, lCount
lw $s1, 0($s0)		# load letter size
lw $s0, 8($sp)		# load curWord length from stack
blt $s1, $s0, notVW

la $s0, letters
add $s0, $s0, $s1
sw $s0, 16($sp)

compareSet:
la $s0, letters		# Save starting addr in stack
sw $s0, 12($sp)
la $s0, boolChk
sw $s0, 8($sp)

lw $s1, 0($sp)		# get letter
lb $s0, 0($s1)
sw $s0, 20($sp)
add $s1, $s1, 1		# adjust for next letter
sw $s1, 0($sp)

cLoop:
lw $s0, 12($sp)		
lb $s1, 0($s0)		# load check letter
addi $s0, $s0, 1	
sw $s0, 12($sp)		
lw $s0, 20($sp)
beq $s0, $s1, vw_chkr	# check if letters match
lw $s0, 8($sp)
addi $s0, $s0, 1
sw $s0, 8($sp)
lw $s0, 12($sp)
lw $s1, 16($sp)
blt $s0, $s1, cLoop
j notVW

vw_chkr:
lw $s0, 8($sp)		#load boolchk
addi $s2, $s0, 1
sw $s2, 8($sp)
lb $s1, 0($s0)		#load value: 1 or 0
bnez $s1, cLoop
addi $s1, $zero, 1
sb $s1, 0($s0)		#make open match true
lw $s0, 0($sp)
lw $s1, 4($sp)
blt $s0, $s1, compareSet
j goodVW

notVW:
add $a0, $zero, $zero
j returnVW

goodVW:
addi $a0, $zero, 1
j returnVW

returnVW:
move %bool, $a0
addi $sp, $sp, 24

la $s0, boolChk
addi $s1, $s0, 7
zeroLoop:
sb $zero, 0($s0)
addi $s0, $s0, 1
blt $s0, $s1, zeroLoop
.end_macro



.macro saveWord
subi $sp, $sp, 4	# decrenent by 4 for stack
la $s0, wbCount		# load address
lw $s1, 0($s0)		# load current word bank count
li $s0, 7		# li immediate 7
mult $s1, $s0		# multiply 7 * wbCount
mflo $s1		# retreive from lo
la $s0, wordBank	# load word bank
add $s0, $s1, $s0	# Address of wordBank with offset
addi $s1, $s0, 7	# find the end address
sw $s1, 0($sp)		# save end addr in stack
la $s1, curWord		# load curWord

SW_loop:
lb $s2, 0($s1)
sb $s2, 0($s0)
addi $s1, $s1, 1
addi $s0, $s0, 1
lw $s2, 0($sp)
blt $s0, $s2, SW_loop

la $s0, wbCount
lw $s1, 0($s0)
addi $s1, $s1, 1
sw $s1, 0($s0)
addi $sp, $sp, 4
.end_macro



.macro wordSearch
subi $sp, $sp, 20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $t0, 12($sp)
sw $t1, 16($sp)

la $s0, wbCount
sw $zero, 0($s0)

_search:
nextWord
dictEOF($v0)
beq $v0, 1, _return
validWord($v0)
beqz $v0, _search
saveWord
lw $s1, wbCount
printInt($s1)	#DEBUG
printWord	#DEBUG
beq $s1, 20, reGenLet
j _search

reGenLet:
letGenStatic
printLetters
la $s0, wbCount
sw $zero, 0($s0)
la, $s0, curOffset
sw $zero, 0($s0)
j _search

_return:
lw $t0, wbCount
beqz $t0, reGenLet

la, $s0, curOffset
sw $zero, 0($s0)


lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $t0, 12($sp)
lw $t1, 16($sp)
addi $sp, $sp, 20
.end_macro
