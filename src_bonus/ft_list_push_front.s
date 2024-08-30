global ft_list_push_front
section .text

ft_list_push_front:
    ; Input: rdi = pointer to the list, rsi = new element
    ; Output: None

    mov rdx, [rdi]      ; Load the original first element
    mov [rsi + 8], rdx  ; Set the next of the new element to the original first element
    mov [rdi], rsi      ; Set the new element as the first element in the list
    ret
