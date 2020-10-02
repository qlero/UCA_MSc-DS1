#!/bin/bash
counter=0
for file in ./$2/*
do
	if [ ${file:-4} != ".txt" ]; then
		mv "$file" "$file.txt"
		((counter++))
		echo "edited $counter file(s)"
	fi
	if [ $counter -ge $1 ]; then
		break
	fi
done

