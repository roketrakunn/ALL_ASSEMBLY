#basic mips assembly code 

.data
    
    var1:   .word 5
    var2:   .word 10
    results:.word 0
    nl:     .asciiz "\n"

.text 
.globl main
main: 
    lw $t0 , var1
    lw $t1 , var2
    add $t2 ,$t0 , $t1
    sw $t2 , results

    #prints the results....
    li $v0 , 1
    move $a0 , $t2
    syscall

    #prints new line....
    li $v0 , 4
    la $a0 ,nl 
    syscall
    
    li  $v0 , 10 
    syscall
