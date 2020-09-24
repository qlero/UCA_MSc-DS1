#!/bin/bash

if [ -d $1 ] && [ -d $2 ]; then
	mv $1/*.txt $2
fi
