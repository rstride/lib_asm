; int ft_strcmp(const char *s1, const char *s2)
;	*s1			->	rdi
;	*s2			->	rsi
;	return val	->	rax

global ft_strcmp

section .text
ft_strcmp:
	mov bl, byte [rdi]	; Load byte from address in rdi into bl
	mov cl, byte [rsi]	; Load byte from address in rsi into cl
	cmp bl, cl			; Compare the bytes in bl and cl
	jne return			; If they are not equal, jump to return
	cmp bl, 0			; Compare the byte in bl with 0
	je return			; If it is 0, jump to return
	cmp cl, 0			; Compare the byte in cl with 0
	je return			; If it is 0, jump to return
	inc rdi				; Increment rdi to point to the next byte
	inc rsi				; Increment rsi to point to the next byte
	jmp ft_strcmp		; Repeat the comparison
return:
	movzx rax, bl		; Zero-extend bl into rax
	movzx rbx, cl		; Zero-extend cl into rbx
	sub rax, rbx		; Subtract rbx from rax (result = *s1 - *s2)
	ret					; Return the result in rax

section .note.GNU-stack noalloc noexec nowrite progbits
