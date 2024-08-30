global ft_strlen
section .text

ft_strlen:
    mov rax, 0          ; Initialize the counter to 0
.loop:
    cmp byte [rdi + rax], 0 ; Compare current byte with null terminator
    je .end             ; If null terminator, end loop
    inc rax             ; Otherwise, increment the counter
    jmp .loop           ; Repeat the loop
.end:
    ret                 ; Return the length (stored in RAX)
