#Intructions Screen


.data

I_Instructions: .ascii "GOAL OF GAME: \n"
.ascii "Purpose of this game is to guess all possible words \nfrom the combination of randomly generated letters\n\n"
.ascii "INSTRUCTIONS: \n"
.ascii "1. Choose how many characters to generate (5-7).\n"
.ascii "2. Enter word guesses.\n"
.asciiz "3. Win by guessing all possible words.\n"
I_Null2: .asciiz ""

.text
li $v0, 59
la $a0, I_Instructions
la $a1, I_Null2
syscall

#.include "Let Gen Biased.asm"
