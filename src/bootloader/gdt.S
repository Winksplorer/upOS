; src/bootloader/gdt.S: upOS Global Descriptor Table
; Licensed under the MIT license.

gdt:
    dw .size - 1 + 8  ; GDT size
    dd .start - 8     ; GDT start address

    .start:
        ; null segment
        dw 0x0000       ; Limit
        dw 0x0000       ; Base (low 16 bits)
        db 0x00         ; Base (mid 8 bits)
        db 0x00         ; Access
        db 0x00         ; Granularity
        db 0x00         ; Base (high 8 bits)

        ; 32-bit code
        dw 0xffff       ; Limit
        dw 0x0000       ; Base (low 16 bits)
        db 0x00         ; Base (mid 8 bits)
        db 10011011b    ; Access
        db 11001111b    ; Granularity
        db 0x00         ; Base (high 8 bits)

        ; 32-bit data
        dw 0xffff       ; Limit
        dw 0x0000       ; Base (low 16 bits)
        db 0x00         ; Base (mid 8 bits)
        db 10010011b    ; Access
        db 11001111b    ; Granularity
        db 0x00         ; Base (high 8 bits)

  .end:

  .size: equ .end - .start