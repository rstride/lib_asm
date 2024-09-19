; size_t ft_strlen(const *char s)
;	*s			->	rdi
;	return val	->	rax

global ft_strlen

section .text
ft_strlen:
	xor rax, rax			; rax = 0
loop:
	cmp byte [rdi + rax], 0	; compare *rdi with 0
	je return				; if *rdi == 0 goto return
	inc rax					; rax++
	jmp loop				; goto loop
return:
	ret						; return rax

section .note.GNU-stack noalloc noexec nowrite progbits
