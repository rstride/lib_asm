#include "libasm.h"

// Prototypes of the assembly functions


int test_function() {
    // Test ft_strlen
    char *str = "Hello, World!";
    printf("ft_strlen: %zu\n", ft_strlen(str));

    // Test ft_strcpy
    char buffer[50];
    printf("ft_strcpy: %s\n", ft_strcpy(buffer, str));

    // Test ft_strcmp
    printf("ft_strcmp (equal): %d\n", ft_strcmp(str, "Hello, World!"));
    printf("ft_strcmp (not equal): %d\n", ft_strcmp(str, "Hello"));

    // Test ft_write
    char *msg = "Writing to stdout using ft_write\n";
    ft_write(1, msg, ft_strlen(msg));

    // Test ft_read
    char read_buf[50];
    ssize_t bytes_read = ft_read(0, read_buf, 10);
    if (bytes_read > 0) {
        read_buf[bytes_read] = '\0'; // Null-terminate the string
        printf("ft_read: %s\n", read_buf);
    } else {
        perror("ft_read");
    }

    // Test ft_strdup
    char *dup_str = ft_strdup(str);
    if (dup_str) {
        printf("ft_strdup: %s\n", dup_str);
        free(dup_str); // Remember to free the allocated memory
    } else {
        perror("ft_strdup");
    }

    return 0;
}

int test_bonus()
{
        // Test ft_atoi_base
    printf("ft_atoi_base: %d\n", ft_atoi_base("42", 10));  // Should print 42
    printf("ft_atoi_base: %d\n", ft_atoi_base("2A", 16));  // Should print 42
    printf("ft_atoi_base: %d\n", ft_atoi_base("-101010", 2));  // Should print -42

    // Create a list for testing
    t_list *list = NULL;
    
    // Test ft_list_push_front
    char *data1 = strdup("Hello");
    char *data2 = strdup("World");
    char *data3 = strdup("Libasm");

    ft_list_push_front(&list, data1);
    ft_list_push_front(&list, data2);
    ft_list_push_front(&list, data3);

    // Test ft_list_size
    printf("ft_list_size: %d\n", ft_list_size(list));  // Should print 3

    // Test ft_list_sort
    ft_list_sort(&list, cmp);
    t_list *tmp = list;
    while (tmp) {
        printf("ft_list_sort: %s\n", (char *)tmp->data);  // Should print sorted list: "Hello", "Libasm", "World"
        tmp = tmp->next;
    }

    // Test ft_list_remove_if
    char *ref = "Libasm";
    ft_list_remove_if(&list, ref, cmp, del);
    tmp = list;
    while (tmp) {
        printf("ft_list_remove_if: %s\n", (char *)tmp->data);  // Should print: "Hello", "World"
        tmp = tmp->next;
    }

    // Free remaining list elements
    while (list) {
        t_list *next = list->next;
        del(list->data);
        free(list);
        list = next;
    }

    return 0;
}

int main(int argc, char **argv) {
    if argv[1] == "bonus"
        test_bonus();
    else
        test_function();
    return 0;
}