section .text
    global _ft_strlen

_ft_strlen:
    ; RDI will contain the address of the string
    xor rax, rax  ; Clear RAX register to store the length

.loop:
    ; Load a byte from the string into AL (lower 8 bits of RAX)
    mov al, byte [rdi + rax]
    
    ; Test if AL is zero (end of string)
    test al, al
    jz .found  ; If zero, jump to the found label

    ; Otherwise, increment RAX (length)
    inc rax
    jmp .loop  ; Jump back to the loop

.found:
    ; RAX already contains the length
    ret
