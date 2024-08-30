global ft_atoi_base
section .text

ft_atoi_base:
    ; Implementation to convert a string to an integer with a specified base
    ; Assumes the base is valid and the input string is correctly formatted
    ; Input: rdi = string, rsi = base
    ; Output: rax = integer value

    xor rax, rax        ; Clear rax to store the result
    xor rcx, rcx        ; Clear rcx to store sign (-1 for negative, 1 for positive)

    mov rcx, 1          ; Assume positive number by default

.skip_spaces:
    cmp byte [rdi], ' ' ; Skip leading spaces
    je .skip_spaces_continue
    jmp .check_sign

.skip_spaces_continue:
    inc rdi
    jmp .skip_spaces

.check_sign:
    cmp byte [rdi], '-'
    jne .check_sign_plus
    mov rcx, -1         ; Set sign to negative
    inc rdi             ; Move to next character
    jmp .convert

.check_sign_plus:
    cmp byte [rdi], '+'
    jne .convert
    inc rdi             ; Move to next character

.convert:
    mov rdx, rsi        ; Copy base to rdx
    xor rbx, rbx        ; Clear rbx (holds current digit value)
    
.get_digit:
    mov bl, [rdi]       ; Get the current character
    sub bl, '0'         ; Convert character to digit
    cmp bl, 9
    jbe .digit_valid
    sub bl, 7           ; Adjust for hexadecimal digits 'A'-'F'
    cmp bl, 9
    jbe .digit_valid
    sub bl, 32          ; Adjust for lowercase hexadecimal digits 'a'-'f'
    cmp bl, 15
    jae .end_convert

.digit_valid:
    imul rax, rdx       ; Multiply current result by the base
    add rax, rbx        ; Add the digit value
    inc rdi             ; Move to the next character
    jmp .get_digit      ; Repeat conversion

.end_convert:
    imul rax, rcx       ; Apply sign to the result
    ret
