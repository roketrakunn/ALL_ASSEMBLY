.data 

arr:  .word 1 , 2, 3, 4, 5 , 6
n:  .word 5 #This is the lenght or the array (gezz is that how you spell length ? damn it idk whatever)
nl: .asciiz "\n"

.text 
.globl main 
main: 
    la $t0,arr  #somehow this stores array[0] dnd not the whole thing
    lw $t1 , n  #store the len dady
    li $t2 , 0  #This is the sum we are trying to get.
    li $t3 , 0  #hello this is the counter

loop:
    beq $t3 , $t1 done  #this is gonna break if the cunter becomes 1

    lw $t4 , 0($t0) #load array[i]
    add $t2 , $t2 , $t4    #update the sum

    addi $t0, $t0 , 4   #moves the pointer to the next int
    addi $t3, $t3 , 1   #moves the pointer to the next int

    j loop

done:   #aaaaand we are done ladies and me gents

    li $v0 ,1
    move $a0 , $t2   #print the sum 
    syscall

    #New line because i do not like  the uhh... "%" sign after sum
    li $v0 , 4
    la $a0 , nl
    syscall




    li $v0 , 10 #break the program.... soo long suckers
    syscall


