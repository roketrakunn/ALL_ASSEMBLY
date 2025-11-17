#I AM COUNTING THE LEN OF A STRING....

.data
    str:    .asciiz "HELLO"

.text
.globl main
main:
    
    la $t0 , str    #store  the string to a reg
    li $t1 , 0  #counter ( would have been i if i was on some high end)

len_loop:
    
    lb $t2 , 0($t0) #load the byte baby load the byte
    beq $t2 , $zero end  #break when the string has ended

    addi $t1 , $t1 , 1  #i++ ( increment me baby...)
    addi $t0 , $t0 , 1    #move one byte forward
    j len_loop

end:
    li $v0 , 1  #print the len baby
    move $a0 , $t1  #load the argument baby load teh argument
    syscall

    li $v0 , 10 #exit the progra
    syscall





