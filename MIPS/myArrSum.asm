.data
    arr:    .word 1 , 2 , 3 , 4 , 5 , 6
    nl: .asciiz"\n"

.text
.globl main

main: 
    
    la $t0 , arr    #get you &arr[0]
    li $t1 , 0 #load the sum baby load the sum
    li $t2 , 6  #this is a fixed array len...

loop:
    beq $t2 , $zero  , end
    lw $t3 , 0($t0) #dereference to get the first element of the array
    add $t1 , $t1 , $t3 #add to sum ( sum = sum + arr[i])

    addi $t0 , $t0 , 4    #move to the next element...
    addi $t2 , -1   #decrease the number of elements that are left...
     j loop

end:
    li $v0 , 1  #print the sum
    move $a0 , $t1
    syscall

    li $v0 , 4 #print the new line
    la $a0 , nl
    syscall


    li $v0 , 10 #exit the program
    syscall


    
    

    


