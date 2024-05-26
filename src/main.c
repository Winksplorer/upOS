#include <util.h>

void _main() {
    *(char*)0xB8000 = 'B';
    *(char*)0xB8001 = 0x0A;

    /*__asm__ ("mov %al, 'T'\n\t"
             "out 0xe9, %al");*/

    //outb(0xe9, test[0]);

    const char test[] = "Welcome to upOS!\0";

    dputs(test);

    for (;;);
}