#PURPOSE: Program to manage memory usage - allocates
# and deallocates memory as requested
#
#NOTES: The programs using these routines will ask
# for a certain size of memory. We actually
# use more than that size, but we put it
# at the beginning, before the pointer
# we hand back. We add a size field and
# an AVAILABLE/UNAVAILABLE marker. So, the
# memory looks like this
#
# #########################################################
# #Available Marker#Size of memory#Actual memory locations#
# #########################################################
#                                 ^--Returned pointer
#                                                points here
# The pointer we return only points to the actual
# locations requested to make it easier for the
# calling program. It also allows us to change our
# structure without the calling program having to
# change at all.

.section .data

#######GLOBAL VARIABLES########

#This points to the beginning of the memory we are managing
heap_begin:
.long 0


#This points to one location past the memory we are managing
current_break:
.long 0

######STRUCTURE INFORMATION####


#size of space for memory region header
.equ HEADER_SIZE, 8

#Location of the "available" flag in the header
.equ HDR_AVAIL_OFFSET, 0

#Location of the size field in the header
.equ HDR_SIZE_OFFSET, 4


###########CONSTANTS###########



.equ UNAVAILABLE, 0 #This is the number we will use to mark
#space that has been given out

.equ AVAILABLE, 1 #This is the number we will use to mark
#space that has been returned, and is

#available for giving
.equ SYS_BRK, 45 #system call number for the break


#system call
.equ LINUX_SYSCALL, 0x80 #make system calls easier to read

.section .text

##########FUNCTIONS############
##allocate_init##
#PURPOSE: call this function to initialize the
#         functions (specifically, this sets heap_begin and
#         current_break). This has no parameters and no
#         return value.

.globl allocate_init
.type allocate_init,@function
allocate_init:

    pushl %ebp #standard function stuff
    movl %esp, %ebp
#If the brk system call is called with 0 in %ebx, it
#returns the last valid usable address
    movl $SYS_BRK, %eax #find out where the break is
    movl $0, %ebx
    int $LINUX_SYSCALL
    incl %eax #%eax now has the last valid
#                       address, and we want the
#                       memory location after that
    movl %eax, current_break #store the current break
    movl %eax, heap_begin #store the current break as our

#first address. This will cause
#the allocate function to get
#more memory from Linux the
#first time it is run
    movl %ebp, %esp #exit the function
    popl %ebp
    ret

#END OF PREV FUNCITON------------------------------

##allocate##
# PURPOSE: This function is used to grab a section of
#          memory. It checks to see if there are any
#          free blocks, and, if not, it asks Linux
#          for a new one.
#
# PARAMETERS: This function has one parameter - the size
#             of the memory block we want to allocate


# RETURN VALUE:
#            This function returns the address of the
#            allocated memory in %eax. If there is no
#            memory available, it will return 0 in %eax


# Variables used:
#               %ecx - hold the size of the requested memory
#               (first/only parameter)
#               %eax - current memory region being examined
#               %ebx - current break position
#               %edx - size of current memory region


# We scan through each memory region starting with
# heap_begin. We look at the size of each one, and if
# it has been allocated. If it’s big enough for the
# requested size, and its available, it grabs that one.
# If it does not find a region large enough, it asks
# Linux for more memory. In that case, it moves
# current_break up

.globl allocate
.typep allocate , @function 

allocate: 

    pushl %ebp 
    movl %esp , %ebp 

    movl ST_MEM_SIZE(%ebp) , %ecx           #Firstvar holds the mem size we request
    movl heap_begin , %eax                  #curr search .ocation 
    movl current_break , %ebx               # Curr brak 

    alloc_loop_begin: 
        
        cmpl %ebx , %eax                     #Need more memory from LINUX if these are equal 
        je move_break 
        
        movl HDR_SIZE_OFFEST(%eax) , %edx   #Grab the size of memory
        cmpl $UNAVAILABLE , HDR_AVAIL_OFFEST(%eax) 
        je next_location                                #Check next location 

        cmpl %edx , %ecx                       #If mem is available check if its enough then allocate
        jle allocate_here 

    next_location: 
        
        addl $HEADER_SIZE , %eax    
        addl %edx , %eax                        # The total size of memory region is the HEADER_SIZE
                                                #Plus the amount of memory requesed for (currenlty stored
                                                # in edx)
                                                #so adding $8 , plus EDX ro eax will land you to the next 
                                                  # Memory region 
        jmp alloc_loop_begin 

    allocate_here:                                 #If all went well.
        
        movl $UNAVAILABLE , %eax                # Mark the region as unavailable
        addl $HEADER_SIZE , %eax                #move eax from the header to usable memory 

        movl %ebp , %esp 
        popl %ebp 
        ret


    move_break:                                     # Means that we need to ask for more memory 
        
        addl $HEADER_SIZE , %ebx
        addl %ecx , %ebx 

        push %eax 
        push %ecx 
        push %ebx 

        movl $SYS_BREAK , %eax

        int $LINUX_SYSCALL

        cmpl $0 , %eax
        je error 

        popl %ecx
        popl %ebx
        popl %eax

        movl $UNAVAILABLE , HDR_AVAIL_OFFSET(%eax)          #Mark it as unavailable since we are about to use
        movl %ecx , HDR_SIZE_OFFEST(%eax)

        addl $HEAD_SIZE , %eax                      #EAX now holds th return value of mem 
        
        movl %ebp , %esp 
        popl %ebp 
        ret
    error:                                          #Return zero 
        movl $0 , %eax 
        movl %ebp , %esp 
        popl %ebp 
        ret

#END OF FUNCTON-----------


#DEALLOCATE

#Purpose: 
#       Give back memory after done using it 


#Parameter: 
#       Memory adress we want to return 

#RETURN VALUE :
#              None 

#PROCESS: 
        #Give back 8 storage locations and mark them as vaialable
    
.globl deallocate , @function 

.equ ST_MEMORY_SEG , 4                         # Stack position of the memory region to free.

deallocate: 
    movl ST_MEMORY_SEG(%esp) , %eax             # Get the adress of the memory to free.
    subl $HEADER_SIZE , %eax                    #Resent the pointer back to beginning of memory 
    movl $AVAILABLE , HDR_AVAIL_OFFEST(%eax)      #Mark it as available 

    ret

#the end
    






    


        






