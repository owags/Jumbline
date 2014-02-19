.text
li $t0, 0x10010000

Runloop:
beq $t0, 0x10010012, Endloop
lb $a0, ($t0) #loads address
li $v0, 11
syscall

addi $t0, $t0, 1
j Runloop

Endloop:
li $v0, 10
syscall

.data
cake: .asciiz "The cake is a lie!"
