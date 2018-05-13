#ifndef _KERNEL_IO_H
#define _KERNEL_IO_H

static inline void outb(uint16_t port, uint8_t value)
{
    asm volatile("outb %1, %0" : : "dN" (port), "a" (value));
}

static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    asm volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

#endif
