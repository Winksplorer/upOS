; src/bootloader/stage0.S: upOS bootloader
; Licensed under the MIT license.

[bits 16]
[global _start]

jmp _start

%include "src/bootloader/gdt.S"

_start:
    ; Load the kernel from disk
    mov al, 1      ; sectors
    mov ah, 2      ; function
    mov ch, 0      ; cylinder
    mov cl, 2      ; sector
    mov dh, 0      ; head
    xor bx, bx
    mov es, bx   
    mov bx, 0x1000 ; extended segment
    int 13h
    jc .diskError

    ; Disable interrupts, including NMIs
    cli
    mov dx, 0x70
    in al, dx
    or al, 0x80
    out dx, al
    mov dx, 0x71
    in al, dx

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

    .diskError:
        mov si, disk_error_msg
        call print_string
        jmp $

print_string:
    lodsb
    or al, al
    jz .done
        
    mov ah, 0x0e
    int 0x10

    jmp print_string

    .done: ret

disk_error_msg: db 'Error reading disk. System halted.', 0

BITS 32
    
PModeMain:
    mov byte [0xB8000], 'A' ; trying to remember here
    mov byte [0xB8001], 0x0A ; trying to remember here

    mov al, 'A'
    out 0xe9, al
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55