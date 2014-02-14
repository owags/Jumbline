.text
main:

la $a0, myword	#load address of space
li $a1, 14	#defines max number of character (n-1)
		#if we input 8, it'll accept 7

li $v0, 8	#read string
syscall

li $v0, 4
syscall

li $v0, 10
syscall

.data
myword: .space 20
