#Hello... this program counts the number of even and odd numbers in an array

.data
    
    arr:    .word 1 , 2 , 3 , 4 , 5 , 6 , 7, 8  , 9 , 10  ,11 #This is the array
    odds:   .word 0     #store oddies
    evens:   .word 0    #store evens
    nl: .asciiz "\n"
    len:    .word 11 #This to track numbers remaining to track

.text
.globl main

main:
    
    la $t0 , arr    #this is the array
    lw $t1 , odds   #Load the odds to reg t1
    lw $t2 , evens  #load the evens to a reg
    lw $t3 , len    #Load numbers left to evaluate for
    li $t5 , 0  #counter
        
loop: 

    beq $t3 , $t5 , end #when done branch to end
    lw $t4 , 0($t0)    #load the firs element of the arrray

    div $s0 , $t4 , 2 #divide  the curr val by 2
    mfhi  $s0  #move the remainder to $t5

    beq $s0 , $zero  , even_handler #jump to the even hander...
    bne $s0 , $zero  , odd_handler #jump to the odd_handler...

    j loop

even_handler:   #This counts evenies

    addi $t2 , $t2, 1
    j continue  #jump back to loop after iteration

odd_handler:    #This counts oddies

    addi $t1 , $t1 , 1
    j continue  #jump back to loop after iteration

continue:
    
    addi $t0 , $t0 , 4  #move to the next element
    addi $t5 , $t5 , 1  #increment counter++
    
    j loop  #go back to the loop

end:
    
    li $v0 , 1  #Print the evens
    move $a0 , $t2
    syscall

    li $v0 , 4  #print new line
    la $a0 , nl
    syscall

    li $v0 , 1  #print the oddies
    move $a0 , $t1
    syscall
 
    li $v0 , 4  #print new line
    la $a0 , nl
    syscall   

    li $v0 , 10
    syscall


    
