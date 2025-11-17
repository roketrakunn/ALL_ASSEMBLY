.data
    
    arr:    .word 1 , 2 , 3, 4
    nl: .asciiz"\n"

.text
.globl main

main: 
    
    la $t0 , arr    #point to the first element of the array
    la $t1 , arr + 12 #what does this mean
    
    li $t2 , 2  #number of swaps

rev_loop: 
    
    lw $t3 , 0($t0) #store the firs element of teh array arr[0]
    lw $t4 , 0($t1) #store last element in the array arr[len(arr)-1]
    
    sw $t3 , 0($t1) #save the last element to the first pos array.
    sw $t4 , 0($t0)  #save the first element to the last pos of the array.

    addi $t0 , $t0 , 4  #move to the next int 
    addi $t1 , $t1 , -4 #move to the next( second last or whatever int)
    addi $t2 , $t2 , -1 #decremet number of swaps left

    bgtz $t2 , rev_loop   #so this is a while loop ( while number of swaps is greater than zero swap baby swap)

    #so that i can access the reversed array and print it and do stuff to it...
    li $t5 , 4 #number of elemnts
    la $t6 , arr    #store thee reversed array


print_me_daddy: 
    
    lw $a0 , 0($t6) #load the number and print it
    li $v0 , 1
    syscall

    li $v0 , 4
    la $a0 ,nl #print some space
    syscall

    addi $t6 , $t6 4 #move to the next element
    add $t5 , $t5 , -1  #decrement the number of elements left to print
    bgtz $t5 , print_me_daddy

    li $v0 , 10 #exit the program.
    syscall


