#WHAT THIS DOES 
#           1:Define some test records(hardcode)
#           2:Open a new file
#           3:Write each record to that file
#           4:Close that file

.section .data

#---------record 1 (Fredrick Bartlett)--------#
    .ascii  "Fredrik\0"                         # First name
    .rept   31
        .byte 0
    .endr

    .ascii  "Bartlett\0"                          # Last name 
    .rept   31
        .byte 0
    .endr
    
    .ascii  "4242 S Prairie\nTulsa, OK 55555\0"  # Address
    .rept   209
        .byte 0 
    .endr 

    .long   45                                    #Age 


#---------record 2 (Mariyln Taylor)--------#

    .ascii  "Marilyn\0"                         # First name
    .rept   32
        .byte 0
    .endr

    .ascii  "Taylor\0"                          # Last name 
    .rept   33
        .byte 0
    .endr
    
    .ascii  "4242 S Prairie\nTulsa, OK 55555\0"  # Address
    .rept   203
        .byte 0 
    .endr 

    .long   29                                   #Age 

#---------record 3 (Derrick McIntire)--------#

    .ascii  "Derrick\0"                         # First name
    .rept   32
        .byte 0
    .endr

    .ascii  "McIntire\0"                          # Last name 
    .rept   31
        .byte 0
    .endr
    
    .ascii "500 W Oakland\nSan Diego, CA 54321\0"  # Address
    .rept   206
        .byte 0 
    .endr 

    .long   36                                   #Age 


#-------file name (for our "database")--------

file_name: 
    .ascii "test_dat\0"


.section .text

.globl _start

_start: 

#-------open file to write--------------#

    movl $SYS_WRITE , %eax                  #sys_write
    movl $file_name , %ebx                  #file pointer
    movl $0101 , %ecx                       #(create + write) only
    movl $0666, %edx                        #mode (rw-rw-rw) read write for all , no exe
    int  $LINUX_SYSCALL

    movl %eax , %ebx                        #save file descriptor to EBX

    # WRITE RECORD 1-------------
    
    movl $SYS_WRITE  , %eax
    movl $record1 , %ecx                    #buffer adress ( what to write)
    movl $RECORD_SIZE , %edx                #writes 324 bytes (each record is that amount)
    int $LINUX_SYSCALL

    # WRITE RECORD 2--------------
    
    movl $SYS_WRITE  , %eax
    movl $record2 , %ecx                    #buffer adress ( what to write)
    movl $RECORD_SIZE , %edx                #writes 324 bytes (each record is that amount)
    int $LINUX_SYSCALL

    # WRITE RECORD 3 --------------
    
    movl $SYS_WRITE  , %eax
    movl $record3 , %ecx                    #buffer adress ( what to write)
    movl $RECORD_SIZE , %edx                #writes 324 bytes (each record is that amount)
    int $LINUX_SYSCALL


    #CLOSE THE FILE 

    movl $SYS_CLOSE , %eax
    int $LINUX_CLOSE

    #exit 
    
    movl %SYS_EXIT , %eax 
    movl $0 , %ebx 
    int $LINUS_SYSCALl











