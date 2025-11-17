#THIS PROGRAM ADDS NUMBERS FROM 1 to 10(you can change this if you wanna)

.data 
    results:    .word 0 
    nl:  .asciiz"\n"

.text
.globl main

main:
    
    li $t0 , 1  #counter init...
    li $t1 , 10  #upper limit
    li $t2 , 0  #sum is initially zero

loop: 
    
    add $t2,$t2 , $t0   #add the counter to sum ... 
    addi $t0, $t0 ,1 #increment the counter
    
   #Print the current sum so that it looks cooler when i/you run it... 
    li $v0 ,1
    move $a0 , $t2 
    syscall

    #print a new line to make it even more cooler
    li $v0 , 4
    la $a0 , nl
    syscall

    ble $t0, $t1 loop   #while counter is less or equal to upper limit.. repeat loop
    sw $t2 ,results #store the sum in real memory...

    #print the final  sum 
    li $v0 ,1
    move $a0 , $t2 
    syscall

    #exit the program
    li $v0 , 10 
    syscall

