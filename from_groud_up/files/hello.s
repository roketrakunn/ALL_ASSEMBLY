#   WRITE HELLO TO out.txt FILE

.section .data
    filename:    .asciz "out.txt"
    message: .asciz "hello world\n"

.section .text

.globl _start
_start: 
    
    #open file(name , mode , flag)

    movl $5 , %eax          #syscal - open 
    movl $filename , %ebx    #filename 
    movl  $0101 , %ecx      #flags: O_WRONLY | CREATE 
    movl $0644 , %edx       #mode: rw-r--r--
    int $0x80   
    movl %eax , %edi


    #write(fd , buffer , size=====

    movl $4 , %eax
    movl %edi , %ebx        #fd
    movl $message , %ecx     #buffer
    movl $12 , %edx          #size 
    int $0x80   

    ###close(fd)
    movl $6 , %eax 
    movl %edi , %ebx
    int $0x80 

    #exit
    movl $1 , %eax 
    xorl %ebx , %ebx
    int $0x80





