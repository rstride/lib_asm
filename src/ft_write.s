; ssize_t ft_write(int fd, const void *buf, size_t count)
;	fd			->	rdi
;	*buf		->	rsi
;	count		->	rdx
;	return val	->	rax

global ft_write
extern __errno_location

section .text
ft_write:
	mov rax, 1				; rax = 1 (syscall sys_write)
	syscall
	cmp rax, 0				; if return of syscall < 0
	jl error				; goto error
	ret						; return syscall value
error:
	mov rbx, rax			; rbx = rax (errno)
	neg rbx					; negate errno
	call __errno_location	; rax = errno location
	mov [rax], rbx			; *rax = rbx (errno)
	mov rax, -1				; rax = -1
	ret						; return -1

section .note.GNU-stack noalloc noexec nowrite progbits
