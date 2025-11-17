#Hello i am gonna reverse a string in assembly...how awesome!!!?

.data 
    str:    .asciiz "HELLO"
    rev:    .space 6

.text
.globl main

main: 
    la $t0 , str
    la $t1 , rev
    li $t2 , 0

find_len:
    lb $t3,0($t0)
    beq $t3 , $zero reverse_string#break if zero bytes .. means if str is null/empty break

    addi $t0, $t0 ,1 
    addi $t2, $t2 ,1 
    j find_len

reverse_string: 
    sub $t0,$t0 , 1
    
    lb $t3 , 0($t0)
    sb $t3 , 0($t1)

    addi $t1, $t1 , 1
    sub $t2 , $t2 , 1

    bgtz $t2 , reverse_string
    sb $zero, ($t1) #null terminating the rev string

    li $v0 , 4
    la $a0 , rev
    syscall


    li $v0 ,10 
    syscall


    
