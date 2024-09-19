_BLACK = \033[0;30m
_RED = \033[0;31m
_GREEN = \033[0;32m
_BLUE = \033[0;34m
_YELLOW = \033[0;33m
_PURPLE = \033[0;35m
_CYAN = \033[0;36m
_WHITE = \033[0;37m
_END = \033[0m

NAME = libasm.a
NAME_BONUS = libasm_bonus.a
ASM = nasm
CC = cc

INCLUDES = inc

CFLAGS = -f elf64

SRC_DIR = src/
SRC_BONUS_DIR = src_bonus/
OBJ_DIR = obj/
OBJ_BONUS_DIR = obj_bonus/

SRC = ft_strlen ft_strcpy ft_strcmp ft_write ft_read ft_strdup
BONUS = ft_atoi_base_bonus ft_list_push_front_bonus ft_list_size_bonus \
		ft_list_sort_bonus ft_list_remove_if_bonus

SRC_FILES = $(addprefix $(SRC_DIR), $(addsuffix .s, $(SRC)))
BONUS_FILES = $(addprefix $(SRC_DIR), $(addsuffix .s, $(SRC))) \
			  $(addprefix $(SRC_BONUS_DIR), $(addsuffix .s, $(BONUS)))

OBJ_FILES = $(addprefix $(OBJ_DIR), $(addsuffix .o, $(SRC)))
OBJ_BONUS_FILES = $(addprefix $(OBJ_DIR), $(addsuffix .o, $(SRC))) \
				  $(addprefix $(OBJ_BONUS_DIR), $(addsuffix .o, $(BONUS)))

.PHONY : all clean fclean re bonus

$(OBJ_DIR)%.o : $(SRC_DIR)%.s
	@mkdir -p $(@D)
	@printf "\e[?25l"
	@printf "$(_YELLOW)Compiling $(NAME) binary file: $@$(_END)\n"
	@$(ASM) $(CFLAGS) $< -o $@

$(NAME) : $(OBJ_FILES)
	@ar rc $(NAME) $(OBJ_FILES)
	@echo "$(_GREEN)Libasm created.$(_END)"
	@printf "\e[?25h"

all : $(NAME)

bonus : $(NAME_BONUS)

$(OBJ_BONUS_DIR)%.o : $(SRC_BONUS_DIR)%.s
	@mkdir -p $(@D)
	@printf "\e[?25l"
	@printf "$(_YELLOW)Compiling $(NAME_BONUS) binary file: $@$(_END)\n"
	@$(ASM) $(CFLAGS) $< -o $@

$(NAME_BONUS) : $(OBJ_BONUS_FILES)
	@ar rc $(NAME_BONUS) $(OBJ_BONUS_FILES)
	@echo "$(_GREEN)Libasm created.$(_END)"
	@printf "\e[?25h"

clean :
	@echo "$(_YELLOW)$(NAME): Clean...$(_END)"
	@$(RM) -rf $(OBJ_DIR)
	@echo "$(_GREEN)$(NAME): Binaries deleted.$(_END)"

fclean :
	@echo "$(_YELLOW)$(NAME): Full clean...$(_END)"
	@$(RM) -rf $(OBJ_DIR)
	@echo "$(_GREEN)$(NAME): Binaries deleted.$(_END)"
	@$(RM) $(NAME) $(NAME_BONUS) test test_bonus
	@echo "$(_GREEN)$(NAME) deleted.$(_END)"

re : 
	@make fclean --no-print-directory
	@make all --no-print-directory
	@printf "\e[?25h"

_test :
	@make all --no-print-directory
	@$(CC) -o test tester/tester.c libasm.a -I$(INCLUDES) -no-pie
	@echo "$(_GREEN)Tester test created.$(_END)"

_test_bonus :
	@make bonus --no-print-directory
	@$(CC) -o test_bonus tester/tester_bonus.c libasm_bonus.a -I$(INCLUDES) -no-pie
	@echo "$(_GREEN)Tester test_bonus created.$(_END)"
