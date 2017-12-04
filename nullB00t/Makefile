KERNEL = nullB00t.bin
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386

all: $(KERNEL)

$(KERNEL):
	$(ASM) nullB00t.asm $(ASM_FLAGS) -o $(KERNEL)

.PHONY: clean qemu

qemu: clean $(KERNEL)
	$(QEMU) $(KERNEL)

clean:
	$(RM) *.o *.swp ~* $(KERNEL)
