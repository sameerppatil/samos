PWD = $(shell pwd)
MAKE ?= make
HOST ?= i686-elf

# Please ensure changes here are reflected inside project directories
OS_NAME ?= samos

CC_HOME = /home/sameerp/garage/samos_cc
PATH := $(PATH):$(CC_HOME)/opt/cross/bin

AR = $(HOST)-ar
AS = $(HOST)-as
CC = $(HOST)-gcc

PREFIX = /usr
EXEC_PREFIX = $(PREFIX)
BOOTDIR = /boot
LIBDIR = $(EXEC_PREFIX)/lib
INCLUDEDIR = $(PREFIX)/include

CFLAGS = '-O2 -g'
CPPFLAGS = ''

# Configure the cross-compiler to use the desired system root.
CC := $(CC) --sysroot=$(PWD)/sysroot

# Work around that the -elf gcc targets doesn't have a system include directory
# because configure received --without-headers rather than --with-sysroot.
CC +=  -isystem=$(INCLUDEDIR)

clean:
	make -C libc clean
	make -C kernel clean
	rm -rfv sysroot isodir $(OS_NAME).iso

headers:
	mkdir -p sysroot
	DESTDIR="$(PWD)/sysroot" $(MAKE) -C libc install-headers
	DESTDIR="$(PWD)/sysroot" $(MAKE) -C kernel install-headers

build: headers
	CC="$(CC)" DESTDIR="$(PWD)/sysroot" $(MAKE) -C libc install
	CC="$(CC)" DESTDIR="$(PWD)/sysroot" $(MAKE) -C kernel install

iso: build
	mkdir -p isodir/boot/grub
	cp sysroot/boot/$(OS_NAME).kernel isodir/boot/$(OS_NAME).kernel
	printf "menuentry \"$(OS_NAME)\" {\n	multiboot /boot/$(OS_NAME).kernel\n}" > isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(OS_NAME).iso isodir

qemu: iso
	qemu-system-i386 -cdrom $(OS_NAME).iso

qemucmd: iso
	qemu-system-i386 -nographic -serial mon:stdio -append 'console=ttyS0' -cdrom $(OS_NAME).iso
