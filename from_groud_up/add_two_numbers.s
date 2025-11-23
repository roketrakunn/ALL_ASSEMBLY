#This program will add two numbers and return their sum
.section  .data
.section .text 

.globl _start

_start: 
    
    pushl $4        #Push the first argument a 
    pushl $4        #Push the second argument b

    call add_two_numbers        #This pushes return adress.
    addl $8, %esp       #Clean the stack/Delete the vals(this feels like magic to me.)
    
    movl %eax , %ebx        #Resulsts as program return status.
                            #run echo $? to see results

    movl $1 , %eax      #exiting...
    int $0x80       #Ping the sys to exit


#=========add_two_numbers(a,b)==========#

#Variables: 
#       a => firs pushed value to the stack(is at bottom of stack)
#       b => second pushed value to the stack(is at top of stack)


#Returns:
#       Sum in reg %eax

.type add_two_numbers , @function

add_two_numbers:
    
    pushl %ebp      #The frame pointer/Base pointr(points the "window" of a func)
    movl %esp , %ebp        #adjust the stack pointer

    movl 8(%ebp) , %eax     #First argument(remmeber is at "top")
    movl 12(%ebp) , %ebx       #Second argument(remember is at "bottom")

    addl %ebx , %eax        #add the vals and overwrite at %eax

    movl %ebp , %esp        #Nuke the func "window(delets all vars and parms)"
    popl %ebp
    ret     #"jump" to return adress.
    



