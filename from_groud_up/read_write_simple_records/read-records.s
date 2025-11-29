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
    movl $0_RDONLY , %ecx                           #read only
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

        cmpl $END_OF_FILE , %eax                    #read returns 0 at the end of file  
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
    
    call print_newline

    #print "last name "
    pushl $lastname_label
    call print_string   
    addl $4, %esp

    #Print actual last name ( offest 40)
    movl 8(%ebp) , %eax
    addl $RECORD_LASTNAME , %eax 
    pushl %eax
    call print_string 
    addl $4 , %esp

    call print_newline 

    # "Print adress " 
    pushl $adress_label
    call print_string   
    addl $4, %esp

    movl 8(%ebp) , %eax
    addl $RECORD_ADRESS , %eax
    pushl %eax
    call print_string
    addl $4 , %esp 

    call print_newline 

    # Print "Age: "
    pushl $age_label 
    call print_string 
    addl $4 , %esp 

    movl 8(%ebp) , %eax
    movl RECORD_AGE(%eax) , %eax                      #Load 4-byte integer
    pushl %eax
    call print_number                                  # Convert int to string itoa
    addl $4 , %esp

    call print_newline 
    call print_newline 

    movl %ebp , %esp 
    popl %esp 
    ret


# The label strings:
.section .data
firstname_label:
    .ascii "Firstname: \0"
lastname_label:
    .ascii "Lastname: \0"
address_label:
    .ascii "Address: \0"c
age_label:
    .ascii "Age: \0"
newline:
    .ascii "\n"

#-------------------The helper functions we use--------------------------

print_string: 
    
    pushl %ebp
    movl %esp , %ebp 

    movl 8(%ebp) , %ecx                                 #string adress
    pushl %ecx
    call count_chars
    addl $4 , %esp 
    
    movl %eax , %edx                                    #Len of string ==number of chars
    movl 8(%ebp) , %ecx                                 #string adress

    movl $SYS_WRITE , %eax                              # Write to std out
    movl $STD_OUT , %ebx
    int $LINUX_SYSCALL 

    movl %ebp , %esp 
    popl %ebp 
    ret

count_chars: 
    
    pushl %ebp
    movl %ebp , $esp

    movl 8(%ebp) , %ecx                     #str adress 
    movl $0 , %eax                          #counter , starts at 0

count_loop:
    
    cmpb $0 , (%ecx)
    je count_done
    incl %eax                               #increment counter
    incl %ecx                               #Move to the next byte
    jmp count_loop

count_done:
    movl %ebp , %esp
    popl %esp 
    ret                                     #len in eax

print_newline:
    
    pushl %ebp 
    movl %esp , %ebp 

    movl $SYS_WRITE , %eax
    movl $STD_IN , %ebx
    movl $newline , %eax 
    movl $1 , %edx
    int $LINUX_SYSCALL

    movl %ebp , %esp 
    pop %ebp 
    ret


    
    
    




    








    






