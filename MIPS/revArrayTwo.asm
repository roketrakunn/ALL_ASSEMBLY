

#Hello i reversed an array again

.data
    arr:    .word 1 , 2 , 3 , 4 , 5 , 7 , 6
    len:    .word  7
    space: .asciiz " "
    nl: .asciiz"\n"

.text
.globl main 

main: 

    la $t0 , arr    #points to arr[0]
    lw $t1 , len 

    addi $t1, $t1 , -1 #n-1
    sll $t1 , $t1 , 2   #(n-1)*4 each int is 4 bytes
    la $t2 , arr 

    add $t2 , $t2 , $t1 #points to arr[n-1]

rev_loop: 
    bge $t0 , $t2 , done   #break if the left is >= right

    lw $t3 , 0($t0) #load the actual vals
    lw $t4 , 0($t2) #load the actual vals

    sw $t3 , ($t2) #arr[left] ==array[right]
    sw $t4 , ($t0) #arr[right] ==array[left]

    addi $t0  , $t0 , 4 #move left foward
    addi $t2  , $t2 , -4    #move left backwards
    
    j rev_loop  #looping baby

done: 
    lw $t5 , len    #len
    la $t6 , arr    #new array i pray

print_loop: 

    beq $t5 , $zero , end 

    lw $a0, 0($t6) #load the val
    li $v0 , 1  #print curr value
    syscall

    li $v0 , 4  #print  the new line
    la $a0 , space  
    syscall
    
    addi $t6 , $t6 , 4 #move to the next element
    addi $t5 , $t5 , -1 #decrement number of vals left

    j print_loop

end:
    li $v0 , 4
    la $a0  , nl 
    syscall

    li $v0 , 10 
    syscall

