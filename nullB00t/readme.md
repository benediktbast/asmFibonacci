# nullB00t
This is a simple bootloader, that boots and draws a welcome message to the screen.

![nullb00tScreenshot](../assets/nullB00t.png?raw=true)

## You need:
* nasm
* qemu
* gdb

## Build: 

`make qemu`

## Debug:

`make debug`

## Disassemble raw binaries:  

`objdump -D -Mintel,i8086 -b binary -m i386 nullB00t.bin`

