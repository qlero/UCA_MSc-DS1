#!/bin/bash

# Prints 'Normal Message' to the CLI and pipes 'Error Message'
# to a file
# <args1> :: String - name of the file to create

echo "Normal Message"
echo "Error Message" > $1
