# Mini cat 
.equ SYS_READ,  0
.equ SYS_WRITE, 1
.equ SYS_EXIT,  60
.equ FD_STDIN,  0
.equ FD_STDOUT, 1
.equ BUFSIZE,   4096

.section .bss
buffer: .space BUFSIZE

.section .text
.globl _start

_start:
read_loop:
    mov $SYS_READ, %rax      # Note: $immediate, %register, and src,dst order
    mov $FD_STDIN, %rdi
    lea buffer(%rip), %rsi   # Use RIP-relative addressing for position-independent code
    mov $BUFSIZE, %rdx
    syscall
    
    cmp $0, %rax             # Check if EOF
    je exit
    
    mov %rax, %rdx           # Save read count
    mov $SYS_WRITE, %rax
    mov $FD_STDOUT, %rdi
    lea buffer(%rip), %rsi
    syscall
    
    jmp read_loop

exit:
    mov $SYS_EXIT, %rax
    xor %rdi, %rdi
    syscall
