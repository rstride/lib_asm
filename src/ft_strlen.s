; size_t ft_strlen(const char *s)
;	*s			->	rdi (input string)
;	return val	->	rax (length of the string)

global ft_strlen

section .text
ft_strlen:
	xor rax, rax            ; Initialize rax to 0 (string length counter)
loop:
	cmp byte [rdi + rax], 0 ; Compare current byte with 0 (null terminator)
	je return               ; If null terminator is found, jump to return
	inc rax                 ; Increment rax (string length counter)
	jmp loop                ; Repeat the loop
return:
	ret                     ; Return the length of the string in rax

section .note.GNU-stack noalloc noexec nowrite progbits
