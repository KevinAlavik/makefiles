SRC_DIR := src
BIN_DIR := bin

EXEC_NAME := main

SRCS := $(shell find $(SRC_DIR) -type f -name '*.d')
OBJS := $(patsubst $(SRC_DIR)/%.d,$(BIN_DIR)/%.o,$(SRCS))

DC := @gdc
DFLAGS := -w

LDFLAGS :=

LOGGER = @echo "[$(notdir $<)]"

all: $(BIN_DIR)/$(EXEC_NAME)

$(BIN_DIR)/$(EXEC_NAME): $(OBJS)
	$(LOGGER) Linking...
	@mkdir -p $(BIN_DIR)
	$(DC) $(LDFLAGS) -of=$@ $^
	@echo "done."

$(BIN_DIR)/%.o: $(SRC_DIR)/%.d
	$(LOGGER) Compiling...
	@mkdir -p $(@D)
	$(DC) $(DFLAGS) -c -of=$@ $<
	@echo "done."

start:
	@echo "$(EXEC_NAME) Build"

clean:
	rm -rf $(BIN_DIR)

.PHONY: all start clean install

install:
	@sudo ln -fs $(shell realpath $(BIN_DIR)/$(EXEC_NAME)) /usr/local/bin/$(EXEC_NAME)
	@echo "Installed $(EXEC_NAME) to PATH"
