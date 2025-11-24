#non recursive factorial function implementation


.section .data
.section .text
.globl _start

_start: 
    
    pushl $5                #find factorial of 5. 
    call factorial          #call the function. 
    addl $4 , %esp          #clear the stack.

    movl  %eax , %ebx      #move returned res to status code
                            #echo $? to see res.
    movl $1 , %eax
    int $0x80               #exit the code

.type factorial, @function
factorial:
    pushl %ebp
    movl %esp, %ebp

    subl $4, %esp          # local variable (accumulator)

    movl 8(%ebp), %ebx     # n
    movl $1, %ecx          # counter = 1
    movl $1, -4(%ebp)      # accumulator = 1

factorial_loop:
    cmpl %ecx, %ebx
    jl end_factorial       # if counter > n, end

    movl -4(%ebp), %eax    # load accumulator
    imull %ecx, %eax       # eax *= counter
    movl %eax, -4(%ebp)    # store back

    incl %ecx              # counter++
    jmp factorial_loop

end_factorial:
    movl -4(%ebp), %eax    # return value

    movl %ebp, %esp
    popl %ebp
    ret

