#this computes sum of two powered numbers ...
# e.g 3^2 + 3^2 in this example

.section .data #nothing here .. all res are stored in regs on main 
.section .text

.globl _start

_start: 
   
    pushl $3 #push first second(base) argument
    pushl $2 #push first second(power) argument

    call power #to compute 3^2

    addl $8 , %esp #move the stack pointer back into place.

    pushl %eax #save the first res ( a^b) before calling power again

    pushl $5 #push the first(second_ base) argument
    pushl $2 #push the second(second_power) argument

    call power #to compute 5^2

    addl $8 , %esp #move the stack pointer back into place again.

    popl %ebx #pop the second answer
              #The first answer is already in %eax saved ealier

    addl %eax, %ebx #add the two computations .. res stored in %ebx
    movl $1 , %eax #exit ...results in %ebx 
    int $0x80      #echo $? to see


#THE power FUNCTION 
#computes a^b and RETURN the results

#VARIABLES: 
        # %ebx => holds the base number. FIRST ARGUMENT
        # %ecx => holds the power argument SECOND ARGUMENT
        # -4(%ebp) => hols the curr results 
        # %eax => Temp storage 

.type power , @function
power: 
    
    pushl %ebp          #save old base pointer ( needed)
    movl %esp , %ebp    #make stack pointer base pointer

    subl $4 , %esp      #make space for the "local storage".
    
    movl 8(%ebp), %ebx  #move the first argument to %ebx
    movl 12(%ebp), %ecx #move the second argument to %ecx

    movl %ebx, -4(%ebp) #store the curr resulsts.

power_loop_start: 
    
    cmpl $1, %ecx       #if the power is 1 
    je end_power
    movl -4(%ebp), %eax #save the curr results to %eax
    imull %ebx , %eax   #multiply the base by curr results
    
    movl %eax , -4(%ebp)#store the curr resulst

    decl %ecx           #decrement the power

    jmp power_loop_start#next power computation.


end_power: 
    movl -4(%ebp), %eax #store returned val into %eax
    movl %ebp , %esp    #restore the stack pointer
    popl %ebp           #Restore the base pointer
    ret                 #return 







