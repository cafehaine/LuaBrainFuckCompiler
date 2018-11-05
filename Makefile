.PHONY: clean

all: test

test: test.o
	ld -o test test.o

test.o:
	nasm -f elf64 -F dwarf -o test.o test.asm

test2: test2.o
	ld -o test2 test2.o

test2.o:
	nasm -f elf64 -F dwarf -o test2.o test2.asm


clean:
	rm -f test test.o test2 test2.o
