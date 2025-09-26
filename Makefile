NAME := asm-cleaner
SRC := src/main.asm
OBJDIR := build
OUT := $(OBJDIR)/$(NAME)
OBJ := $(OBJDIR)/main.o

NASM := nasm
NASMFLAGS := -f elf64 -I src/

LD := ld
LDFLAGS :=

.PHONY: all clean install uninstall

all:
	mkdir -p $(OBJDIR)
	@command -v $(NASM) >/dev/null 2>&1 || { \
	  echo "Error: 'nasm' is not installed or not in PATH."; \
	  echo "See README.md for install instructions."; \
	  exit 127; \
	}
	@command -v $(LD) >/dev/null 2>&1 || { \
	  echo "Error: linker 'ld' is not installed or not in PATH (install binutils)."; \
	  exit 127; \
	}
	$(NASM) $(NASMFLAGS) -o $(OBJ) $(SRC)
	$(LD) $(OBJ) -o $(OUT)

clean:
	rm -f $(OBJ) $(OUT)

install:
	@mkdir -p ~/.local/bin
	cp $(OUT) ~/.local/bin/
	chmod +x ~/.local/bin/$(NAME)
	@echo "Installed to ~/.local/bin/$(NAME)"

uninstall:
	rm -f ~/.local/bin/$(NAME)
