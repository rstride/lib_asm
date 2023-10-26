# Name of the library and executable
LIB_NAME = libasm.a
EXE_NAME = main

# Compiler and flags
CC = gcc
NASM = nasm
NASM_FLAGS = -f macho64
CFLAGS = -Wall -Wextra -Werror

# Source and object files
ASM_SRC = ft_strlen.s
ASM_OBJ = $(ASM_SRC:.s=.o)
C_SRC = main.c
C_OBJ = $(C_SRC:.c=.o)

# Default rule
all: $(LIB_NAME) $(EXE_NAME)

# Rule to compile assembly files
%.o: %.s
	$(NASM) $(NASM_FLAGS) $<

# Rule to compile C files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to create the library
$(LIB_NAME): $(ASM_OBJ)
	ar rcs $(LIB_NAME) $(ASM_OBJ)

# Rule to create the executable
$(EXE_NAME): $(C_OBJ) $(LIB_NAME)
	$(CC) $(CFLAGS) $(C_OBJ) -L. -lasm -o $(EXE_NAME)

# Rule to clean object files
clean:
	rm -f $(ASM_OBJ) $(C_OBJ)

# Rule to clean everything
fclean: clean
	rm -f $(LIB_NAME) $(EXE_NAME)

# Rule to recompile
re: fclean all
