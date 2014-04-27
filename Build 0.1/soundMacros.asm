.data
songCounter:	.word 0

##Right
	right: .word 72,76,84,72,76,84,0,76,84,84,84
	right2: .word 72,76,84,0,72,76,84,76,84,84,84
##Wrong
	wrong2: .word  52,56,51,55,50,54,49,53,49,53,49,53,49,53,49,53,49,53,49,53
	wrong:  .word  56,52,55,51,54,50,53,49,53,49,53,49,53,49,53,49,53,49,53,49



.macro wrong
	sound(0)
.end_macro
.macro right
	sound(1)
.end_macro




.macro sound(%input)
PlaySong:
	li $t6, 1
	beq $t6, %input, correct
	
	j incorrect

	correct:
		la $t2, right
 		la $t3, right2
 		la $t4, 10
 		j next
	incorrect:
		la $t2, wrong
 		la $t3, wrong2
 		la $t4, 10
 		j next
	next:
		addiu $sp,$sp,-4
		sw $ra, ($sp)
		addi $s1, $zero, 0


	loop:

		la $a0, ($t2)
		la $a2,	72
		jal playNote
		la $a2 112
		la $a0, ($t3)
		jal playNote

		jal increaseSongCounter

		li $v0, 32
		li $a0, 100
		syscall

		beq $s1, $t4, exitLoop
		addi $s1, $s1, 1
		j loop

	exitLoop:

		lw $zero,songCounter
		lw $ra, ($sp)
		addiu $sp,$sp, 4
		#jr $ra
		j done_with_macro
		
	playNote:
		lw $t0, songCounter
		move $t1, $a0
		add $t1, $t1, $t0

		lw $t1, ($t1)
		li $v0, 31
		move $a0, $t1
		li $a1, 150##250

		li $a3, 64
		syscall
		jr $ra
		

	increaseSongCounter:
		lw $t0, songCounter
		addi $t0, $t0, 4
		sw  $t0, songCounter
 		jr $ra  
 	done_with_macro:
 	sw $zero, songCounter

 	

.end_macro 

.text




## Examples of a Macro Call
right 
right 
right 
right 
right 
right 
right




