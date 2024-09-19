; char *ft_strcpy(char *dst, const char *src)
;	*dst		->	rdi
;	*src		->	rsi
;	return val	->	rax

global ft_strcpy

section .text
ft_strcpy:
	push rdi			; Save the original destination pointer
loop:
	cmp byte [rsi], 0	; Compare the current byte of src with 0
	je return			; If it is 0 (end of string), jump to return
	mov cl, [rsi]		; Load the current byte of src into cl
	mov [rdi], cl		; Store the byte in the destination
	inc rdi				; Move to the next byte in the destination
	inc rsi				; Move to the next byte in the source
	jmp loop			; Repeat the loop
return:
	mov cl, 0			; Load 0 into cl (null terminator)
	mov [rdi], cl		; Store the null terminator in the destination
	pop rax				; Restore the original destination pointer into rax
	ret					; Return the destination pointer

section .note.GNU-stack noalloc noexec nowrite progbits
