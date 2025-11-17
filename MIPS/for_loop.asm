.text
.globl main
main:
    
    li $t0 , 10
    li $t1 , 0 #this is like i ..in for i ...
    li $t2, 17 #value to modify
loop: 
    beq $t1 , $t0 , end
    add $t2 , $t2, $t1 #Add whatever is $t2 holding to $t2
    addi $t1 ,$t1 ,1 #increment $t1 by 1
    j loop #jump back to the loop if base case is not met

end:
    move $a0,$t2
    li $v0 , 1
    syscall

    li $v0 , 10
    syscall


    






