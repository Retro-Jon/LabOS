[BITS 16]

print_string:
    pusha

    .loop:
        mov ah, 0x0e
        mov al, [bx]
        cmp al, 0
        je .end
        int 0x10
        inc bx
        jmp .loop
    
    .end:
        popa
        ret

char_in:
    pusha

    .in_loop:
        mov ah, 0
        int 0x16

        mov ah, 0x0e
        int 0x10

        cmp al, 0x0d
        jne .in_loop

        mov al, 0x0a
        int 0x10

        jmp .in_loop
    
    .in_end:
        popa
        ret
