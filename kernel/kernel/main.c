#include <stdio.h>

#include <kernel/tty.h>

void kernel_early(void)
{
	terminal_initialize();
}


void kernel_main(void)
{
	printf("Hello, kernel World!\n");
}
