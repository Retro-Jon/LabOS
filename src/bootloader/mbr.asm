[ORG 0x7c00]
[BITS 16]

boot:
    jmp 0:_start
    
    times 0x0B-($-$$) db 0

    ; BIOS Parameter Block
    OEMname:           db    "mkfs.fat"
    BytesPerSector:    dw    512
    SectorsPerCluster: db    0
    ReservedSectors:   dw    0
    NumFAT:            db    0
    NumRootDirEntries: dw    0
    NumSectors:        dw    0
    MediaType:         db    0
    NumFATsectors:     dw    0
    SectorsPerTrack:   dw    0
    NumHeads:          dw    0
    NumHiddenSectors:  dd    0
    NumSectorsHuge:    dd    0
    DriveNum:          db    0
    Reserved:          db    0
    Signature:         db    0
    VolumeID:          dd    0
    VolumeLabel:       db    "LabOS      "
    FileSysType:       db    "FAT12   "

%include "src/bootloader/disk.asm"
%include "src/bootloader/gdt.asm"

BOOT_DRIVE db 0
KERNEL_OFFSET equ 0x0800

_start:
    mov ax, 0
    mov ds, ax
    mov bx, 0x8000
    mov ss, bx
    mov sp, ax

    load_kernel:
        mov bx, KERNEL_OFFSET   ; destination
        mov al, 4               ; # sectors
        mov dh, [BOOT_DRIVE]    ; disk
        mov cl, 2               ; start sector

        call disk_load
    
    kernel_start:
        mov ax, 0
        mov ss, ax
        mov sp, 0xfffc
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax

        cli
        lgdt[gdt_descriptor]
        mov eax, cr0
        or eax, 0x1
        mov cr0, eax
        jmp CODE_SEG:kernel

times 510-($-$$) db 0
dw 0xaa55

[bits 32]

kernel:
    push ebp
    mov ebp, esp

