#The same as add ..ust that now i am subtracting

.section .data
.section .text

.globl _start

_start: 

    pushl $5      #first parameter(b) is at the "bottom" of stack
    pushl $20        #second parameter(a) is at the "top" of stack
    
    call subtract_two_numbers
    
    addl $8 , %esp      #clean the stack 

    movl %eax , %ebx    #move the results to return satus (echo $?)
    movl $1 , %eax      #exiting...
    int $0x80       #ping the sys you wanna exit

#=========func subtract_two_numbers(a , b)===========

#VARIABLES:
#       a = %eax( the first parameter at the "top" of stack)
#       b = %ebx(the second parameter at the "bpttom of the stack")

#RETURN: 
#      Difference between a and b ( assume b is greater than a)
#       resulst stored in %eax

.type subtract_two_numbers, @function

subtract_two_numbers:
    push %ebp   #mark the function "window"/"section"(my own def)

    movl %esp , %ebp        #adjust the stack pointer

    movl 12(%ebp) , %ebx    #Got b (the second parameter)
    movl 8(%ebp) , %eax     #Got a (the fist parameter)

    subl %ebx , %eax        #will migrate results later to %ebx

    movl %ebp , %esp        #when all done move/adjust stack to sp
    popl %ebp       #nuke all local variables and function params
    ret






