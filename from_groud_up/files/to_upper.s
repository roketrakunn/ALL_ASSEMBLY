#This prpgram converts an input file to an output file with all leters in upper case: 


#PROCESSING: 
#           1:Open input file.
#               Read the input to a buffer
#           2.Open output file
#               From out buffer write to output file.
#               Converting all lower cases to upper case.
#           3.Close both files
#           4.Exit

.section .data
    
    #syscall numbers 
    .equ SYS_OPEN , 5
    .equ SYS_WRITE , 4
    .equ SYS_READ , 3
    .equ SYS_CLOSE , 6
    .equ SYS_EXIT , 1

    .equ R_ONLY , 0
    .equ CREAT_WRONLY_TRUNC ,03101
    
    #std file discriptors

    .equ STD_IN , 0 
    .equ STD_OUT , 1
    .equ STD_ERR , 2


    #interupt linux syscall 
    .equ LINUX_SYSCALL , 0x80

    .equ END_OF_FILE , 0
    .equ NUMBER_ARGUMENTS , 2

.section .bss

#BUffer - bytes that we read the input file to and
#       and write the output file from
#       shoudl never exceed 16 000

.equ BUFFER_SIZE , 500
.lcomm BUFFER_DATA , BUFFER_SIZE

.section .text

#STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0 #Number of arguments
.equ ST_ARGV_0, 4 #Name of program
.equ ST_ARGV_1, 8 #Input file name
.equ ST_ARGV_2, 12 #Output file name

.globl _start

_start:
    movl %esp , %ebp        #creat stack frame 
    subl $ST_SIZE_RESERVE , %esp

open_file:  
open_fd_in: 
    
    movl $SYS_OPEN , %eax           #sys_open
    movl ST_ARGV_1(%ebp) , %ebx     #move filename to EBX 
    movl $R_ONLY , %ecx              #flag
    movl $0666 , %edx               #mode rw-rw-rw
    int  $LINUX_SYSCALL               #syscall

store_fd_in: 
    movl %eax , ST_FD_IN(%ebp)      #store in locale_1(in) 

open_fd_out: 

    movl $SYS_OPEN , %eax           #sys_open
    movl ST_ARGV_2(%ebp) , %ebx     #move filename to EBX 
    movl $CREAT_WRONLY_TRUNC , %ecx #flag
    movl $0666 , %edx               #mode rw-rw-rw
    int  $LINUX_SYSCALL               #syscall

store_fd_out: 
    movl %eax , ST_FD_OUT(%ebp)     #locale_2 fd of out_file

read_loop_begin: 
    
    #READ THE INPUT FILE

    movl $SYS_READ , %eax 
    movl ST_FD_IN(%ebp) , %ebx      #move the df of input_file.
    movl $BUFFER_DATA , %ecx        #location to read to. 
    movl $BUFFER_SIZE , %edx        #Buffer size.
    int $LINUX_SYSCALL              #Size of read_buffer in EAX

    cmpl $END_OF_FILE , %eax        #check end of file
    jle end_loop 


continue_loop: 
    
    pushl $BUFFER_DATA 
    pushl %eax
    call convert_to_upper
    popl %eax 
    addl $4 , %esp

#write the block out to the output file

    #size of the buffer
    movl %eax, %edx
    movl $SYS_WRITE, %eax
    #file to use
    movl ST_FD_OUT(%ebp), %ebx
    #location of the buffer
    movl $BUFFER_DATA, %ecx
    int $LINUX_SYSCALL

    jmp  read_loop_begin

end_loop: 
    
    #close both files

    #CLOSE OUTPUT FILE
    movl $SYS_CLOSE , %eax          #sys_close
    movl ST_FD_OUT(%ebp) , %ebx
    int $LINUX_SYSCALL

    #CLOSE INPUT FILE
    movl $SYS_CLOSE , %eax          #sys_close
    movl ST_FD_IN(%ebp) , %ebx
    int $LINUX_SYSCALL

    movl $SYS_EXIT , %eax           #exit 
    movl $0 , %ebx 
    int $LINUX_SYSCALL


#PURPOSE: This function actually does the
# conversion to upper case for a block

#INPUT: The first parameter is the location
#       of the block of memory to convert


# The second parameter is the length of that buffer

#OUTPUT: 
#       This function overwrites curr buffer with upper cased version

#VARIABLES: 
        
#       EAX = beginning of buffer 
#       EBX = lentgh of buffer
#       EDI = current buffer ofset
#       CL = curr byte being examined(first part of ECX) 

#CONSTANTS 

.equ LOWERCASE_A , 'a'      #lower boundry of the search
.equ LOWERCASE_Z , 'z'      #upper boundry of the search 
.equ UPPER_CONVERSION , 'A' - 'a'

#STACK STUFF
.equ ST_BUFFER_LEN, 8 #Length of buffer
.equ ST_BUFFER, 12 #actual buffer

convert_to_upper: 
    pushl %ebp
    movl %esp, %ebp

    #VARIABLES
    movl ST_BUFFER(%ebp) , %eax
    movl ST_BUFFER_LEN(%ebp) , %ebx
    movl $0 , %edi

    cmpl $0 , %ebx          #if zero len buffer passed ,exit
    je end_convert_loop

    
convert_loop:
    movb (%eax, %edi , 1) , %cl        #get curr byte. 

    cmpb $LOWERCASE_A , %cl
    jl next_byte

    cmpb $LOWERCASE_Z , %cl
    jg next_byte

    addb $UPPER_CONVERSION, %cl         #esle convert the byte
    movb %cl , (%eax , %edi , 1)        #store the byte back
    
next_byte: 
    
    incl %edi                            #check if we at the end 
    cmpl %edi , %ebx
    jne convert_loop

end_convert_loop: 
    movl %ebp , %esp                    #No returned val(!eq)
    popl %ebp 
    ret











    


    


    









    
