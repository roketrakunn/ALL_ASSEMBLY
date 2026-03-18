# ALL_ASSEMBLY

x86 and MIPS assembly programs — written while learning low-level programming from the ground up.

## Contents

### x86 (Linux, 32-bit)

**`from_groud_up/`** — programs from *Programming from the Ground Up* by Jonathan Bartlett:
- File I/O (read, write, append)
- Functions (factorial, power, square, max, sum)
- Records (structured data in assembly)

**`from_groud_up/files/`** — custom implementations: `cat`, `to_upper`, file append

**`rev_Eng/`** — reverse engineering exercise: a crackme binary and its C source

**`src/`** — standalone x86 programs: hello world, exercises

### MIPS

Programs targeting MIPS32 (Mars simulator):
- `addingTwoNumbers.asm`, `addNtoX.asm` — arithmetic
- `evenOrOdd.asm`, `oddsAndEvens.asm` — conditionals
- `reverseArray.asm`, `revArrayTwo.asm` — array manipulation
- `reverseString.asm`, `revInputStr.asm` — string operations
- `for_loop.asm` — loops
- `getMax.asm`, `largerNumber.asm` — comparisons
- `countLength.asm`, `stringLen.asm` — string length
- `sumArray.asm`, `sumNtoX.asm`, `myArrSum.asm` — summation
- `checkCase.asm` — character case checking
- `user_input.asm` — reading user input

### Zig

**`from_groud_up/chapter-10/`** — Zig exercises alongside the assembly work

## Build (x86)

```bash
as --32 -o file.o file.s
ld -m elf_i386 -o output file.o
./output
```

Requires `gcc-multilib` / `lib32-glibc` on 64-bit Linux.
