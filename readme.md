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
You need additionally:
* qemu

`make nullB00tQemu`

Note: Maybe you need to replace the qemu command in your make file, according to your system.
I use:

`QEMU = qemu-system-x86_64`
