#ifndef _KERNEL_IDT_H
#define _KERNEL_IDT_H
#include <stdint.h>

// Sets up the IDT, should be called on early initialization
void idt_install();

void idt_set_gate(uint8_t num, uint64_t base, uint16_t sel, uint8_t flags);

#endif