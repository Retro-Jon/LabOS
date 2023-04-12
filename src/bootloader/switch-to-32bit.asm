[BITS 16]

enter_protected_mode:
    cli                     ; disable interrupts
    lgdt [gdt_descriptor]   ; load GDT descriptor
    mov eax, cr0
    or eax, 0x01            ; enable protected mode
    mov cr0, eax
    
    jmp 0x0008:init_32bit

[BITS 32]

init_32bit:
    mov ax, DATA_SEG        ; update segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; setup stack
    mov esp, ebp
    
    jmp KERNEL_OFFSET
