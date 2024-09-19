; int *ft_strcmp(const char *s1, const *char s2)
;	*s1			->	rdi
;	*s2			->	rsi
;	return val	->	rax

global ft_strcmp

section .text
ft_strcmp:
	mov bl, byte [rdi]	; bl = *rdi
	mov cl, byte [rsi]	; cl = *rsi
	cmp bl, cl			; compare bl and cl (*rdi and *rsi)
	jne return			; if *rdi != *rsi goto return
	cmp bl, 0			; compare *rdi with 0
	je return			; if *rdi == 0 goto return
	cmp cl, 0			; compare *rsi with 0
	je return			; if *rsi == 0 goto return
	inc rdi				; rdi++
	inc rsi				; rsi++
	jmp ft_strcmp		; goto ft_strcmp
return:
	movzx rax, bl		; rax = bl (with extended zero)
	movzx rbx, cl		; rbx = cl (with extended zero)
	sub rax, rbx		; rax = rax - rbx (rax = *rdi - *rsi)
	ret					; return rax

section .note.GNU-stack noalloc noexec nowrite progbits
