# nasmPlayground

This is my playground for learning x86 assembly. Work in progress, So don't expect it to work ;)

## Current projects:
* fibonacci - A fibonacci implementation
* nullB00t - A simple bootloader

## How to build most of the projects:
You need:
*  linux x68_64
*  nasm
*  ld 

`make fibonacci clean` e.g. to build only one project

`make all clean` to build all projects

## nullB00t:
This is a simple bootloader, that boots and draws a welcome message to the screen.

![nullb00tScreenshot](assets/nullB00t.png?raw=true)

To build you need additionally:
* qemu

`make nullB00tQemu`

To assemble:

`objdump -D -Mintel,i8086 -b binary -m i386 nullB00t.bin`

Note: Maybe you need to replace the qemu command in your make file, according to your system.
I use:

`QEMU = qemu-system-x86_64`
