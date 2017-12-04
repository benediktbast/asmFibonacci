KERNEL = nullB00t.bin
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386
MAP = nullB00t.map

all: $(KERNEL)

$(KERNEL):
	$(ASM) $(ASM_FLAGS) nullB00t.asm -o $(KERNEL)

.PHONY: clean qemu debug

qemu: clean $(KERNEL)
	$(QEMU) $(KERNEL)

debug: $(KERNEL)
	$(QEMU) -s -S $(KERNEL) > /dev/null 2>&1 &
	sleep 1
	gdb \
		-ex "set disassembly-flavor intel" \
		-ex "set architecture i8086" \
		-ex "target remote localhost:1234" \
		-ex "layout asm" \
		-ex "layout regs" \
		-ex "break *0x7C00" \
		-ex "continue" \
		-ex "disass"

clean:
	$(RM) *.map *.o *.swp ~* $(KERNEL)
