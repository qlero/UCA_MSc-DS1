#!/usr/bin/python

counter = 0
while True:
    try:
        line = input()
    except EOFError:
        break
    counter += int(line)
print(counter)
