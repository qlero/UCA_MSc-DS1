#!/usr/bin/python

counter = 0
char_len = 0
while True:
    try:
        line = raw_input()
        line.strip()
        data = line.split("|")
    except EOFError:
        break
    counter += int(data[0])
    char_len += int(data[1])
print "number of lines: {}; number of characters: {}".format(counter,char_len)