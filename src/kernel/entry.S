; src/kernel/entry.S: Loads the C kernel after we have loaded from disk
; Licensed under the MIT license.

[BITS 32]

mov al, 'C'
out 0xe9, al

;db 0xDE, 0xAD, 0xBE, 0xEF
;db 'Hello, world', 0

_start:
    mov al, 'B'
    out 0xe9, al
    jmp $
    
;_start:
;    mov byte [0xB8000], 'A' ; trying to remember here
;    mov byte [0xB8001], 0x0A ; trying to remember here
;
;    mov al, 'A'
;    out 0xe9, al
;    jmp $