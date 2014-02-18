.text
main:

la $a0, string
li $a1, 1

li $v0, 55
syscall 

li $v0, 10
syscall

.data

string: .asciiz "Hello, World!"
