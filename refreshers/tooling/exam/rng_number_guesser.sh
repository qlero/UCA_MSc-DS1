#!/bin/bash

# Shell script (.sh) that generates a random integer number 
# between 0 and 100, and asks the user to guess it. On each 
# user try, the program will tell if the number to find is 
# larger or smaller than the one that was typed. Program 
# ends only when user guesses the correct number.

# Records a random number between 1 and 100.
rng_number=$((1 + $RANDOM % 100))

# Greets the player.
echo "Guess a number between 1 and 100:"

# Loops using a 'while' loop that request an input from the user
# at each pass.
while read user_input; do
	# if the input == the randomly selected number, congratulates
	# the player and breaks out of the loop.
	if [[ $user_input -eq $rng_number ]]; then
		echo -e "\nWell done! You guessed $rng_number!"
		break;
	# if the input is greater or lower than the randomly selected 
	# number, asks the user to play again.
	elif [[ $user_input -gt $rng_number ]]; then
		echo -e "\nYour guess is too big. Try again:"
	else
		echo -e "\nYour guess is too low... Try Again:"
	fi
done
