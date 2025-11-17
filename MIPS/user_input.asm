.data
    a:  .word 5 
    z:  .word 7
    nl:  .asciiz "\n"

.text
.globl main 
main:
    
    #laod to registers
    lw $t0 , a
    lw $t1 , z

    #Add the two numbers
    add $t2 , $t0 , $t1

    
    #Print  the sum
    move $a0 , $t2 
    li $v0 , 1
    syscall

    la $a0, nl 
    li $v0 , 4
    syscall

    #Exit teh program
    li $v0 , 10
    syscall
