global ft_list_remove_if
section .text

ft_list_remove_if:
    ; Input: rdi = pointer to the list, rsi = data_ref, rdx = cmp function, rcx = del function
    ; Output: None

    mov rbx, [rdi]      ; rbx points to the current element
    mov rax, 0          ; rax will be used to store the previous element

.remove_loop:
    cmp rbx, 0          ; Check if we are at the end of the list
    je .done

    ; Call the comparison function
    mov rdi, [rbx + 0]  ; First argument (element data)
    mov rsi, rdx        ; Second argument (data_ref)
    call rcx            ; Call cmp function

    test rax, rax       ; Check the result of the comparison
    jne .skip_removal   ; If not equal, skip removal

    ; Remove element
    mov rcx, [rbx + 8]  ; Save the next element
    cmp rax, 0          ; If no previous, we're removing the first element
    je .remove_first
    mov [rax + 8], rcx  ; Link previous element to next

.remove_first:
    mov [rdi], rcx      ; Update the list head
    ; Call the delete function
    mov rdi, [rbx]      ; Pass the data pointer to the del function
    call rdx
    jmp .next

.skip_removal:
    mov rax, rbx        ; Save current element as previous
.next:
    mov rbx, [rbx + 8]  ; Move to the next element in the list
    jmp .remove_loop

.done:
    ret
