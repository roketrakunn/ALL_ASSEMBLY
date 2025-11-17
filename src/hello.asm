section .text
    global _start

_start: 
    mov eax , 4 ;sys_write 
    mov ebx , 1 ;std_out
    mov ecx , msg ; register pointing to string msg
    mov edx , 1 ; len of msg 

    int 0x80 

    mov eax , 1 ;sys_exit 
    mov ebx , 0 ;definetely exit

    int 0x80 

section .data
    msg db 'A'

