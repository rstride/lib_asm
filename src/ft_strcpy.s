section .text
    global _ft_strcpy

; rdi = dest, rsi = src

_ft_strcpy:
    push rdi                ; Save the destination pointer
    jmp loop                ; Jump to loop

loop:
    cmp BYTE [rsi], 0       ; Compare src byte with 0
    je exit                 ; If src byte is 0, jump to exit
    mov al, [rsi]           ; Load byte from src into al
    mov [rdi], al           ; Store byte into dest
    inc rdi                 ; Increment dest pointer
    inc rsi                 ; Increment src pointer
    jmp loop                ; Repeat the loop

exit:
    mov BYTE [rdi], 0       ; Null-terminate the destination string
    pop rax                 ; Restore the original destination pointer
    mov rax, rdi            ; Set the return value to the destination pointer
    ret                     ; Return