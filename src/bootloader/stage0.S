[BITS 16]
[ORG 0x7c00]

_start:
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

    jmp $

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

times 510 - ($ - $$) db 0
dw 0xAA55