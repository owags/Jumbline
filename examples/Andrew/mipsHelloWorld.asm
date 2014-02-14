.data

hello: .asciiz "hello, world!" #hellos is the label for this null-terminated ascii string

.text

	li $v0, 4 #informs system that we want to output a string
		  #$v0 is the out register for system functions
	
	la $a0, hello #loads the address of the "hello" label/string/whatever into register $a0
	
	syscall #"executes" the function indicated by loading 4 into $v0
	
	li $v0, 10 #informs system we want to exit
	
	syscall #actually call the exit syscall
	
	
	
