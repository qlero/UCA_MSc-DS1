#!/bin/bash

# Moves all files with a specific extension within a
# folder to another one.
# <args1> :: String - Extension of the files to move
# <args2> :: String - path of the folder to search through
# <args3> :: String - path of the target folder

if [ ! -d "$3" ]; then
        mkdir $3
        echo "Folder $3 was not found. Created instead using mkdir."
fi

if [ -d $2 ] && [ -d $3 ]; then
	mv $2/*$1 $3
fi
