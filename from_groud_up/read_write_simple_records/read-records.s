#HWAT THIS PROGRAM DOES 
#                   1:open file test.dat
#                   2:Loop : read one record at a time
#                   3:Display each record's fiels
#                   4:Stop when we hit the end of the file 

.include "records-def.s"            #Just constants in this file used in this program

.section .data
    file_name:
        .ascii "test_dat\0"

.section .bss
    .lcomm record_buffer , BUFFER_SIZE             #Reserve 324 byted for reading

.section .text
.globl _start

_start: 
    
    movl $SYS_READ , %eax                           #reading syscall
    movl $file_name , %ebx                          #file name 
    movl $0_RDONLY , %eax                           #read only
    movl $0 , %edx                                  #mode does not matter(we just reading)
    int $LINUX_SYSCALL

    movl %eax , %edi                                #Move file descriptor to EBX


record_read_loop: 
    
        #READ ONE RECORD 
        
        movl $SYS_READ , %eax 
        movl %edi , %ebx                            #file descriptor
        movl $record_buffer , %ecx                  # Where to store the data 
        movl $BUFFER_SIZE , %edx                    # How many bytes 
        int $LINUX_SYSCALL

        cmpl $END_OF_FILE , %eac                    #read returns 0 at the end of file  
        jle finished_ reading                       #if at EOF or empty file break loop

        #display the record buffer

        pushl $record_buffer                        # We what we read 
        call print_record                           # Func call(created later)
        addl $4 , %esp                              # House keeping

        jmp record_read_loop 

finished_reading: 
    #close the file 
    movl $SYS_CLOSE , %eax 
    movl %edi , %ebx                                #fd 
    int $LINUX_SYSCALL

    #Exit 

    movl $0 , %ebx                                  #returns status 0 == sucess
    movl $SYS_EXIT , %eax 
    int $LINUX_SYSCALL


#--------func print_record(*record_buffer)----------

#Prints :Names , adress and age.


print_record: 
    pushl %ebp 
    movl %ebp , %esp

    movl 8(%ebp) , %eax                         #The record_buffer pointer stored in EAX now 

    # Print "Firstname: "
    pushl $firstname_label
    call print_string            # Helper function
    addl $4, %esp

     # Print actual firstname (offset 0)
    pushl %eax                   # Record address
    call print_string
    addl $4, %esp







    






