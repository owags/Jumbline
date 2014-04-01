#Main Menu Screen

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
	

.text

 
li $v0, 59
la $a0, CoverScreen
la $a1, Null
syscall

.include "Instructions.asm"


