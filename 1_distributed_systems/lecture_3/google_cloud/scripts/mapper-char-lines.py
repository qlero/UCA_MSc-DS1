#!/usr/bin/python

char_len = 0
counter = 0
while True:
    try:
        counter += 1
        inp = input()
        char_len += len(inp)
    except EOFError:
        break
print '{}|{}'.format(counter,char_len)