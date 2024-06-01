#pragma once

// Types
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;
typedef char i8;
typedef short i16;
typedef int i32;
typedef long long i64;
typedef u32 size_t;
typedef u32 uintptr_t;
typedef float f32;
typedef double f64;

// Boolean
typedef u8 bool;
#define true (1)
#define false (0)

static inline u8 inb(u16 port) {
    u8 r;
    __asm__("inb %1, %0" : "=a" (r) : "dN" (port));
    return r;
}

static inline void outb(u16 port, u8 data) {
    __asm__("outb %1, %0" : : "dN" (port), "a" (data));
}

static inline size_t strlen(const char* str) {
    size_t l = 0;
    while (*str++) { l++; }
    return l;
}

static void itoa(char *buf, int base, int d) {
    char *p = buf;
    char *p1, *p2;
    unsigned long ud = d;
    int divisor = 10;

    /* If %d is specified and D is minus, put ‘-’ in the head. */
    if (base == 'd' && d < 0) {
        *p++ = '-';
        buf++;
        ud = -d;
    } else if (base == 'x')
        divisor = 16;

    /* Divide UD by DIVISOR until UD == 0. */
    do {
        int remainder = ud % divisor;
        *p++ = (remainder < 10) ? remainder + '0' : remainder + 'a' - 10;
    } while (ud /= divisor);

    /* Terminate BUF. */
    *p = 0;

    /* Reverse BUF. */
    p1 = buf;
    p2 = p - 1;
    while (p1 < p2) {
        char tmp = *p1;
        *p1 = *p2;
        *p2 = tmp;
        p1++;
        p2--;
    }
}

void dputs(const char* s) {
    int i = 0;
    for (;;) {
        if (s[i] == '\0') break;
        outb(0xe9, s[i]);
        *(char*)0xB8000 = s[i];
        i++;
    }
}

void serial_puts(const char* str) {
    char addr[16];
    char len[16];

    itoa(addr, 'x', (u32)str);
    itoa(len, 'd', strlen(str));

    int i;
    for (i = 0; i < strlen(addr); i++) {
        outb(0xe9, addr[i]);
    }

    outb(0xe9, '\n');
}