#include <stdio.h>

#include <kernel/tty.h>

void kernel_early(void)
{
	terminal_initialize();
}


void kernel_main(void)
{
    int i = 45;
    char* welMsg = "Kernel World";
	printf("Hello, Welcome to: %s, %d!\n", welMsg, i);

}
