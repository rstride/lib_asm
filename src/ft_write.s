; ssize_t ft_write(int fd, const void *buf, size_t count)
;	fd			->	rdi		; File descriptor
;	*buf		->	rsi		; Buffer to write
;	count		->	rdx		; Number of bytes to write
;	return val	->	rax		; Return value

global ft_write
extern __errno_location

section .text
ft_write:
	mov rax, 1				; Set rax to 1 (syscall number for sys_write)
	syscall					; Invoke the system call
	cmp rax, 0				; Compare return value with 0
	jl error				; Jump to error if return value is less than 0
	ret						; Return the syscall value

error:
	mov rbx, rax			; Move return value to rbx (store errno)
	neg rbx					; Negate the errno value
	call __errno_location	; Get the address of errno
	mov [rax], rbx			; Store the negated errno at the errno location
	mov rax, -1				; Set return value to -1
	ret						; Return -1

section .note.GNU-stack noalloc noexec nowrite progbits
