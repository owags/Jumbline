.text

lb $a0, 0x10010000	#loads first byte in memory address 0x10010000
			#in this case it's the hex 62 = b
li $v0, 11
syscall

lb $a0, 0x10010001	#increments by 1 byte
syscall

lb $a0, 0x10010002	#increments by 1 byte
syscall

lb $a0, 0x10010003	#increments by 1 byte
syscall

.data
mystring: .asciiz "bird"