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
	push rdi				; Save the input string pointer (s) onto the stack
	call ft_strlen			; Get the length of the string (len) and store it in rax
	inc rax					; Increment the length to account for the null terminator
	mov rdi, rax			; Set rdi to the length + 1
	call malloc				; Allocate memory of size (len + 1)
	cmp rax, 0				; Check if malloc returned NULL
	je error				; If malloc returned NULL, jump to error handling
	mov rdi, rax			; Set rdi to the allocated memory pointer
	pop rsi					; Restore the input string pointer (s) from the stack into rsi
	sub rsp, 8				; Align the stack
	call ft_strcpy			; Copy the string from rsi to rdi, rax will hold the destination pointer
	add rsp, 8				; Restore the stack alignment
	ret						; Return the duplicated string pointer (rax)
error:
	call __errno_location	; Get the address of errno
	mov [rax], byte 12		; Set errno to ENOMEM (12)
	mov rax, 0				; Set the return value to NULL
	ret						; Return NULL

section .note.GNU-stack noalloc noexec nowrite progbits
