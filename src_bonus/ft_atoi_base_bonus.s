; int ft_atoi_base(char *str, char *base);
;	*str		->	rdi
;	*base		->	rsi
;	return val	-.	rax

%macro check_forbidden 1
	cmp byte [%1], '+'					; if *base == '+'
	je error							; goto error
	cmp byte [%1], '-'					; if *base == '-'
	je error							; goto error
	cmp byte [%1], 9					; if *base == '\t'
	je error							; goto error
	cmp byte [%1], 10					; if *base == '\n'
	je error							; goto error
	cmp byte [%1], 11					; if *base == '\v'
	je error							; goto error
	cmp byte [%1], 12					; if *base == '\f'
	je error							; goto error
	cmp byte [%1], 13					; if *base == '\r'
	je error							; goto error
	cmp byte [%1], ' '					; if *base == ' '
	je error							; goto error
%endmacro

%macro check_sp 1
	cmp byte [%1], 9					; if *str == '\t'
	je inc_spaces						; goto inc_str
	cmp byte [%1], 10					; if *str == '\n'
	je inc_spaces						; goto inc_str
	cmp byte [%1], 11					; if *str == '\v'
	je inc_spaces						; goto inc_str
	cmp byte [%1], 12					; if *str == '\f'
	je inc_spaces						; goto inc_str
	cmp byte [%1], 13					; if *str == '\r'
	je inc_spaces						; goto inc_str
	cmp byte [%1], ' '					; if *str == ' '
	je inc_spaces						; goto inc_str
%endmacro

%macro check_pl_min 1
	cmp byte[%1], '+'					; if *str == '+'
	je inc_plus							; goto inc_plus
	cmp byte[%1], '-'					; if *str == '-'
	je inc_min							; goto inc_min
%endmacro

global ft_atoi_base
extern ft_strlen

section .text
ft_atoi_base:
	xor r9, r9							; r9 = 0 (for counting nb of '-')
check_spaces:
	check_sp rdi						; check spaces of str
	jmp check_plus_minus				; goto check_plus_minus
inc_spaces:
	inc rdi								; str++
	jmp check_spaces					; goto check_spaces
check_plus_minus:
	check_pl_min rdi					; check plus minus of str
	jmp next							; goto next
inc_plus:
	inc rdi								; str++
	jmp check_plus_minus				; goto check_plus_minus
inc_min:
	inc rdi								; str++
	inc r9								; nb of '-' ++
	jmp check_plus_minus				; goto check_plus_minus
next:
	mov r10, rdi						; r10 = *str
	mov rdi, rsi						; rdi = *base (for ft_strlen)
	call ft_strlen						; rax = strlen(base)
	cmp rax, 2							; if (rax < 2)
	jl error							; goto error
	mov rbx, -1							; rbx = 0
	check_forbidden rdi					; check fornidden for base[0]
check_char:
	inc rbx								; rbx++
	cmp byte [rdi + rbx], 0				; if base[rbi] == 0
	je convert							; goto convert
	mov r8b, byte [rdi + rbx]			; r8b = base[rbx]
	mov rcx, rbx						; rcx = rbx
char_loop:								; checking duplicates...
	inc rcx								; rcx++
	cmp byte [rdi + rcx], 0				; if base[rcx] == 0
	je check_char						; goto check_char
	cmp r8b, byte [rdi + rcx]			; if base[rbx] == base[rcx]
	je error							; goto error
	check_forbidden rdi + rcx			; check forbidden for base[rcx]
	jmp char_loop						; goto char_loop
convert:
	xor rbx, rbx						; rbx = 0 (str[rbx])
	xor rcx, rcx						; rcx = 0 (base[rcx])
	mov r11, rax						; r11 = strlen(base)
	xor rax, rax						; rax = 0
	mov r8b, byte [r10 + rbx]			; r8b = str[rbx]
loop_base:
	cmp r8b, byte [rdi + rcx]			; if (str[rbx] == base[rcx])
	je add								; goto add
	inc rcx								; else rcx++
	cmp byte [rdi + rcx], 0				; if base[rcx] == 0
	je end								; goto error
	jmp loop_base						; else goto loop_base
add:
	mul r11								; result *= strlen(base)
	add rax, rcx						; result += rcx
	xor rcx, rcx						; rcx = 0
	inc rbx								; rbx++
	cmp byte [r10 + rbx], 0				; if str[rbx] == 0
	je end								; goto end
	mov r8b, byte [r10 + rbx]			; r8b = str[rbx]
	jmp loop_base						; goto loop_base
end:
	test r9b, 1							; if LSB of r9b (nb of '-') != 1 (if LSB == 1, nb of '-' is odd)
	jz return							; goto return
	neg rax								; else negate rax
return:
	ret									; return rax
error:
	mov rax, 0							; return 0
	ret

section .note.GNU-stack noalloc noexec nowrite progbits
