.section .data #empty for now
.section .text #empty for now


.globl _start

#uncommet to  only => _start:
    
    movl $1, %eax #holds the sys call number ( 1 is exit )
    movl $0, %ebx #return status to the OS ( change it around if you wanna(i didnt))

    int $0x80  #wakes up the kernel to run the exit cmd

#variables: 
#   %eax => holds syscall number 
#   %ebx => holds the return status number

#check by running
#       echo $?

#Yes the program just exits ... does abs nothing
