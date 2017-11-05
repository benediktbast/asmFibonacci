BINARIES = fibonacci
ASM = nasm
ASM_FLAGS = -f elf64
LINKER = ld

all: $(BINARIES)

%.o : %.asm
	$(ASM) $(ASM_FLAGS) -o $@ $<

% : %.o
	$(LINKER) $< -o $@

.PHONY: clean

clean:
	$(RM) *.o *.swp ~*


