#Hello this gets the len of any string you  throw at me .. gotta be less tan 64 chars tho
.data
    promptstr:  .asciiz "Enter the string: " #ask for the string
    stringBuffer: .space 64 #will inpt hello for testing

.text
.globl main 

main:
    
    li $v0 , 4  #print the prompt
    la $a0 , promptstr
    syscall

    li $v0 , 8 #read the strig from the input(os)
    la $a0 , stringBuffer   #string buffer/like a box where teh string is gonna live
    li $a1 , 64
    syscall

    la $t0 , stringBuffer #move  the string to a temp reg so that we can use it
    li $t1 , -1  #init the counter at

    j loop_over_chars

loop_over_chars: 
    
    lb  $t2 , 0($t0)    #get the first char...
    beq $t2, $zero , end #reach the end... brach to  the end...

    addi $t1 , $t1 , 1  #increment  the counter...
    addi $t0 , $t0 , 1   #move to the next char...
    
    j loop_over_chars

end: 
    
    li $v0 , 1
    move $a0 , $t1
    syscall

    li $v0 , 10
    syscall
    
    
    


