global ft_strdup
extern malloc
section .text

ft_strdup:
    mov rdi, rsi        ; Save source string in RDI
    call ft_strlen      ; Get the length of the source string
    inc rax             ; Add space for null terminator
    mov rdi, rax        ; Set the size for malloc
    call malloc         ; Allocate memory
    test rax, rax       ; Check if malloc was successful
    je .error           ; If malloc failed, jump to error
    mov rdi, rax        ; Set the destination pointer (return value)
    mov rsi, rsi        ; Set the source pointer
    call ft_strcpy      ; Copy the string
    ret                 ; Return the pointer to the duplicated string

.error:
    mov rdi, -1         ; Set return value to -1 for error
    call ___error       ; Get address of errno
    mov [rax], edi      ; Set errno
    ret                 ; Return null on failure
