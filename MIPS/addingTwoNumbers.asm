.data
a:      .word 12
z:      .word 13
nl:     .asciiz "\n"

.text
.globl main

main: 
    lw $t0 , a
    lw $t1 , z 
    #add me daddy
    add $t2, $t0 , $t1 
    #Prints out an integer stored in register $t2
    move $a0 , $t2
    li $v0 , 1
    syscall

    #Print out a new line
    la $a0 , nl
    li $v0 , 4
    syscall

    #exit the program
    li $v0 , 10
    syscall





