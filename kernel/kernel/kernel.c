#include <stdio.h>

#include <kernel/tty.h>
#include <kernel/gdt.h>

void kernel_early(void)
{
	terminal_initialize();
	gdt_install();
}


void kernel_main(void)
{
	printf("Hello, kernel World!\n");
}
