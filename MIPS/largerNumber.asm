#THIS PROGRAM GETS YA THE MAX NUMBER BETWEEN TWO( WHAT ABOUT 3 OR 4 OR MORE? ..IDK)
.data
    n1:   .word 8
    n2:   .word 10
    larger: .word 0

.text
.globl main
main: 
    lw $t0,n1
    lw $t1,n2

    bge $t0,$t1, num_larger
    sw $t1,larger   #this will only execute if the above line is ouputs false
    lw $t2, larger  #well i wanna print this later so .. yeah...

    j end   #jump to the end to we can terminate the program...

num_larger: 
    sw $t0, larger  #saves t0 (8) to larger IF it is .. well now it definetely is not
    lw $t2, larger

end: 
    #prints 10 in this case...
    li $v0 ,1
    move $a0 , $t1
    syscall

    #and finally we exit the program...
    li $v0 , 10
    syscall

