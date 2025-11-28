# This file defines the structure of our records
.section .data

# Field sizes (how many bytes each field takes)
.equ RECORD_FIRSTNAME, 0      # Offset to firstname (starts at byte 0)
.equ RECORD_LASTNAME, 40      # Offset to lastname (starts at byte 40)
.equ RECORD_ADDRESS, 80       # Offset to address (starts at byte 80)
.equ RECORD_AGE, 320          # Offset to age (starts at byte 320)

.equ RECORD_SIZE, 324         # Total size of one record

# File descriptor constants
.equ LINUX_SYSCALL, 0x80
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_BRW, 19              # lseek

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ END_OF_FILE, 0

