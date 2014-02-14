.text		#Holds your program

main:		#Default Label
li $t0, 5	#immediately loads 5 into Reg t0
li $v0, 10	#immediately loads 10 into Reg v0

add $t1, $t0, $v0	# $t0 + $v0 = $t1
sub $t1, $t0, $v0	# $t0 - $v0 = $t1
mul $t1, $t0, $v0	# $t0 * $v0 = $t1
div $t1, $t0, $v0	# $t0 / $v0 = $t1 

.data		#Holds varaiables, labels, words, etc.