
.data
PG_promptstr: .asciiz "Enter a guess (0 to quit): "
PG_correctstr: .asciiz "Correct!\n"
PG_wrongstr: .asciiz "Wrong!\n"
PG_newline: .asciiz "\n"

.text
letGen
wordSearch
TallyLengths

#Push saved registers onto stack
sw $s0, 0($sp)
sw $s1, -4($sp)
addi $sp, $sp, -8


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

printWordBank

la $a0, inputBuffer
li $v0, 4
syscall


#Check for zero to stop
lb $t1, inputBuffer($zero)
beq $t1, 48, PG_end

#Call macro to check for match
compareInput($v0)

move $a0, $v0
li $v0, 1
syscall

beqz $a0, PG_incorrect

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

