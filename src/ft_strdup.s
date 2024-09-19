; char *ft_strdup(const char *s);
;	*s			->	rdi
;	return val	->	rax

global ft_strdup
extern ft_strlen
extern malloc
extern ft_strcpy
extern __errno_location

section .text
ft_strdup:
	push rdi				; save s into stack
	call ft_strlen			; rax = ft_strlen(*s) (len)
	inc rax					; rax++ (len++)
	mov rdi, rax			; rdi = len+1
	call malloc				; malloc (len+1) (for \0 at end of string)
	cmp rax, 0				; if (rax == 0 (NULL)) (rax is the return of malloc)
	je error				; goto error
	mov rdi, rax			; rdi = alloced ptr
	pop rsi					; rsi = s
	sub rsp, 8				; aligning stack
	call ft_strcpy			; rax = ft_strcpy(rdi, rsi) (ft_strcpy(ptr, s))
	add rsp, 8				; remove alignment
	ret						; return rax (ptr)
error:
	call __errno_location	; rax = errno location
	mov [rax], byte 12		; *rax = 12 (ENOMEM = 12)
	mov rax, 0				; rax = 0
	ret						; return rax (NULL)

section .note.GNU-stack noalloc noexec nowrite progbits
