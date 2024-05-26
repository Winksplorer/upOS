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
    while (*str++ != 0) { l++; }
    return l;
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

void serial_puts(char* str) {
    int i;
    for (i = 0; i < strlen(str); i++) {
        outb(0xe9, 'A');
    }
}