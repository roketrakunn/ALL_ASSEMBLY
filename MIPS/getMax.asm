#This program finds a max value  in an array....

.data
    arr:    .word 1 , 2 , 3 , 5, 4 , 20 , 8 , 10 #this is the array (max = 20)
    len:    .word 8 #using this as "counter" to iterate oevr the array
    finalMax:    .word 0
    
.text
.globl main

main:
    
    la $t0 , arr    #Load the array (arr[0])  ...one val ( 4 bytes) a time
    lw $t1 , finalMax    #Load the max
    lw $t2 , len    #load the counter ... n (len of the array)

loop_over_vals:
    blez $t2 , end #While loop .. while there are values left to check ... do it
    lw $t3 , 0($t0) #get the first value...
    bgt $t3 , $t1 , set_new_max #banch to teh setter if the curr is greater than max... 
     j continue_loop

set_new_max:    #This is the new max handler...
        move $t1 , $t3  #max = curr
        j loop_over_vals    #jump back to the loop...

continue_loop:

    addi $t0 , $t0 , 4 #move to  the next element... 
    addi $t2 , $t2 , -1 #decrement the values left

    j loop_over_vals    #jump back to the loop...

end:
    sw $t1 , final_max  #store the max in memory

    li $v0 , 1  #print the max...
    move $a0 , $t1
    syscall

    li $v0 , 10 #exit the prgram... 
    syscall
    



    
    









