; int ft_list_size(t_list *begin_list)
;	*begin_lst	->	rdi
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
	xor rax, rax;			; rax = 0
loop:
	cmp rdi, 0				; if lst == null
	je return				; goto return
	inc rax					; rax++
	mov rdi, [rdi + 8]		; lst = lst->next
	jmp loop				; goto loop
return:
	ret						; return rax

section .note.GNU-stack noalloc noexec nowrite progbits
