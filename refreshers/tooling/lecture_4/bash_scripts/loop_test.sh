#!/bin/bash

# Loops a value a certain number of times.
# <args1> :: String - String to be repeated
# <args2> :: Int - Upper bound of a loop starting at one

if [ $2 \< 1 ]; then
	echo "$2 is not valid. Defaulting to 1."
	echo $1 "1 time"
else
	for i in $(seq 1 $2); do
		echo "$1 $i time"
	done
fi;
