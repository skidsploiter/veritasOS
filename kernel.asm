kernel: jmp k_main                  ; jump straight into hell (aka k_main)

; === Strings AKA words on screen ===
kernel_msg     db "Welcome to VeritasOS 1.0!", 0x0D, 0x0A, 0    ; greetings, nerd
input_prompt   db "vOS> ", 0                                    ; the place you pretend to type important stuff
newline        db 0x0D, 0x0A, 0                                 ; magic that moves text to next line
ver_msg        db "VeritasOS | Testing Build v1.0", 0x0D, 0x0A, 0 ; we made it up, but sounds official
help_msg       db "Available commands: ver, cls, help, echo", 0x0D, 0x0A, 0 ; press buttons, get output
input_buffer   times 128 db 0                                   ; RAM gobbler for your keyboard smashing

; === Print a string until null terminator ===
print_msg:
    mov ah, 0x0E            ; BIOS teletype printer mode go brrrr
.next_char:
    lodsb                   ; grab next dumb character
    cmp al, 0               ; reached the end of the line? (the end of hope?)
    je .done
    int 0x10                ; BIOS, please do your thing
    jmp .next_char
.done:
    ret

; === Print one char (when you're lazy) ===
print_char:
    mov ah, 0x0E
    int 0x10
    ret

; === Keyboard gobbler: Reads a full line ===
read_line:
    xor cx, cx              ; counter reset (we ain't typed anything yet)
.read_loop:
    mov ah, 0x00
    int 0x16                ; wait for key like a patient little OS
    cmp al, 0x0D            ; did user press enter? cool.
    je .done
    cmp al, 0x08            ; backspace detected, time to erase their shame
    je .backspace
    stosb                   ; store character into buffer (shove it in RAM)
    call print_char         ; also show it so user feels productive
    inc cx
    cmp cx, 127             ; don't overflow, genius
    je .done
    jmp .read_loop
.backspace:
    cmp cx, 0
    je .read_loop           ; nothing to delete, idiot
    dec cx
    dec di
    mov al, 0x08            ; backspace char
    call print_char
    mov al, ' '             ; overwrite with blank (lie to the user)
    call print_char
    mov al, 0x08            ; move cursor back again
    call print_char
    jmp .read_loop
.done:
    mov al, 0
    stosb                   ; slap a null at the end like a proper C programmer
    mov si, newline
    call print_msg
    ret

; === strcmp but make it BIOS era ===
strcmp:
    push si
    push di
.next:
    lodsb                   ; load a byte from [si]
    cmp al, [di]
    jne .ne                 ; no match? go cry
    cmp al, 0
    je .eq                  ; match till end? cool.
    inc di
    jmp .next
.eq:
    mov al, 1
    jmp .done
.ne:
    xor al, al              ; nah bro they ain't equal
.done:
    pop di
    pop si
    ret

; === Screen-clearing black magic ===
clear_screen:
    mov ah, 0x00
    mov al, 0x03            ; set video mode = clear screen cheat code
    int 0x10
    ret

; === Welcome to The Loop of Doom ===
k_main:
    push cs
    pop ds                  ; segment shenanigans
    mov si, kernel_msg
    call print_msg          ; print intro because we're polite

.loop:
    mov si, newline
    call print_msg
    mov si, input_prompt
    call print_msg          ; ask user for more garbage
    mov di, input_buffer
    call read_line

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

    jmp .loop               ; invalid input? back to suffering

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
    cmp al, ' '             ; find space after "echo"
    je .found_text
    cmp al, 0
    je .loop                ; empty echo, how insightful
    jmp .skip_echo_word
.found_text:
    mov si, si              ; just echo whatever dumb thing user typed
    call print_msg
    jmp .loop

; unused, but sounds important so let's keep it
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

; === Command registry (aka the holy words) ===
cmd_ver  db "ver", 0
cmd_cls  db "cls", 0
cmd_help db "help", 0
cmd_echo db "echo", 0

; === Bootsector padding ===
times 512-($-$$) db 0         ; padding so BIOS doesn't rage quit
