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

int strlen(const char* str) {
    int i = 0;
    while (str[i] != '\0') { i++; }
    return i;
}

void dputs(const char* s) {
    int i = 0;
    for (;;) {
        if (s[i] == '\0') break;
        outb(0xe9, s[i]);
        i++;
    }
}