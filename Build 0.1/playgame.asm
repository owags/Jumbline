
.data
PG_promptstr: .asciiz "Enter a guess (0 to quit): "
PG_correctstr: .asciiz "Correct!\n"
PG_wrongstr: .asciiz "Wrong!\n"
PG_newline: .asciiz "\n"

.text
letGen
wordSearch

#Push saved registers onto stack
sw $s0, 0($sp)
sw $s1, -4($sp)
addi $sp, $sp, -8

#Determines how many n-letter words are in field
#la $s0, wordsLeft
#li $t0, 6
#NCALC:
#li $t0, 6
#beqz $t0, MAIN

#MAINLOOP:
#la $s0, letters	#Load address of letters field
#li $t0, 7

#Print out remaining n-letter words
#PRINTLOOP:	#Print letters field
#beqz $t0, PRINTBANK
#lb $a0, 0($s0)
#li $v0, 11
#syscall
#addi $t0, $t0, -1
#addi $s0, $s0, 1
#j PRINTLOOP


#PRINTBANK:
#li $a0, 10	#Print newline after letters
#li $v0, 11
#syscall

#la $s0, wordBank
#lw $t0, wbCount

#Print out game info
la $a0, letters
li $v0, 4
syscall

#Print out newline
la $a0, PG_newline
li $v0, 4
syscall

#Print guess prompt
PG_prompt:
la $a0, PG_promptstr
printStr($a0)

#Get guess from user
la $a0, inputBuffer
li $a1, 7
li $v0, 8
syscall

la $a0, inputBuffer
li $v0, 4
syscall


#Check for zero to stop
lw $t0, inputBuffer
beqz $t0, PG_end

#Loop through words to check
lw $s5, wbCount
la $s7, wordBank	#Load starting point of word bank
li $s4, 0		#Counter for words compared

PG_loop:
la $a0, inputBuffer
move $a1, $s7
.include "compareWord.asm"
beq $v0, 1, PG_correct	#If guess was in bank

#Otherwise keep going
beq $s5, $s4, PG_incorrect	#If at end of bank and no correct so far
addi $s4, $s4, 1	#Increment counter
addi $s7, $s7, 7	#increment address by 7 characters

j PG_loop

#Print correct word prompt
PG_correct:
la $a0, PG_correctstr
li $v0, 4
syscall
j PG_prompt

#Print incorrect word prompt
PG_incorrect:
la $a0, PG_wrongstr
li $v0, 4
syscall

j PG_prompt

PG_end:

#Pop stack
addi $sp, $sp, 8
lw $s0, 0($sp)
lw $s1, -4($sp)

#Fall off bottom to get back to main

