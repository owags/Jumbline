#Main Menu Screen
.include "utilitymacros.asm"
.include "data.asm"
.include "letGenMacros.asm"
.include "wordSearchMacros.asm"

.data
Null: 	.asciiz ""
CoverScreen: 	.ascii "\n      _________________________________________________       \n"
	.ascii "    /                                                                                \\      \n"
	.ascii "   |    _____________________________________________     |     \n"
	.ascii "   |   |                                                                         |    |     \n"
	.ascii "   |   |                            JUMBLINE                              |    |     \n"
	.ascii "   |   |                                                                         |    |     \n"
	.ascii "   |   |                            Created By:                           |    |     \n"
	.ascii "   |   |                          Grant Freeman                        |    |     \n"
	.ascii "   |   |                          David Golynskiy                      |    |     \n"
	.ascii "   |   |                          Andrew Vaccaro                      |    |     \n"
	.ascii "   |   |                          Otto Wagner                           |    |     \n"
	.ascii "   |   |                                                                         |    |     \n"
	.ascii "   |   |                                                                         |    |     \n"
	.ascii "   |   |                        *Press 'OK' To Play*                  |    |     \n"
	.ascii "   |   |                                                                         |    |     \n"
	.ascii "   |   |                                                                         |    |     \n"
	.ascii "   |   |_____________________________________________|    |     \n"
	.ascii "   |                                                                                  |     \n"
	.ascii "    \\_________________________________________________/     \n"
	.asciiz "            \\_______________________________________/             \n"
	
OPTIONS: .ascii "\n\n1. Play game\n"
	.ascii "2. View instructions\n"
	.ascii "0. Quit\n"
	.asciiz ">>"
INVALID: .asciiz "Not a valid choice.\n"
	
	

.text

dictToMem

#Display main splash screen
li $v0, 59
la $a0, CoverScreen
la $a1, Null
syscall

#Main program loop
MAIN:
la $a0, OPTIONS
printStr($a0)

li $v0, 5
syscall
move $t0, $v0

beq $t0, 1, PLAYGAME
beq $t0, 2, INSTRUCTIONS
beq $t0, 0, QUIT

la $a0, INVALID
printStr($a0)
j MAIN

PLAYGAME:
.include "playgame.asm"
j MAIN


INSTRUCTIONS:
.include "instructions.asm"
j MAIN

QUIT:
li $v0, 10
syscall
