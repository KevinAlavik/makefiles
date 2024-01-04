# Color codes
GREEN := \033[1;32m
YELLOW := \033[1;33m
BLUE := \033[1;34m
MAGENTA := \033[1;35m
CYAN := \033[1;36m
CMD_COLOR := \e[4;33m
RESET := \033[0m

# Directories
SRC_DIR := src
BIN_DIR := bin
EXEC_NAME := main

SRCS := $(shell find $(SRC_DIR) -type f \( -name '*.c' -o -name '*.asm' \))
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%.o,$(filter %.c,$(SRCS)))
OBJS += $(patsubst $(SRC_DIR)/%.asm,$(BIN_DIR)/%.o,$(filter %.asm,$(SRCS)))

CC := gcc
AS := nasm
CFLAGS := -Wall -Wextra
LDFLAGS :=
ASMFLAGS := -f elf64  # Change this according to your assembly type (e.g., -f elf for 32-bit)

DATE := date
UNAME := uname
COMPILER_VERSION := $(shell $(CC) --version | head -n 1)
LINKER_VERSION := $(shell ld --version | head -n 1)
ASSEMBLER_VERSION := $(shell $(AS) -v | head -n 1)
BUILD_TIME := $(shell $(DATE) +%Y-%m-%d\ %H:%M:%S)
ARCHITECTURE := $(shell $(UNAME) -m)
OS := $(shell $(UNAME) -s)

info_section:
	@echo "$(MAGENTA)===== Information =====$(RESET)"
	@echo "$(YELLOW)Output Directory:$(RESET) $(BIN_DIR)"
	@echo "$(YELLOW)Compiler Version:$(RESET) $(COMPILER_VERSION)"
	@echo "$(YELLOW)Assembler Version:$(RESET) $(ASSEMBLER_VERSION)"
	@echo "$(YELLOW)Linker Version:$(RESET) $(LINKER_VERSION)"
	@echo "$(YELLOW)Built for:$(RESET) $(ARCHITECTURE) on $(OS)"
	@echo "$(YELLOW)Build Time:$(RESET) $(BUILD_TIME)"

all: info_section $(BIN_DIR)/$(EXEC_NAME)
	@echo "$(GREEN)Build completed.$(RESET)"

$(BIN_DIR)/$(EXEC_NAME): $(OBJS)
	@echo "$(MAGENTA)===== Linking $(EXEC_NAME) =====$(RESET)"
	@mkdir -p $(@D)
	@echo - "$(CMD_COLOR)$(CC) $(LDFLAGS) -o $@ $^$(RESET)"
	@$(CC) $(LDFLAGS) -o $@ $^
	@echo "$(CYAN)Executable generated at: $(BIN_DIR)/$(EXEC_NAME)$(RESET)"

$(BIN_DIR)/%.o: $(SRC_DIR)/%.c $(SRC_DIR)/%.h
	@echo "$(MAGENTA)===== Compiling $< =====$(RESET)"
	@mkdir -p $(@D)
	@echo - "$(CMD_COLOR)$(CC) $(CFLAGS) -c -o $@ $<$(RESET)"
	@$(CC) $(CFLAGS) -c -o $@ $<
	@echo "$(BLUE)$<$(RESET): $(RESET) done."

$(BIN_DIR)/%.o: $(SRC_DIR)/%.asm
	@echo "$(MAGENTA)===== Assembling $< =====$(RESET)"
	@mkdir -p $(@D)
	@echo - "$(CMD_COLOR)$(AS) $(ASMFLAGS) -o $@ $<$(RESET)"
	@$(AS) $(ASMFLAGS) -o $@ $<
	@echo  -"$(CMD_COLOR)$(BLUE)[$<]$(RESET) $(YELLOW)Assembled in $$(( $(shell date +%s) - $(shell stat -c %Y $<) )) seconds$(RESET) done."

clean:
	@rm -rf $(BIN_DIR)
	@echo "$(RED)Build artifacts removed.$(RESET)"

.PHONY: all clean
.DEFAULT_GOAL := all
