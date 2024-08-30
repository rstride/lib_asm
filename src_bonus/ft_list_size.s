global ft_list_size
section .text

ft_list_size:
    ; Input: rdi = pointer to the list
    ; Output: rax = number of elements in the list

    xor rax, rax        ; Clear rax to count elements

.count_loop:
    cmp rdi, 0          ; Check if the list is empty (end of the list)
    je .done
    inc rax             ; Increment count
    mov rdi, [rdi + 8]  ; Move to the next element in the list
    jmp .count_loop     ; Repeat until the end of the list

.done:
    ret
