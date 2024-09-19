; char *ft_strcpy(char *dst, const *char src)
;	*dst		->	rdi
;	*src		->	rsi
;	return val	->	rax

global ft_strcpy

section .text
ft_strcpy:
	push rdi			; pushing rdi to the stack (to save the pointer address)
loop:
	cmp byte [rsi], 0	; compare *rsi with 0
	je return			; if *rsi == 0 goto return
	mov cl, [rsi]		; copying *rsi into cl
	mov [rdi], cl		; copying cl into *rdi
	inc rdi				; rdi++
	inc rsi				; rsi++
	jmp loop			; goto loop
return:
	mov cl, 0			; copying 0 into cl
	mov [rdi], cl		; copying cl into *rdi
	pop rax				; poping the stack into rax (stack = initial saved ptr)
	ret					; return rax

section .note.GNU-stack noalloc noexec nowrite progbits
