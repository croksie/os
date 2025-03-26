[BITS 16]
[ORG 0x7C00]

start:
    ; Désactive les interruptions
    cli
    
    ; Configure le segment
    mov ax, 0x07C0      ; Adresse du bootloader
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack pointer
    
    ; Charge le kernel en mémoire
    mov ax, 0x1000      ; Adresse où charger le kernel
    mov es, ax
    mov bx, 0x0000      ; Offset 0x0000
    mov ah, 0x02        ; Fonction BIOS: Lire le disque
    mov al, 10          ; Nombre de secteurs à lire
    mov ch, 0x00        ; Cylindre
    mov cl, 0x02        ; Secteur 2 (car 1 est le bootloader)
    mov dh, 0x00        ; Tête 0
    mov dl, 0x80        ; Premier disque dur
    int 0x13            ; Appel du BIOS
    jc error            ; Si erreur, saute à error

    ; Passe en mode protégé
    cli                 ; Désactive les interruptions
    lgdt [gdt_desc]     ; Charge la GDT
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x08:protected_mode ; Saut loin pour activer le mode protégé

[BITS 32]

extern kernel_main

protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Appel du kernel
    call kernel_main
    jmp $

error:
    mov si, msg_error
    call print_string
    jmp $

print_string:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

msg_loading db "Loading Kernel...", 0
msg_success db "Kernel Loaded!", 0
msg_error   db "Error Loading Kernel!", 0

; Définition de la GDT
gdt:
    dq 0x0000000000000000    ; Null descriptor
    dq 0x00CF9A000000FFFF    ; Code segment
    dq 0x00CF92000000FFFF    ; Data segment

gdt_desc:
    dw (gdt_desc - gdt) - 1  ; Taille de la GDT
    dd gdt                   ; Adresse de la GDT

times 510-($-$$) db 0
    dw 0xAA55
