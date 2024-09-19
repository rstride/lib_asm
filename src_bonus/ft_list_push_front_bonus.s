; void ft_list_push_front(t_list **begin_list, void *data)
;	**begin_list	->	rdi
;	*data			->	rsi
;	return value	->	rax

;	typedef struct s_list {
;		void			*data;
;		struct s_list	*next;
;	}	t_list;

;	sizeof(void*)	= 8
;	sizeof(t_list*)	= 8
;	sizeof(t_list)	= 16

global ft_list_push_front
extern malloc

section .text
ft_list_push_front:
	cmp rdi, 0				; if **begin_list == NULL
	je ret_null				; jump to ret_null if NULL
	push rdi				; push **begin_list onto stack
	push rsi				; push *data onto stack
	mov rdi, 16				; rdi = 16 (sizeof(t_list))
	call malloc				; call malloc to allocate memory for t_list
	cmp rax, 0				; if malloc returned NULL
	je ret_null				; jump to ret_null if NULL
	pop rsi					; pop *data from stack into rsi
	pop rdi					; pop **begin_list from stack into rdi
	mov [rax], rsi			; new->data = data
	mov rdx, [rdi]			; rdx = *begin_list
	mov [rax + 8], rdx		; new->next = *begin_list
	mov [rdi], rax			; *begin_list = new
	ret

ret_null:
	mov rax, 0				; rax = 0
	ret						; return 0

section .note.GNU-stack noalloc noexec nowrite progbits