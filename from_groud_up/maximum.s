#this program finds the max value from a list of long(4 bytes ..assume 32 bits )

#Variables:
        # %edi => holds the index of the curr element
        # %ebx => holds the "final" maximum value.
        # %eax => holds the curr maximum seen.

.section .data

    data_items: #data items ... 0 used for termination of loops
        .long 10, 20 , 3 , 40 , 50 , 200, 1 , 34 , 55, 66, 99, 2 , 0


.section .text
    
.globl _start

_start: #This where the program starts 
    

    movl $0 ,%edi  #load the first idx
    movl data_items(,%edi,4) , %eax #firs element

    movl %eax, %ebx #assume the curr is the max

start_loop:
    
    cmpl $0, %eax #check if we are not at the end...(zero termination) 
    je loop_exit
    
    incl %edi #load the next value. 

    movl data_items(,%edi,4) , %eax #curr element(again)

    cmp %ebx, %eax #compare curr with curr_max
    jle start_loop #jumps to start the loop again if new_val(curr_max) is not bigger than curr_val

    movl %eax, %ebx #else make the curr value the max if it's bigger
    jmp start_loop #keep going.
    
loop_exit: #You know what this does.
    # %ebx holds the max value. run echo $? to varify
    movl $1, %eax
    int $0x80 #interupt the program.

    



