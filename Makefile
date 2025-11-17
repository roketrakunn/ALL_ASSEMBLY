
#Efficiency is key(I AM LAZY)

ASM        = nasm
ASMFLAGS   = -f elf32
LD         = ld
LDFLAGS    = -m elf_i386

SRC        = $(wildcard src/*.asm) #contains src files
OBJ        = $(patsubst src/%.asm, build/%.o, $(SRC))
OUT        = program

all: $(OUT)

$(OUT): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

#"run"
build/%.o: src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

run: $(OUT)
	./$(OUT)

clean:
	rm -f build/*.o $(OUT)

