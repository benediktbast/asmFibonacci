# nullB00t
This is a simple bootloader, that boots and draws a welcome message to the screen.

![nullb00tScreenshot](../assets/nullB00t.png?raw=true)

## How to build: 
You need:
* nasm
* qemu

`make nullB00tQemu`

## How to disassemble raw binaries:  

`objdump -D -Mintel,i8086 -b binary -m i386 nullB00t.bin`

Note: Maybe you want to replace the qemu command in your make file, according to your system.
I use:

`QEMU = qemu-system-i386`
