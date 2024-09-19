; void ft_list_push_front(t_list **begin_list, void *data)
;	**begin_lst	->	rdi
;	*data		->	rsi
;	return val	->	rax

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
	cmp rdi, 0				; if **begin_lst == null
	je ret_null				; goto ret_null
	push rdi				; pushing **begin_list into stack
	push rsi				; pushing *data into stack
	mov rdi, 16				; rdi = 16 (sizeof(t_list))
	call malloc				; malloc(sizeof(t_list))
	cmp rax, 0				; if malloc = NULL
	je ret_null				; goto ret_null
	pop rsi					; rsi = *data
	pop rdi					; rdi = **begin_list
	mov [rax], rsi			; new->data = data
	mov rdx, [rdi]			; rdx = *begin_list
	mov [rax + 8], rdx		; new->next = *begin_list
	mov [rdi], rax			; *begin_list = new
	ret

ret_null:
	mov rax, 0				; rax = 0
	ret						; return rax (0)

section .note.GNU-stack noalloc noexec nowrite progbits