CC = nasm
LD = ld
CCOPTIONS = -f elf64

all: fib

fib: fib.o
	$(LD) fib.o -o fib

fib.o:
	$(CC) $(CCOPTIONS) fib.asm -o fib.o

clean:
	$(RM) *.o
