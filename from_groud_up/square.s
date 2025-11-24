#This program calculates a square of a number n 
#Squre of = number times itself i.e n*n = n^2


.section .data #empty 
.section .text

.globl _start

_start: 
    pushl $2                    #calucalting square of 2
    call square

    addl $4 , %esp

    movl %eax , %ebx            #retuen value at EAX -> EBX
    movl $1 , %eax              #exit the prgram.
    int $0x80

#===========func square(n) int{...} ==========

#Calculates square of paramater n
#Returns the square results in EAX

.type square , @function

square: 
    pushl %ebp                  #Create the stack frame.
    movl %esp , %ebp        

    movl 8(%ebp) , %eax         #get the param.

    imull %eax , %eax           #Square
                                #Results are stored in EAX

    jmp end_square

end_square: 
    movl %ebp , %esp            #destroy the stack frame.
    popl %ebp 
    ret


    



