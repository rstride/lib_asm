global ft_strcpy
section .text

ft_strcpy:
    mov rax, rdi        ; Save destination address in RAX (return value)
.loop:
    mov al, [rsi]       ; Load byte from source string
    mov [rdi], al       ; Store byte in destination string
    inc rsi             ; Move to the next byte in source
    inc rdi             ; Move to the next byte in destination
    test al, al         ; Check if byte is the null terminator
    jne .loop           ; If not, continue loop
    ret                 ; Return the destination address
