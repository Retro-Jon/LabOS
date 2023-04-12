[BITS 16]
%include "src/bootloader/io.asm"

reset_disk:
    push ax

    .loop:
        xor ax, ax
        int 0x13
        jc .loop

    pop ax
    ret

; bx = destination
; al = # sectors
; dh = disk to load from
disk_load:
    cld
    clc

    call reset_disk
    
    mov ah, 0x02    ; Read Sectors Opcode
    mov ch, 0       ; Read from cylinder 0
    mov cl, 2       ; Start from sector2
    mov es, bx
    xor bx, bx

    int 0x13
    jc disk_error
    ret

derror: db "DISK ERROR", 0x0a, 0x0d, 0x00

disk_error:
    mov bx, derror
    call print_string
    jmp disk_loop

disk_loop:
    jmp $