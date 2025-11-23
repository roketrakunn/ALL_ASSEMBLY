#LEVELING UP A LIL 
#THIS PROGRAM WILL COMPUTE FROM FROM N to 1
#i.e n + n-1 +n-2+..+1 = results

.section .data
.section .text

.globl _start

_start: 
    pushl $5     #n = 5 ...optional

    call sum_n
    addl $4 , %esp  #clear the stack 

    movl $1 , %eax      #exit the program
    int $0x80 

#=======func sum_n ========
#      func sum_n(n) (sum){...}
#==========================

.type sum_n , @function

sum_n:
    
    pushl %ebp
    movl %esp , %ebp

    subl $4 , %esp      #local vairable

    movl $0 , -4(%ebp)  #initialize zero to the local variable 
    
    movl 8(%ebp), %ecx  #n = program counter
    movl $1 , %ebx      # i

sum_loop:
    
    cmp %ebx , %ecx    #if i >  n exit
    jg sum_end

    movl -4(%ebp) , %eax    #move localeee to reg EAX
    addl %ebx , %eax    #sum sum sum sum baby

    movl %eax , -4(%ebp)    #keep storin the results to local

    incl %ebx   #i++
    jmp sum_loop    #repeat

sum_end: 
    movl -4(%ebp) , %eax    #store the results back tp EAX

    movl %ebp , %esp
    popl  %ebp 
    ret






