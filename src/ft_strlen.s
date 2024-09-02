section .text
global ft_strlen

ft_strlen:
    ; Initialize counter to 0
    xor rax, rax 

    ; Loop through the string until null byte is found
.loop:
    cmp byte [rdi + rax], 0 ; Compare current byte with 0
    je .end                 ; Jump to end if null byte is found
    inc rax                  ; Increment counter
    jmp .loop                ; Continue looping

.end:
    ret                      ; Return the length in rax