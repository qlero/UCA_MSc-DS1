#!/bin/bash

# Search through a folder and renames a certain number of files
# to a specific extension

counter=0
for file in ./$2/*
do
	if [ ${file:-4} != $3 ]; then
		mv "$file" "$file$3"
		((counter++))
		echo "edited $counter file(s)"
	fi
	if [ $counter -ge $1 ]; then
		break
	fi
done

