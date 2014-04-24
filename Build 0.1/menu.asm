#Main Menu Screen
.include "utilitymacros.asm"
.include "data.asm"
.include "letGenMacros.asm"
.include "wordSearchMacros.asm"
.include "wordBankMACROS.asm"

.data
M_Null: 	.asciiz ""
M_CoverScreen: 	.ascii "\n      _________________________________________________       \n"
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
	
M_OPTIONS: .ascii "\n\n\n\n\n1. Play game\n"
	.ascii "2. View instructions\n"
	.ascii "0. Quit\n"
	.asciiz ">>"
M_INVALID: .asciiz "Not a valid choice.\n"
	
	

.text

dictToMem

#Display main splash screen
li $v0, 59
la $a0, M_CoverScreen
la $a1, M_Null
syscall

#Main program loop
M_MAIN:
la $a0, M_OPTIONS
printStr($a0)

li $v0, 5
syscall
move $t0, $v0

beq $t0, 1, M_PLAYGAME
beq $t0, 2, M_INSTRUCTIONS
beq $t0, 0, M_QUIT

la $a0, M_INVALID
printStr($a0)
j M_MAIN

M_PLAYGAME:
.include "playgame.asm"
j M_MAIN


M_INSTRUCTIONS:
.include "instructions.asm"
j M_MAIN

M_QUIT:
li $v0, 10
syscall
