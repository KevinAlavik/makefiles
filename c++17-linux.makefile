SRC_DIR := src
BIN_DIR := bin

EXEC_NAME := main

SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BIN_DIR)/%.o,$(SRCS))

CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra

LDFLAGS := 

LOGGER = @echo "[$(notdir $<)]"

all: $(BIN_DIR)/$(EXEC_NAME)

$(BIN_DIR)/$(EXEC_NAME): $(OBJS)
	$(LOGGER) Linking...
	@mkdir -p $(BIN_DIR)
	$(CXX) -o $@ $^ $(LDFLAGS)
	@echo "done."

$(BIN_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(LOGGER) Compiling...
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
	@echo "done."

.PHONY: all clean test

clean:
	rm -rf $(BIN_DIR)

test: $(BIN_DIR)/$(EXEC_NAME)
	@echo "Running test..."
	@./$(BIN_DIR)/$(EXEC_NAME)
	@echo "done."

install: $(BIN_DIR)/$(EXEC_NAME)
	@sudo ln -fs $(shell realpath $(BIN_DIR)/$(EXEC_NAME)) /usr/local/bin/$(EXEC_NAME)
	@echo "done."
