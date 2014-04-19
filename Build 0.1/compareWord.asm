######################		COMPARE WORD	###############################
#
#ARGUMENTS		$a0 - Word 1		$a1 - Word 2
#
#RETURN VALUE		$v0 - Equality flag
#				= 1 if Equal,
#				= 0 if NOT equal
#
#REGISTERS USED		$t0	$t1	$t2	$t3	$a0	$a1	
#
###############################################################################
compareword:
	li $t2, 1
	li $t3, 7
	while:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	bne $t0,$t1,wrong
	beq $t2, $t3 done
	addi $t2, $t2, 1
	la $a0, 1($a0)
	la $a1, 1($a1)
	j while

	done:
		li $v0, 1
		jr $ra	
	wrong:
		li $v0, 0
		jr $ra
##########################################################################
