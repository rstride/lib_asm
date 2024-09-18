section .text
    global _ft_write

; ft_write (rdi, rsi, rdx)

_ft_write:
    mov rax, 1              ; system call number for sys_write
    syscall                 ; call to write function
    jc error                ; if (CF == 1) return (error)
    ret                     ; if (CF == 0) return (exit)

error:
    mov rax, -1             ; -1 => system call error
    ret
