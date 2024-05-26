; src/kernel/entry.S: Loads the C kernel after we have loaded from disk
; Licensed under the MIT license.

[BITS 32]
[global _start]
[global stackBottom]
    
_start:
    mov byte [0xB8000], 'A' ; trying to remember here
    mov byte [0xB8001], 0x0F ; trying to remember here

    mov al, 'A'
    out 0xe9, al
    jmp $