global ft_strcmp
section .text

ft_strcmp:
.loop:
    mov al, [rdi]       ; Load byte from string1
    mov bl, [rsi]       ; Load byte from string2
    cmp al, bl          ; Compare the two bytes
    jne .not_equal      ; If not equal, jump to not equal
    test al, al         ; Check if the end of the string is reached
    je .equal           ; If equal and end of string, return 0
    inc rdi             ; Move to next byte in string1
    inc rsi             ; Move to next byte in string2
    jmp .loop           ; Repeat loop
.not_equal:
    sub eax, ebx        ; Return the difference between the two bytes
    ret
.equal:
    xor eax, eax        ; If equal, return 0
    ret
