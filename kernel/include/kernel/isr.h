#ifndef _KERNEL_ISR_H
#define _KERNEL_ISR_H

// Install the ISRS into the IDT, should be called on early initialization
void isr_install();

#endif