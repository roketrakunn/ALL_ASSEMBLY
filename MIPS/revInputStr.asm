.data
    number1: .asciiz "Enter first number: "
    prompt:  .asciiz "Enter operation: " 
    number2: .asciiz "Enter second number: " 
    results:    .asciiz "Results: " #this is where the results will be stored
    nl: .asciiz"\n"
    space:  .asciiz" "
    strBuffer:  .space 2

.text
.globl main 

main:

    li $v0 , 4 
    la $a0 , number1
    syscall

    li $v0 , 5
    syscall
    move $t0 , $v0  #move the number to temp reg t0

    li $v0 , 4
    la $a0 , number2
    syscall

    li $v0 , 5
    syscall
 
    li $v0 , 4
    la $a0 , prompt
    syscall

    li $v0 , 8 
    la $a0 , strBuffer 
    li $a1 , 2
    syscall

    lb $t1 , strBuffer  #The string is now here(the operation)

    li $t4 , 43
    beq $t1 , $t4 , addition 

    li $t4 , 45
    beq $t1 , $t4 , subtract 

    li $t4 , 42
    beq $t1 , $t4 , multiplication

    li $t4 , 47
    beq $t1 , $t4, divide
    

addition: 
    add $t3 , $t2 , $t0
    j end

subtract: 
    sub $t3 , $t0 , $t2
    j end

multiplication:
    mul $t3 , $t2, $t0
    j end

divide:
    div , $t0 , $t2
    mflo $t3    #move from low

end: 

    li $v0 , 4
    la $a0 , space 
    syscall

    li $v0 , 1
    move $a0 , $t3
    syscall

    li $v0 , 4
    la $a0 , nl 
    syscall

    li $v0 , 10
    syscall












