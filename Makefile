# Makefile for Vigenere Cipher Project

# Název výsledného spustitelného souboru
TARGET = vigenere_cipher

# Kompilátor a flagy
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

# Soubory
SRC = main.c
OBJ = $(SRC:.c=.o)

# Výchozí pravidlo
all: $(TARGET)

# Pravidlo pro kompilaci cíle
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

# Pravidlo pro vytvoření objektového souboru
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Pravidlo pro spuštění programu
run: $(TARGET)
	./$(TARGET)

# Pravidlo pro čištění
clean:
	rm -f $(OBJ) $(TARGET)

# Phony targets
.PHONY: all clean run