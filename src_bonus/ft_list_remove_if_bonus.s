; void ft_list_remove_if(t_list **begin_list, void *data_ref, int(*cmp)(), void (*free_fct)(void *));
;	**begin_list				->	rdi
;	*data_ref					->	rsi
;	int (*cmp)()				->	rdx
;	void (*free_fct)(void *)	->	rcx

;	typedef struct s_list {
;		void			*data;
;		struct s_list	*next;
;	}	t_list;

;	sizeof(void*)	= 8
;	sizeof(t_list*)	= 8
;	sizeof(t_list)	= 16

; (*cmp)(list_ptr->data, data_ref);
;	list_ptr->data	-> rdi
;	data_ref		-> rsi
;	return val		-> rax

; (*free_fct)(list_ptr->data);
;	list_ptr->data	-> rdi

; read this :
; https://www.isabekov.pro/stack-alignment-when-mixing-asm-and-c-code/

global ft_list_remove_if
extern free

%macro SAVE_ARGS 0
	push rdi				; Save **begin_list
	push rsi				; Save *data_ref
	push rdx				; Save (*cmp)()
	push rcx				; Save (*free_fct)(void *)
%endmacro

%macro SAVE_VARS 0
	push r8					; Save r8
	push r9					; Save r9
	sub rsp, 8				; Align stack
%endmacro

%macro GET_VARS 0
	add rsp, 8				; Remove alignment
	pop r9					; Restore r9
	pop r8					; Restore r8
%endmacro

%macro EMPTY_STACK 0
	pop rcx				; Restore rcx
	pop rdx				; Restore rdx
	pop rsi				; Restore rsi
	pop rdi				; Restore rdi
%endmacro

section .text
ft_list_remove_if:
	SAVE_ARGS
	cmp [rsp + 24], word 0	; Check if **begin_list is NULL
	je return				; If NULL, return
	cmp [rsp + 8], word 0	; Check if (*cmp)() is NULL
	je return				; If NULL, return
	cmp [rsp], word 0		; Check if (*free_fct)(void *) is NULL
	je return				; If NULL, return
	mov r8, [rdi]			; r8 = *begin_list
	mov r9, 0				; r9 = NULL (prev)
loop:
	cmp r8, 0				; Check if *list is NULL
	je return				; If NULL, return	
	mov rdi, [r8]			; rdi = list->data
	mov rsi, [rsp + 16]		; rsi = data_ref
	SAVE_VARS
	call [rsp + 32]			; Call cmp(list->data, data_ref)
	GET_VARS
	cmp rax, 0				; Check if list->data == data_ref
	je remove				; If equal, remove
	mov r9, r8				; r9 = prev
	mov r8, [r8 + 8]		; list = list->next
	jmp loop				; Repeat loop

remove:
	cmp r9, 0				; Check if prev is NULL
	je noPrev				; If NULL, handle no previous node
	mov r10, [r8 + 8]		; r10 = list->next
	mov [r9 + 8], r10		; prev->next = list->next
	jmp freeDataAndItem		; Free list item

noPrev:
	mov r10, [r8 + 8]		; r10 = list->next
	mov r11, [rsp + 24]		; r11 = **begin_list
	mov [r11], r10			; *begin_list = list->next
	jmp freeDataAndItem		; Free list item

freeDataAndItem:
	mov rdi, [r8]			; rdi = list->data
	SAVE_VARS
	call [rsp + 24]			; Call free_fct(list->data)
	GET_VARS
	mov rdi, r8				; rdi = list
	mov r8, [r8 + 8]		; r8 = list->next
	SAVE_VARS
	call free				; Call free(list)
	GET_VARS
	jmp loop				; Repeat loop

return:
	EMPTY_STACK
	ret

section .note.GNU-stack noalloc noexec nowrite progbits
