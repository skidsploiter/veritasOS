bits 16
org 0x7C00

boot: jmp main
nop

; BIOS crap
bsOemName:            db "vOSBeta1"
bpbBytesPerSector:    dw 0x0200
bpbSectorsPerCluster: db 0x01
bpbReservedSectors:   dw 0x0001
bpbNumberOfFATs:      db 0x02
bpbRootEntries:       dw 0x00E0
bpbTotalSectors:      dw 0x0B40
bpbMedia:             db 0xF0
bpbSectorsPerFAT:     dw 0x0009
bpbSectorsPerTrack:   dw 0x0012
bpbHeadsPerCylinder:  dw 0x0002
bpbHiddenSectors:     dd 0x00000000
bpbTotalSectorsBig:   dd 0x00000000
bsDriveNumber:        db 0x00
bsUnused:             db 0x00
bsExtBootSignature:   db 0x29
bsSerialNumber:       dd 0x00010203
bsVolumeLabel:        db "V_OS__10"
bsFileSystem:         db "FAT12   "

; some messages to show it’s alive
bootloader_started_msg db "Boot loader started...", 0x0D, 0x0A, 0
floppy_reset_msg       db "Floppy disk reset...", 0x0D, 0x0A, 0
kernel_loaded_msg      db "Kernel loaded...", 0x0D, 0x0A, 0
bootloader_complete_msg db "Bootloader complete.", 0x0D, 0x0A, 0

; prints stuff
print_msg:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

; floppy go brr
reset_floppy:
    mov ah, 0x00
    mov dl, 0x00
    int 0x13
    jc reset_floppy
    mov si, floppy_reset_msg
    call print_msg
    ret

; load kernel from floppy because why not
read_kernel:
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, 0x00
    int 0x13
    jc read_kernel
    mov si, kernel_loaded_msg
    call print_msg
    jmp 0x1000:0x0000

; main stuff happens here (barely)
main:
    mov si, bootloader_started_msg
    call print_msg
    call reset_floppy
    call read_kernel
    ; if you see this, something’s probably broken
    mov si, bootloader_complete_msg
    call print_msg

; boot sig or BIOS throws a fit
times 510 - ($ - $$) db 0
dw 0xAA55
