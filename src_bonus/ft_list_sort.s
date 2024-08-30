global ft_list_sort
section .text

ft_list_sort:
    ; Input: rdi = pointer to the list, rsi = comparison function
    ; Output: None
    ; This function will sort the linked list in place using bubble sort

    mov rdx, 0          ; Used to track if any swaps were made

.sort_loop:
    mov rax, [rdi]      ; rax points to the first element
    mov rbx, rax        ; rbx is used to traverse the list

.check_next:
    cmp [rbx + 8], 0    ; Check if next element is NULL
    je .sort_done
    mov rcx, [rbx + 8]  ; rcx points to the next element

    ; Call the comparison function
    mov rdi, rbx        ; First argument
    mov rsi, rcx        ; Second argument
    call [rsi]          ; Call the comparison function

    cmp rax, 0          ; If result > 0, we need to swap
    jle .skip_swap

    ; Swap elements
    mov rdx, [rcx + 8]  ; Load next->next
    mov [rbx + 8], rdx  ; Set b->next = next->next
    mov [rcx + 8], rbx  ; Set next->next = b
    mov rbx, rcx        ; Move to next element
    mov rdx, 1          ; Indicate a swap was made

.skip_swap:
    mov rbx, [rbx + 8]  ; Move to the next element in the list
    jmp .check_next     ; Continue checking

.sort_done:
    cmp rdx, 0          ; If a swap was made, repeat the sorting
    jne .sort_loop
    ret
