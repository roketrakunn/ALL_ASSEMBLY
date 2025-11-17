.data
    prompt1: .asciiz "Enter a number: "
    even:    .asciiz "The number is even.\n"
    odd:     .asciiz "The number is odd.\n"

.text
.globl main
main:
    # prompt user
    li $v0, 4
    la $a0, prompt1
    syscall

    # read int
    li $v0, 5
    syscall
    move $t0, $v0

    # divide by 2
    li $t1, 2
    div $t0, $t1
    mfhi $t2     # move the  remainder to a reg t2

    beq $t2, $zero, is_even
    j is_odd #beatiful "if statement"

is_even: #even handler
    li $v0, 4
    la $a0, even
    syscall
    j done

is_odd: #odd handler
    li $v0, 4
    la $a0, odd
    syscall

done: #exit the program
    li $v0, 10
    syscall


