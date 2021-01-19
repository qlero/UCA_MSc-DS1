#!/usr/bin/python

counter = 0
while True:
    try:
        counter += 1
        input()
    except EOFError:
        break
print(counter)
