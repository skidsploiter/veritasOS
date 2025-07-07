kernel: jmp k_main

kernel_msg     db "Welcome to VeritasOS 1.0!", 0x0D, 0x0A, 0
input_prompt   db "vOS> ", 0
newline        db 0x0D, 0x0A, 0
ver_msg        db "VeritasOS | Testing Build v1.0", 0x0D, 0x0A, 0
help_msg       db "Available commands: ver, cls, help, echo", 0x0D, 0x0A, 0
input_buffer   times 128 db 0

; just prints whatever’s at SI until it hits 0
print_msg:
    mov ah, 0x0E
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

; print one char in AL
print_char:
    mov ah, 0x0E
    int 0x10
    ret

; grabs keyboard input into input_buffer
read_line:
    xor cx, cx
.read_loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    je .done
    cmp al, 0x08
    je .backspace
    stosb
    call print_char
    inc cx
    cmp cx, 127
    je .done
    jmp .read_loop
.backspace:
    cmp cx, 0
    je .read_loop
    dec cx
    dec di
    mov al, 0x08
    call print_char
    mov al, ' '
    call print_char
    mov al, 0x08
    call print_char
    jmp .read_loop
.done:
    mov al, 0
    stosb
    mov si, newline
    call print_msg
    ret

; string compare but made outta duct tape
strcmp:
    push si
    push di
.next:
    lodsb
    cmp al, [di]
    jne .ne
    cmp al, 0
    je .eq
    inc di
    jmp .next
.eq:
    mov al, 1
    jmp .done
.ne:
    xor al, al
.done:
    pop di
    pop si
    ret

; clears screen the lazy BIOS way
clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ret

k_main:
    push cs
    pop ds
    mov si, kernel_msg
    call print_msg

.loop:
    mov si, newline
    call print_msg
    mov si, input_prompt
    call print_msg
    mov di, input_buffer
    call read_line

    ; dumb if chain to check commands
    mov si, input_buffer
    mov di, cmd_ver
    call strcmp
    cmp al, 1
    je .cmd_ver

    mov si, input_buffer
    mov di, cmd_cls
    call strcmp
    cmp al, 1
    je .cmd_cls

    mov si, input_buffer
    mov di, cmd_help
    call strcmp
    cmp al, 1
    je .cmd_help

    mov si, input_buffer
    mov di, cmd_echo
    call strcmp
    cmp al, 1
    je .cmd_echo

    jmp .loop

.cmd_ver:
    mov si, ver_msg
    call print_msg
    jmp .loop

.cmd_cls:
    call clear_screen
    jmp .loop

.cmd_help:
    mov si, help_msg
    call print_msg
    jmp .loop

.cmd_echo:
    mov si, input_buffer
.skip_echo_word:
    lodsb
    cmp al, ' '
    je .found_text
    cmp al, 0
    je .loop
    jmp .skip_echo_word
.found_text:
    mov si, si
    call print_msg
    jmp .loop

; unused junk?
.find_space:
    lodsb
    cmp al, ' '
    je .found
    cmp al, 0
    je .loop
    jmp .find_space
.found:
    mov si, si
    call print_msg
    jmp .loop

; command strings go here
cmd_ver  db "ver", 0
cmd_cls  db "cls", 0
cmd_help db "help", 0
cmd_echo db "echo", 0

times 512-($-$$) db 0
