global ft_write
section .text

ft_write:
    mov rax, 1          ; System call number for write (1)
    mov rdi, rdi        ; File descriptor (first argument)
    mov rsi, rsi        ; Buffer (second argument)
    mov rdx, rdx        ; Number of bytes to write (third argument)
    syscall             ; Invoke system call
    cmp rax, 0          ; Check if syscall was successful
    js .error           ; If there was an error (negative return), jump to error
    ret                 ; Return number of bytes written

.error:
    mov rdi, rax        ; Set errno to the return value (negative error code)
    call ___error       ; Get address of errno
    mov [rax], edi      ; Set errno
    ret                 ; Return with the error code