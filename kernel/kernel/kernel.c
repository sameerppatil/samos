#include <stdio.h>

#include <kernel/tty.h>
#include <kernel/gdt.h>
#include <kernel/idt.h>
#include <kernel/isr.h>

void kernel_early(void)
{
	terminal_initialize();
	gdt_install();
	idt_install();
	isr_install();
}


void kernel_main(void)
{
	printf("Hello, kernel World!\n");
}
