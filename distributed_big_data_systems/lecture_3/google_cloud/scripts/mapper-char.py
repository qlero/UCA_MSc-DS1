#!/usr/bin/python

counter = 0
while True:
    try:
        inp = input()
        counter += len(inp)
    except EOFError:
        break
print(counter)