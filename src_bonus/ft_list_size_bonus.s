; int ft_list_size(t_list *begin_list)
;	*begin_list	->	rdi
;	return val	->	rax

;	typedef struct s_list {
;		void			*data;
;		struct s_list	*next;
;	}	t_list;

;	sizeof(void*)	= 8
;	sizeof(t_list*)	= 8
;	sizeof(t_list)	= 16

global ft_list_size

section .text
ft_list_size:
	xor rax, rax            ; Initialize rax to 0 (list size counter)
loop:
	cmp rdi, 0              ; Check if the current node is NULL
	je return               ; If NULL, jump to return
	inc rax                 ; Increment the list size counter
	mov rdi, [rdi + 8]      ; Move to the next node (rdi = rdi->next)
	jmp loop                ; Repeat the loop
return:
	ret                     ; Return the list size (rax)

section .note.GNU-stack noalloc noexec nowrite progbits
