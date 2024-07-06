section .text

%include "idt.inc"
%include "vga.inc"

[global kbd_install]

; kbd_install - sets up the PS/2 keyboard driver
kbd_install:
    mov ecx, 1
    mov edx, kbd_handler
    call irq_register
    ret

; kbd_handler - handles keyboard interrupts
kbd_handler:
    ;vga_println "Keyboard!"
    xor eax, eax
    in al, 0x60

    mov bl, al
    and bl, 0x80
    cmp bl, 0
    jnz .release

    ; shift down
    cmp al, 0x2a
    je kbd_handler.shift_down
    cmp al, 0x36
    je kbd_handler.shift_down
    
    ; control down
    cmp al, 0x1d
    je kbd_handler.ctrl_down

    ; caps lock
    cmp al, 0x3a
    je kbd_handler.caps

kbd_handler.char:
    cmp byte [kbd_shift], 1
    je .shift

    cmp byte [kbd_caps], 1
    je .caps

    jmp .nothing
kbd_handler.char.shift:
    mov ebx, kbd_map_keys_shift
    jmp kbd_handler.char.print
kbd_handler.char.caps:
    mov ebx, kbd_map_keys_caps
    jmp kbd_handler.char.print
kbd_handler.char.nothing:
    mov ebx, kbd_map_keys
kbd_handler.char.print:
    add ebx, eax
    mov al, [ebx]
    call vga_putchar
    ret
kbd_handler.release:
    ; shift up
    cmp al, 0xaa
    je kbd_handler.shift_rel
    cmp al, 0xb6
    je kbd_handler.shift_rel

    ; control up
    cmp al, 0x9d
    je kbd_handler.ctrl_rel
    ret
kbd_handler.shift_rel:
    mov byte [kbd_shift], 0
    ret
kbd_handler.shift_down:
    mov byte [kbd_shift], 1
    ret
kbd_handler.ctrl_rel:
    mov byte [kbd_ctrl], 0
    ret
kbd_handler.ctrl_down:
    mov byte [kbd_ctrl], 1
    ret
kbd_handler.caps:
    cmp byte [kbd_caps], 0
    jz .off
    mov byte [kbd_caps], 0
    ret
kbd_handler.caps.off:
    mov byte [kbd_caps], 1
    ret

section .rodata

kbd_map_keys:
    db 0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', `\b`
    db `\t`, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', `\n`
    db 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', `\'`, '`', 0
    db `\\`, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-', 0, 0, 0, '+', 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

kbd_map_keys_shift:
    db 0,  27, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', `\b`,
    db `\t`, 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', `\n`,
    db 0, 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', 0,
    db `\\`, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', 0, '*', 0, ' ',
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-', 0, 0, 0, '+', 0, 0,
    db 0, 0, 0, 0, 0, 0, 0, 0, 0

kbd_map_keys_caps:
    db 0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', `\b`,
    db `\t`, 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']', `\n`,
    db 0, 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', `\'`, '`', 0,
    db `\\`, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/', 0, '*', 0, ' ',
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-', 0, 0, 0, '+', 0, 0,
    db 0, 0, 0, 0, 0, 0, 0, 0, 0

section .data

kbd_key_pressed:
    db 0
kbd_char:
    db 0
kbd_caps:
    db 0
kbd_ctrl:
    db 0
kbd_shift:
    db 0