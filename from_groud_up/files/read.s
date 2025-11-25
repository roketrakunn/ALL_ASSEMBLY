#This program reads from a file to a buffer and then prints that to your screen/my screen 

.section .data
    
    filename:   .asciz "input.txt"  #file reading from
    buffer: .space 32   #allocate 32 bytes for reading

.section .text
.globl _start

_start: 
    #---------open(filemae , flags , mode)-----

    movl $5 , %eax          #sys_open
    movl $filename , %ebx   #filename to EBX
    movl $0 , %ecx          #we only read
    movl $0 , %edx          #mode: Ignored(we just readin)
    int $0x80               #ping sys

    movl %eax , %edi        #save fd 

    #--------read(fd , buffer , 32(len/bytes))
    movl $3 , %eax          #sys_read
    movl %edi , %ebx        #EBX = fd
    movl $buffer , %ecx     #buffer to raed into 
    movl $32 , %edx         #max bytes to write
    int $0x80
    
    movl %eax , %esi        #save number of bytes read. 

    #---------write(1 , buffer , bytes_read)
    movl $4 , %eax          #sys_read
    movl $1 , %ebx          #std_out 
    movl $buffer , %ecx     #to write to
    movl %esi , %edx        #bytes read
    int $0x80

    #-----close (fd = ebx)-----------------

    movl $6 , %eax          #sys_close
    movl %edi , %ebx
    int $0x80

    # exit 
    movl $1 , %eax 
    movl $0 , %ebx 
    int $0x80






