NAME = libasm.a
FLAGS = -Wall -Wextra -Werror
SRC = ./src/ft_strlen.s ./src/ft_strcpy.s ./src/ft_strcmp.s ./src/ft_write.s ./src/ft_read.s ./src/ft_strdup.s
BONUS = ./src_bonus/ft_list_size.s ./src_bonus/ft_list_push_front.s ./src_bonus/ft_atoi_base.s ./src_bonus/ft_list_sort.s ./src_bonus/ft_list_remove_if.s
OBJ = $(SRC:%.s=%.o)
OBJ_BONUS = $(BONUS:%.s=%.o)
CC = clang

%.o: %.s
	@nasm -f elf64 $< -o $@ 
	@echo "\033[90m[\033[32mOK\033[90m]\033[33m Compiling $<\033[0m"

all: $(NAME)

$(NAME): $(OBJ)
	@ar -rc $(NAME) $(OBJ)
	@ranlib $(NAME)  # Ensure ranlib is applied to create the index
	@echo "\033[90m[\033[32mSuccess\033[90m]\033[32m Successfully compiled libasm.a .\033[0m"

bonus: all $(OBJ_BONUS)
	@ar -rc $(NAME) $(OBJ_BONUS)
	@ranlib $(NAME)  # Apply ranlib after the bonus compilation
	@echo "\033[90m[\033[32mSuccess\033[90m]\033[32m Successfully compiled libasm.a with bonus.\033[0m"

test: bonus
	@$(CC) main.c $(NAME) $(FLAGS)
	@echo "\033[90m[\033[32mSuccess\033[90m]\033[32m Successfully compiled test's .\033[0m"

clean:
	@$(RM) $(OBJ) $(OBJ_BONUS)
	@echo "\033[90m[\033[91mDeleting\033[90m]\033[31m Object files deleted\033[0m"

fclean: clean
	@$(RM) $(NAME) a.out
	@echo "\033[90m[\033[91mDeleting\033[90m]\033[31m libasm.a deleted.\033[0m"
	@echo "\033[90m[\033[91mDeleting\033[90m]\033[31m test deleted.\033[0m"

re: fclean bonus test

.PHONY: all test clean fclean re bonus
