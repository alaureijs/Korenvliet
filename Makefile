CC       = gcc
CFLAGS   = -std=gnu99 -O2 -Wall -Wextra -pedantic -Werror -Wconversion -Wshadow -Wfloat-equal -fanalyzer -fsanitize=undefined
LDFLAGS  =
TARGET   = korenvliet
SRC      = src/korenvliet.c

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

PRG      = korenvliet.prg
BAS_SRC  = src/korenvliet.bas

$(PRG): $(BAS_SRC)
	petcat -w2 -o $@ -- $^

prg: $(PRG)

clean:
	rm -f $(TARGET) $(PRG)

.PHONY: clean prg
