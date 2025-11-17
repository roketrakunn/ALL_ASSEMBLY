#chat gpt said I shoud do this...

.text
.globl main 

main: 
    li $t0 , 1 #we gonna start here bab...start here...
    li $t1  , 0 #sum baby sum...

sum_loop: 
    add $t1 , $t1 , $t0 #sum = sum + sum
    addi $t0 , 1 #increment baby increment 
    ble $t0 , 5  sum_loop 

    li $v0 , 1  #print the results
    move $a0 , $t1
    syscall

    li $v0 , 10 #exit the code
    syscall




