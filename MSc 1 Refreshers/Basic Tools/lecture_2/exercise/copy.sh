#!/bin/bash
echo "Name of this program $0"
echo "Number of arguments passed to the script: $#"
echo "The arguments passed as input and retained are: $1, $2, $3"
mv $1 $2
cp $2 "$3/$2"
