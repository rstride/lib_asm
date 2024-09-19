; ssize_t ft_read(int fd, void *buf, size_t count)
;	fd			->	rdi		; File descriptor
;	*buf		->	rsi		; Buffer to read into
;	count		->	rdx		; Number of bytes to read
;	return val	->	rax		; Return value

global ft_read
extern __errno_location

section .text
ft_read:
	mov rax, 0				; Set rax to 0 (syscall number for sys_read)
	syscall					; Invoke the system call
	cmp rax, 0				; Compare return value with 0
	jl error				; Jump to error if return value is less than 0
	ret						; Return the syscall value if no error
error:
	mov rbx, rax			; Move the error code to rbx
	neg rbx					; Negate the error code
	call __errno_location	; Get the address of errno
	mov [rax], rbx			; Store the negated error code in errno
	mov rax, -1				; Set return value to -1
	ret						; Return -1 to indicate error

section .note.GNU-stack noalloc noexec nowrite progbits
