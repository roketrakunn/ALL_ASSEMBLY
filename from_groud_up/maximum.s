#this program finds the max value from a list of numbers

#Variables:
        #%edi => holds the index of the curr element
        # %ebx => holds the "final" maximum value.
        # %eax => holds the currr maximum seen.

.section .data

    data_items: #data items ... 0 used for termination of loops
        .long 10, 20 , 3 , 40 , 50,200, 1 , 34 , 55, 66, 99, 2 


.section .text
    
.globl _start

_start: #This where the program starts 
    

    movl $0 ,%edi  #load the first idx
    movl data_items(,%edi,4) , %eax #firs element

    movl %eax, %ebx #assume the curr is the max

    movl $5 ,%ecx #len of arr

start_loop:
    
    cmpl %ecx , %edi #check if we are not at the end...
    je loop_exit
    
    incl %edi #load the next value. 

    movl data_items(,%edi,4) , %eax #curr element( again)

    cmp %ebx, %eax #compare curr with curr_max
    jle start_loop #jumps to start the loop again if new val is not bigger

    movl %eax, %ebx #else make the curr elemt the max if its bigger
    jmp start_loop #keep going.
    
loop_exit: #You know what this does.
    # %ebx holds the max value.
    movl $1, %eax
    int $0x80

    



