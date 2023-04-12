[ORG 0x7c00]
[BITS 16]

KERNEL_OFFSET equ 0x0500

global boot

boot:
    jmp _start
    
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

_start:
    cli
    ; Clear segments
    xor ax, ax
    mov es, ax
    mov ds, ax

    sti
    mov bp, 0x7c00
    mov ss, ax
    mov sp, bp

    mov bx, KernelLoading
    call print_string

    call load_kernel

    mov bx, StartingOS
    call print_string

    jmp enter_protected_mode

KernelLoading db "Loading Kernel...", 0x0a, 0x0d, 0x00
StartingOS db "Starting Lab OS...", 0x0a, 0x0d, 0x00

%include "src/bootloader/gdt.asm"
%include "src/bootloader/switch-to-32bit.asm"

BOOT_DRIVE db 0

[BITS 16]
load_kernel:
    mov bx, KERNEL_OFFSET   ; destination
    mov al, 1               ; # sectors
    mov dh, [BOOT_DRIVE]    ; disk

    call disk_load

    ret

[BITS 32]
start_kernel:
    jmp CODE_SEG:KERNEL_OFFSET ; start kernel

times 510-($-$$) db 0
dw 0xaa55
