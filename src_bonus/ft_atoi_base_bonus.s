; int ft_atoi_base(char *str, char *base);
;	*str		->	rdi
;	*base		->	rsi
;	return val	->	rax

%macro check_forbidden 1
	cmp byte [%1], '+'					; if base[i] == '+'
	je error							; jump to error
	cmp byte [%1], '-'					; if base[i] == '-'
	je error							; jump to error
	cmp byte [%1], 9					; if base[i] == '\t'
	je error							; jump to error
	cmp byte [%1], 10					; if base[i] == '\n'
	je error							; jump to error
	cmp byte [%1], 11					; if base[i] == '\v'
	je error							; jump to error
	cmp byte [%1], 12					; if base[i] == '\f'
	je error							; jump to error
	cmp byte [%1], 13					; if base[i] == '\r'
	je error							; jump to error
	cmp byte [%1], ' '					; if base[i] == ' '
	je error							; jump to error
%endmacro

%macro check_sp 1
	cmp byte [%1], 9					; if str[i] == '\t'
	je inc_spaces						; jump to inc_spaces
	cmp byte [%1], 10					; if str[i] == '\n'
	je inc_spaces						; jump to inc_spaces
	cmp byte [%1], 11					; if str[i] == '\v'
	je inc_spaces						; jump to inc_spaces
	cmp byte [%1], 12					; if str[i] == '\f'
	je inc_spaces						; jump to inc_spaces
	cmp byte [%1], 13					; if str[i] == '\r'
	je inc_spaces						; jump to inc_spaces
	cmp byte [%1], ' '					; if str[i] == ' '
	je inc_spaces						; jump to inc_spaces
%endmacro

%macro check_pl_min 1
	cmp byte[%1], '+'					; if str[i] == '+'
	je inc_plus							; jump to inc_plus
	cmp byte[%1], '-'					; if str[i] == '-'
	je inc_min							; jump to inc_min
%endmacro

global ft_atoi_base
extern ft_strlen

section .text
ft_atoi_base:
	xor r9, r9							; r9 = 0 (counter for '-')
check_spaces:
	check_sp rdi						; check for spaces in str
	jmp check_plus_minus				; jump to check_plus_minus
inc_spaces:
	inc rdi								; str++
	jmp check_spaces					; jump to check_spaces
check_plus_minus:
	check_pl_min rdi					; check for '+' or '-' in str
	jmp next							; jump to next
inc_plus:
	inc rdi								; str++
	jmp check_plus_minus				; jump to check_plus_minus
inc_min:
	inc rdi								; str++
	inc r9								; increment '-' counter
	jmp check_plus_minus				; jump to check_plus_minus
next:
	mov r10, rdi						; r10 = str
	mov rdi, rsi						; rdi = base
	call ft_strlen						; rax = strlen(base)
	cmp rax, 2							; if strlen(base) < 2
	jl error							; jump to error
	mov rbx, -1							; rbx = -1
	check_forbidden rdi					; check forbidden characters in base
check_char:
	inc rbx								; rbx++
	cmp byte [rdi + rbx], 0				; if base[rbx] == 0
	je convert							; jump to convert
	mov r8b, byte [rdi + rbx]			; r8b = base[rbx]
	mov rcx, rbx						; rcx = rbx
char_loop:								; check for duplicates
	inc rcx								; rcx++
	cmp byte [rdi + rcx], 0				; if base[rcx] == 0
	je check_char						; jump to check_char
	cmp r8b, byte [rdi + rcx]			; if base[rbx] == base[rcx]
	je error							; jump to error
	check_forbidden rdi + rcx			; check forbidden characters in base
	jmp char_loop						; jump to char_loop
convert:
	xor rbx, rbx						; rbx = 0 (index for str)
	xor rcx, rcx						; rcx = 0 (index for base)
	mov r11, rax						; r11 = strlen(base)
	xor rax, rax						; rax = 0 (result)
	mov r8b, byte [r10 + rbx]			; r8b = str[rbx]
loop_base:
	cmp r8b, byte [rdi + rcx]			; if str[rbx] == base[rcx]
	je add								; jump to add
	inc rcx								; rcx++
	cmp byte [rdi + rcx], 0				; if base[rcx] == 0
	je end								; jump to end
	jmp loop_base						; jump to loop_base
add:
	mul r11								; rax *= strlen(base)
	add rax, rcx						; rax += rcx
	xor rcx, rcx						; rcx = 0
	inc rbx								; rbx++
	cmp byte [r10 + rbx], 0				; if str[rbx] == 0
	je end								; jump to end
	mov r8b, byte [r10 + rbx]			; r8b = str[rbx]
	jmp loop_base						; jump to loop_base
end:
	test r9b, 1							; if r9 (number of '-') is odd
	jz return							; jump to return
	neg rax								; negate rax
return:
	ret									; return rax
error:
	mov rax, 0							; return 0
	ret

section .note.GNU-stack noalloc noexec nowrite progbits
