BINARIES = fibonacci nullB00t.bin
ASM = nasm
ASM_FLAGS = -f elf64
LINKER = ld
QEMU = qemu-system-x86_64

all: $(BINARIES)

nullB00t:
	$(ASM) nullB00t.asm -f bin -o nullB00t.bin

nullB00tQemu: clean nullB00t
	$(QEMU) -m 16 nullB00t.bin  

%.o : %.asm
	$(ASM) $(ASM_FLAGS) -o $@ $<

% : %.o
	$(LINKER) $< -o $@

.PHONY: clean

clean:
	$(RM) *.o *.swp ~* $(BINARIES)
