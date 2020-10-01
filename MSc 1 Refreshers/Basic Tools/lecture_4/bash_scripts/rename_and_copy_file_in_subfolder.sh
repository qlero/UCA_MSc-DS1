#!/bin/bash

# Function that takes 3 arguments
# <arg1> :: String - Name of the program to rename
# <arg2> :: String - New name for the program
# <arg3> :: String - Subfolder where to copy the renamed program

echo "Name of this program $0"
echo "Number of arguments passed to the script: $#"
echo -e "The arguments passed as input and retained are: $1, $2, $3\n"

if [ ! -f "$1" ]; then
	touch $1
	echo "File $1 was not found. Created instead using touch."
fi

if [ ! -d "$3" ]; then
	mkdir $3
	echo "Folder $3 was not found. Created instead using mkdir."
fi

mv $1 $2; echo "File $1 was renamed to: $2."
cp $2 "$3/$2"; echo "File $2 was copied to: $3."
