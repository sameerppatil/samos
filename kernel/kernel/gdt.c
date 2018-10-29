#include <kernel/gdt.h>
#include <stdio.h>

gdtEntry_t gdtEntries[3];
gdtPtr_t gdtPtrVal;

extern void gdtFlush(gdtPtr_t* gdtPtrAddr);

static void init_descriptor_table();
static void gdtSetGate(int32_t num, uint32_t base, uint32_t limit, uint8_t access,
    uint8_t gran);

void initGdt(void)
{
    init_descriptor_table();
    printf("GDT table init done!\n");
}

static void gdtSetGate(int32_t num, uint32_t base, uint32_t limit, uint8_t access,
    uint8_t gran)
{
    gdtEntries[num].base_low = (base & 0xFFFF);
    gdtEntries[num].base_middle = (base >> 16) & 0xFF;
    gdtEntries[num].base_high = (base >> 24) & 0xFF;

    gdtEntries[num].limit_low = (limit & 0xFFFF);
    gdtEntries[num].granularity = ((limit >> 16) & 0x0F);

    gdtEntries[num].granularity |= (gran & 0xF0);
    gdtEntries[num].access = access;
}

static void init_descriptor_table()
{
    gdtPtrVal.limit = (sizeof(gdtEntry_t) * 3) - 1;
    gdtPtrVal.base = (uint32_t)&gdtEntries;

    gdtSetGate(0, 0, 0, 0, 0);
    // Kernel code segment
    gdtSetGate(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    // Kernel data segment
    gdtSetGate(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

    gdtFlush(&gdtPtrVal);
}
