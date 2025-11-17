

section .text
    global fix 

fix: 

    mov eax , 10 ; mov  10 to eax reg
    mov ebx , eax  ;mov ~= copy(eax is still 10)

    sub ebx,3 ; sutract 3

    mov eax , 1 ;exit with ebx == 7
    int 0x80

    ;Exit the program 
    mov eax , 1
    mov ebx , 0 
    int 0x80
