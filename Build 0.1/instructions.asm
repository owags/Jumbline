#Intructions Screen


.data

Instructions: .ascii "GOAL OF GAME: \n"
.ascii "Purpose of this game is to guess all possible words \nfrom the combination of randomly generated letters\n\n"
.ascii "INSTRUCTIONS: \n"
.ascii "1. Choose how many characters to generate (5-7).\n"
.ascii "2. Enter word guesses.\n"
.asciiz "3. Win by guessing all possible words.\n"
Null2: .asciiz ""

.text
li $v0, 59
la $a0, Instructions
la $a1, Null2
syscall


