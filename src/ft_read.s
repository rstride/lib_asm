global ft_read
section .text

ft_read:
    mov rax, 0          ; System call number for read (0)
    mov rdi, rdi        ; File descriptor (first argument)
    mov rsi, rsi        ; Buffer (second argument)
    mov rdx, rdx        ; Number of bytes to read (third argument)
    syscall             ; Invoke system call
    cmp rax, 0          ; Check if syscall was successful
    js .error           ; If there was an error (negative return), jump to error
    ret                 ; Return number of bytes read

.error:
    mov rdi, rax        ; Set errno to the return value (negative error code)
    neg rdi             ; Negate the error code
    mov rax, 60         ; System call number for exit (60)
    syscall             ; Exit the program with the error code
    ret
