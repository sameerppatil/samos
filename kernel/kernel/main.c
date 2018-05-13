#include <stdio.h>

#include <kernel/tty.h>
#include <serial.h>

void kernel_early(void)
{
    terminal_init();
    serial_init();
}


void kernel_main(void)
{
    int i = 45;
    char* welMsg = "Kernel World";

    printf("Hello, Welcome to: %s, %d!\n", welMsg, i);
    printf("Will try putting on serial!\n");
    printf("This is second line!");
}
