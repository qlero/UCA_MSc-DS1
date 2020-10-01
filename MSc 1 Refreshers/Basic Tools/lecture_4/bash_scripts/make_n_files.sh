#!/bin/bash

# Creates a given number of files inside a given folder.
# <args1> :: Int - Number of files to create
# <args2> :: String - Root name of the file to create, 
# to which its number will be appended
# <args3> :: String - name of the folder where to create the file

if [ ! -d "$3" ]; then
        mkdir $3
        echo "Folder $3 was not found. Created instead using mkdir."
fi

for i in $(seq 1 $1)
do 
	touch "$3/$2$i"
done

