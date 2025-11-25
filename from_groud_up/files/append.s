#appending to a file 
.section .data
    filename:   .asciz "log.txt"
    
    msg:    .asciz "hello\n"

.section .text
.globl _start

_start:

    #====open(filename , flags , permissions)=========

    movl $5 , %eax      #open syscall
    movl $filename , %ebx
    movl $1089 , %ecx       #flags: WRONLY | APPEND | CREAT
    movl $0664 , %edx       #permissions: rw-r--r--
    int $0x80

    movl %eax , %edi        #fd returned by sys to EAX , save to EDI

    #=====append(fd , message , len/size)

    movl $4 , %eax          #write syscall
    movl %edi , %ebx        #df
    movl $msg , %ecx
    movl $6 , %edx          #size of buffer 
    int $0x80               #ping sys

    #-----close(fd)-------@
    movl $6 , %eax          #close file 
    movl %edi , %ebx
    int $0x80

    movl $1 , %eax      #   @exiting 
    movl $0 , %ebx
    int $0x80



    
