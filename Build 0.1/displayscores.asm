#Display high scores

.data
SCORESFILE: .asciiz "highscores.txt"
INPUTBUFFER: .space 

.text
la $a0, SCORESFILE
li $a1, 0
li $a2, 0
li $v0, 13
syscall
move $s0, $v0

move $a0, $s0
li $v0, 1
syscall

move $a0, $s0
la $a1, INPUTBUFFER
li $a2, 20
li $v0, 14
syscall

move $a0, $v0
li $v0, 1
syscall

la $a0, INPUTBUFFER
li $v0, 4
syscall
