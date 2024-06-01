; src/kernel/entry.S: Loads the C kernel after we have loaded from disk
; Licensed under the MIT license.

[BITS 32]

section .text.prologue

[extern _main]
[global _start]
    
_start:
    mov byte [0xB8000], 'A' ; trying to remember here
    mov byte [0xB8001], 0x0F ; trying to remember here

    mov esp, stackTop

    jmp _main

section .bss

align 16
stackBottom:
resb 4096
stackTop: