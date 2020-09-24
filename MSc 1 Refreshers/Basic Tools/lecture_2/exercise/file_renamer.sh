#!/bin/bash

for i in $(seq 1 $1)
do
	mv "$2/hello$i" "$2/hello$i.txt"
done
