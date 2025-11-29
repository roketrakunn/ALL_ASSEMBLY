#What this program does
#                   1: Open file in read and write mode 
#                   2: Loop through the records
#                          - read the record
#                          - check if last name macthes target
#                          - if match
#                               + increment age
#                               + Seek back to the start of the record
#                               + write the updated record (324 bytes)
#                   3:Close the file

.include "record-def.s"

.section .data
    file_name: 
        .ascii "test.dat\0"

    search_name: 
        .ascii "Bartlett\0"                 #This is teh guy we are looking for in this case

.section .bss
    .lcomm record_buffer , RECORD_SIZE

.section .text 
.globl _start

_start: 

    #Open the file in read and write mode

    movl $SYS_OPEN , %eax
    movl $file_name , %ebx 
    movl $2 , %ecx                      #Read and write 
    movl $0 , %edx                      #Igore mode
    int $LINUX_SYSCALL
    
    movl %eax , $edi                    # Save the df
    movl 0 , %esi                       #Record counter ( what record are we on)



record_loop:
    
    #Read one first record
    movl $SYS_READ , %eax
    movl %edi , %ebx
    movl $record_buffer , %ecx
    movl $BUFFER_SIZE , %edx 
    int $LINUX_SYSCALL

    cmpl $END_OF_FILE , %eax                 #Check  for EOF 
    jle  finished

    #compare lastname 
    #Record buffer + RECORD_LASTNAME = pointer to the last name 

    movl $record_buffer , %eax
    addl $RECORD_LASTNAME , %eax            #EAX now has pointer to lastname of current record

    pushl %eax
    pushl $search_name
    call compare strings                    #returns 0 if matched
    addl $8 , %esp                          #Housekeeping

    cmpl $0 , %eax                          # Did they match
    jne next_record                         # If no move to the next record
    
    #IF they macthed
    movl $record_buffer , %eax
    movl RECORD_AGE(%eax) , %ebx            #Get the age
    incl %ebx                               #increment the age
    movl %ebx , RECORD_AGE(%eax)            #store the age back ( overite the existing one.)

    # Now we need to WRITE this back to the file
    # Problem: we just read, so file position is at NEXT record
    # We need to go BACK to where this record started

       # Calculate where this record starts in file:
    # record_number * RECORD_SIZE
    movl %esi, %eax                   # Record counter
    movl $RECORD_SIZE, %ebx
    mull %ebx                         # %eax = record_num * 324

    #seek there ( move there)

    movl $SYS_LSEEK , %eax
    movl %edi , %ebx
    movl %eax , %ecx                #Offset ( where to seek)
    movl $0 , %edx                  #Seek from the beggining
    int $LINUX_SYSCALL

    # Write once you are there 

    movl $SYS_WRITE , %eax
    movl %edi , %ebx                #file des...
    movl $record_buffer , %ecx
    movl $RECORD_SIZE , %edx
    int $LINUX_SYSCALL


next_record: 
    inlc %esi
    jmp record_loop

finished: 
    
    #Close the file 
    movl $SYS_CLOSE , $eax
    movl %edi , %ebx 
    int $LINUX_SYSCALL

    #exit the program 
    movl $0 , %ebx
    movl $SYS_EXIT , %eax
    int $LINUX_SYSCALL 

compare_strings: 
    
    pushl %ebp 
    movl %esp , %ebp 

    movl 8(%ebp) , %eax                     # First name 
    movl 12(%ebp) , %ebx                    # Second name

compare_loop: 
    
    movb (%eax) , %cl           #char from name 1 
    movb (%ebx) , %dl           #char from name 2

    cmpb %cl , %dl              #compare  
    jne not_equal               #If they are not equal => not a match
    
    #Checl null terminator 
    cmpb $0 , %cl               #coudl be against dl as well 
    je equal                    #if yes => strings(names) match

    incl %eax                   #Move to othe next char
    incl %ebx 

    jmp compare_loop 

not_equal: 
    movl $1 , %eax              #return 1 if not equal 
    jmp done 

equal: 
    movl $0 , %eax 

done: 
    movl %ebp , %esp 
    popl %ebp
    ret






    

    









