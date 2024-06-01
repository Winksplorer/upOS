#include <util.h>

const char test[] = "Welcome to upOS!";

void _main() {
    //*(char*)0xB8000 = 'C';
    //*(char*)0xB8001 = 0x0A;

    char hello[strlen(test)];
    for (int i = 0; i < 5; i++) {
        hello[i] = test[i];
    }

    *(char*)0xB8000 = hello[0];
    *(char*)0xB8001 = 0x0B;

    /*__asm__ ("mov %al, 'T'\n\t"
             "out 0xe9, %al");*/

    /*char* test123 = test;
    outb(0xe9, test123[0]);

    char addr[16];
    char len[16];

    itoa(addr, 'x', test123);

    int i;
    for (i = 0; i < strlen(addr); i++) {
        outb(0xe9, addr[i]);
    }

    

    outb(0xe9, '\n');*/

    //serial_puts(test);
    //test2(test);

    //char* test3 = *(char*)0x11000;
    //outb(0xe9, test3[0]);

    for (;;);
}

//void test2(char* unused) {
//    outb(0xe9, unused[0]);
//}