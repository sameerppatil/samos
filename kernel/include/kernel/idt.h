#ifndef _KERNEL_IDT_H
#define _KERNEL_IDT_H

// Sets up the IDT, should be called on early initialization
void idt_install();

#endif