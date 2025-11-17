.data
    c:  .byte 'H' 
    upper:  .asciiz"it is upper"
    lower:  .asciiz"it is lower"
    nl: .asciiz"\n"

.text
.globl main

main: 
    
    lb $t0 , c  #load teh byte baby load teh byte...

    li $t1 , 'A'    #this is 65
    li $t2 , 'Z'    #this is 90

    li $t3 , 'a'    #this is 97
    li $t4 , 'z'    #this is 127

    blt $t0 , $t1 , is_lower  #if the char is less than 65 
    bgt $t0 , $t2 , is_lower    #if the char is greaer than 90

    li $v0 , 4 
    la $a0 , upper  #print upper
    syscall
    
    j done

is_lower: 

    #lower case case
    blt $t0 , $t3 , done
    bgt $t0 , $t4 , done

    li $v0 , 4  #lower case hanlder...
    la $a0 , lower
    syscall
 
 done: 
    
    li $v0 , 4 
    la $a0 , nl 
    syscall   

    li $v0 , 10
    syscall

