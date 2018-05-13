#include <serial.h>
#include <stdint.h>
#include <io.h>
#include <stddef.h>

/**
 * Following functions are taken from https://wiki.osdev.org/Serial_ports
 */
#define SERIAL_CONSOLE_WIDTH 80
static size_t current_console_width = 0;


void serial_init()
{
    outb(PORT + 1, 0x00);    // Disable all interrupts
    outb(PORT + 3, 0x80);    // Enable DLAB (set baud rate divisor)
    outb(PORT + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
    outb(PORT + 1, 0x00);    //                  (hi byte)
    outb(PORT + 3, 0x03);    // 8 bits, no parity, one stop bit
    outb(PORT + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
    outb(PORT + 4, 0x0B);    // IRQs enabled, RTS/DSR set
}

int serial_received()
{
    return inb(PORT + 5) & 1;
}

char read_serial()
{
    while (serial_received() == 0);

    return inb(PORT);
}

int is_transmit_empty()
{
    return inb(PORT + 5) & 0x20;
}

void serial_byte_write(char a)
{
    while (is_transmit_empty() == 0);

    outb(PORT,a);
}


void write_to_serial(int ic)
{
    int remaining;
    if (ic != 10)
    {
        serial_byte_write((char) ic);
        current_console_width++;
    }
    else
    {
        remaining = SERIAL_CONSOLE_WIDTH - current_console_width;
        while ( remaining != 0)
        {
            serial_byte_write(32);
            remaining--;
        }
        current_console_width = 0;
    }

}