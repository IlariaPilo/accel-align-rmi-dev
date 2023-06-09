# Compiler settings
CXX = g++
CXXFLAGS = -std=c++14 -Wall -Wextra -O3 -I./include

# TBB settings
TBB_INCLUDE = /usr/include/tbb
TBB_PATH = /usr/lib/x86_64-linux-gnu/libtbb.so
TBBFLAGS = -L$(TBB_PATH)/lib -ltbb

# Source file and binary file paths
SRC=$(wildcard src/*.cpp)
#OBJ=$(patsubst src/%.cpp, bin/%.o, $(SRC))
BIN=$(patsubst src/%.cpp, bin/%, $(SRC))

# Targets
all: bin $(BIN)

bin/%: src/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $< $(TBBFLAGS)

bin:
	mkdir -p bin
	@echo $(BIN)

clean:
	rm -rf bin

.PHONY: all clean
