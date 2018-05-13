#include <stdio.h>

#if defined(__is_libk)
#include <kernel/tty.h>
#include <serial.h>
#endif

int putchar(int ic) {
#if defined(__is_libk)
    char c = (char) ic;
    if (ic != 10 )
        terminal_write(&c, sizeof(c));
    else
        terminal_putline();
    write_to_serial(ic);
#else
    // TODO: Implement stdio and the write system call.
#endif
    return ic;
}

// TODO: Evaluate if this function really makes sense
int putline(int ic)
{
#if defined(__is_libk)
    terminal_putline();
#else
    // TODO: Implement stdio and the write system call.
#endif
    return ic;
}
