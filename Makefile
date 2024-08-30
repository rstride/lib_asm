NAME = libasm.a

SRC = src/ft_strlen.s src/ft_strcpy.s src/ft_strcmp.s src/ft_write.s src/ft_read.s src/ft_strdup.s
BONUS_SRC = src_bonus/ft_atoi_base.s src_bonus/ft_list_push_front.s src_bonus/ft_list_size.s src_bonus/ft_list_sort.s src_bonus/ft_list_remove_if.s

OBJ = $(SRC:.s=.o)
BONUS_OBJ = $(BONUS_SRC:.s=.o)

NASM = nasm
NASMFLAGS = -f elf64

CC = gcc
CFLAGS = -Wall -Wextra -Werror

all: $(NAME)

$(NAME): $(OBJ)
	ar rcs $(NAME) $(OBJ)

bonus: $(BONUS_OBJ)
	ar rcs $(NAME) $(BONUS_OBJ)

%.o: %.s
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME) a.out

re: fclean all

test: all
	$(CC) $(CFLAGS) main.c $(NAME) -o test_program

test_bonus: bonus
	$(CC) $(CFLAGS) main_bonus.c $(NAME) -o test_program_bonus

.PHONY: all clean fclean re test test_bonus