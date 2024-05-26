; src/bootloader/stage0.S: upOS bootloader
; Licensed under the MIT license.

[BITS 16]
[global _start]

jmp _start

%include "src/bootloader/gdt.S"

_start:
    cli

    ; segment setup
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; stack
    mov sp, 0x3000

    sti

    mov si, welcome_str
    call print_string

    ; Load the kernel from disk
    mov ah, 2
    mov al, 1
    mov cx, 2
    mov dh, 0
    mov dl, 80h
    mov bx, 0x1000
    mov es, bx
    int 13h
    jc disk_error

    ; Disable interrupts
    cli

    ; Enable the A20 Line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load the GDT
    lgdt [gdt]

    ; Set PE (Protection Enable) bit in CR0 (Control Register 0)
    mov eax, cr0 
    or al, 1
    mov cr0, eax

    ; Perform far jump to selector 08h (offset into GDT, pointing at a 32bit PM code segment descriptor) 
    ; to load CS with proper PM32 descriptor)
    jmp 0x10:PModeMain

disk_error:
    mov si, disk_error_str
    call print_string

    jmp $ ; halt the cpu

print_string:
    lodsb
    or al, al
    jz .done
        
    mov ah, 0x0e
    int 0x10

    jmp print_string

    .done: ret

welcome_str: db "Starting upOS...", 0x0D, 0x0A, 0x00
disk_error_str: db 'Error reading disk. System halted.', 0x0D, 0x0A, 0x00

[BITS 32]

PModeMain:
    jmp 0x10000

times 510 - ($ - $$) db 0
dw 0xAA55