CC       = gcc
CFLAGS   = -std=c89 -O2 -Wall -Wextra -pedantic
LDFLAGS  =
TARGET   = korenvliet
SRC      = src/korenvliet.c

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(TARGET)

.PHONY: clean
