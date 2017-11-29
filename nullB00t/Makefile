BINARIES = nullB00t.bin
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386

all: $(BINARIES)

nullB00t:
	$(ASM) nullB00t.asm $(ASM_FLAGS) -o nullB00t.bin

nullB00tQemu: clean nullB00t
	$(QEMU) -m 16 nullB00t.bin  

.PHONY: clean

clean:
	$(RM) *.o *.swp ~* $(BINARIES)
