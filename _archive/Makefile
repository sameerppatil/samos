CC_HOME = $(HOME)/i686-cc
PATH := $PATH:$(CC_HOME)/opt/cross/bin
TARGET = i686-elf


all:  boot kernel link
	

boot:
	$(TARGET)-as boot.s -o boot.o 

kernel:
	$(TARGET)-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

link:
	$(TARGET)-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

clean:
	rm *.o
