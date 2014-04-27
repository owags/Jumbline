#For loop for any other macro
.macro for (%regIter, %from, %to, %macro)
add %regIter, $zero, %from
Loop:
%macro()
add %regIterator, %regIterator, 1
ble %regIterator, %to, Loop
.end_macro

#Print an integer
.macro printInt(%reg)
subi $sp, $sp, 8
sw $v0, 0($sp)
sw $a0, 4($sp)

move $a0, %reg
li $v0, 1
syscall

lw $v0, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
.end_macro

#Print a string
.macro printStr(%reg)
move $a0, %reg
li $v0, 4
syscall
.end_macro

.macro printChar(%reg)
move $a0, %reg
li $v0, 11
syscall
.end_macro 

#Get an integer input
.macro getInt(%reg)
li $v0, 5
syscall
move %reg, $v0
.end_macro

#Get a string input
.macro getInt(%reg, %max)
move $a0, %reg
move $a1, %max
li $v0, 8
syscall
.end_macro

#End program
.macro exit
li $v0, 10
syscall
.end_macro

#print newline character
.macro endl
li $a0, 10
li $v0, 11
syscall
.end_macro
