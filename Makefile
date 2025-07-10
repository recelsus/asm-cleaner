NAME := asm-cleaner
SRC := src/main.asm
OUT := bin/$(NAME)

NASM := nasm
NASMFLAGS := -f elf64 -I src/

LD := ld
LDFLAGS :=

.PHONY: all clean install uninstall

all:
	mkdir -p bin
	$(NASM) $(NASMFLAGS) -o main.o $(SRC)
	$(LD) main.o -o $(OUT)

clean:
	rm -f *.o $(OUT)

install:
	@mkdir -p ~/.local/bin
	cp $(OUT) ~/.local/bin/
	chmod +x ~/.local/bin/$(NAME)
	@echo "Installed to ~/.local/bin/$(NAME)"

uninstall:
	rm -f ~/.local/bin/$(NAME)

