CC       = gcc
CFLAGS   = -std=c89 -O2 -Wall -Wextra -pedantic -Werror -Wconversion -Wshadow -Wfloat-equal -fanalyzer -fsanitize=undefined
LDFLAGS  =
TARGET   = korenvliet
SRC      = src/korenvliet.c

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(TARGET)

.PHONY: clean
