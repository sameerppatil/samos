# This will set up our new segment registers. We need to do
# something special in order to set CS. We do what is called a
# far jump. A jump that includes a segment as well as an offset.
# This is declared in C as 'extern void gdt_flush();'
.global gdt_flush     # Allows the C code to link to this
.extern _gp            # Says that '_gp' is in another file
gdt_flush:
    mov 4(%esp), %eax
    lgdt (%eax)
    mov $0x10, %ax       # 0x10 is the offset in the GDT to our data segment
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    jmp $0x08, $.flush
.flush:
    ret               # Return back to the C code!