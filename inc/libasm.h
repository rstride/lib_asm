#ifndef _LIBASM_H
#define _LIBASM_H

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

typedef struct s_list
{
    void *data;
    struct s_list *next;
} t_list;

size_t  ft_strlen(const char *str);
char    *ft_strcpy(char *dst, const char *src);
int     ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char    *ft_strdup(const char *s1);
int     ft_atoi_base(const char *str, int base);
void    ft_list_push_front(t_list **list, void *data);
int     ft_list_size(t_list *list);
void    ft_list_sort(t_list **list, int (*cmp)(void *, void *));
void    ft_list_remove_if(t_list **list, void *data_ref, int (*cmp)(), void (*del)());

#endif