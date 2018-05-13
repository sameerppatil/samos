#ifndef _KERNEL_SERIAL_H
#define _KERNEL_SERIAL_H

#define PORT 0x3F8 /* COM1 */

void serial_init(void);
int serial_received(void);
char read_serial(void);
int is_transmit_empty(void);
void serial_byte_write(char );
void write_to_serial(int );

#endif
