#THIS PROGRAM WILL FIND A FACTORIAL OF NUMBER n 

#FACTORIAL = n * (n-1) * (n-1) * ...*1 
#                           when n ==1 return 1 (CALLED BASE CASE)

.section .data              #empty .. no gobal vars 
.section .text

.globl _start
.globl factorial

_start:
    
    pushl $5                #n == 5 (find factorial of 5)
    call factorial
    addl $4 , %esp          #clean the stack

    movl %eax , %ebx        #move th returned val to return status     
    movl $1 , %eax          #Exit the program.
    int $0x80               #ping the sys you wanna exit.


#=========func factorial(n)===========
factorial: 
    
    pushl %ebp              #save the old frame pointer
    movl %esp , %ebp        #adjst the stack pointer
    movl 8(%ebp), %eax      #0 hols old ebp , 4 hols return addr

    cmpl $1 , %eax          #if returned val is 1 , return 1
    je end_factorial

    #else
    decl %eax               #decresse n (n--)
    push %eax               #push the new "n" (n--)
    call factorial  

    movl 8(%ebp), %ebx      #get the prev param
    
    imull %ebx , %eax       #Multiply by returned value
                            #results stored in EAX 

.type power , @function
power:
    pushl %ebp
    movl %esp, %ebp

    subl $4, %esp          # space for local var (accumulator)

    movl 8(%ebp), %ebx     # base
    movl 12(%ebp), %ecx    # power

    cmpl $0, %ecx
    je handle_zero         # if power == 0 → return 1

    movl %ebx, -4(%ebp)    # accumulator = base
    jmp power_loop_start   # **IMPORTANT**: prevent fallthrough

handle_zero:
    movl $1, %eax          # return 1
    jmp end_power

power_loop_start:
    cmpl $1, %ecx
    je end_power

    movl -4(%ebp), %eax
    imull %ebx, %eax       # acc *= base
    movl %eax, -4(%ebp)

    decl %ecx
    jmp power_loop_start

end_power:
    movl -4(%ebp), %eax   # move result into %eax
    movl %ebp, %esp
    popl %ebp
    ret


end_factorial: 
    movl %ebp , %esp 
    popl %ebp 
    ret





