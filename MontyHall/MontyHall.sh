#!/usr/bin/env bash

###################################################################
# Script Name : MontyHall.sh
# Description : Example Monty Hall problem simulation.
# Usage       : bash MontyHall.sh
# Author      : Maxamilian Demian
# Link        : https://www.maxodev.org
# Link        : https://github.com/Maxoplata/misc
###################################################################

# The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
numberOfRuns=100000

keepWins=0
keepLosses=0
changeWins=0
changeLosses=0

# loop numberOfRuns without changing our initial door selection
for i in $(seq 1 $numberOfRuns)
do
	# pick a winning door between 1 and 3
	winningDoor=$(((RANDOM % 3) + 1))

	# player selects a random door between 1 and 3
	playerDoor=$(((RANDOM % 3) + 1))

	if [ $playerDoor == $winningDoor ]
	then
		# player chose the winning door
		((keepWins++))
	else
		# player chose a losing door
		((keepLosses++))
	fi
done

# loop numberOfRuns while changing our initial door selection
for i in $(seq 1 $numberOfRuns)
do
	# pick a winning door between 1 and 3
	winningDoor=$(((RANDOM % 3) + 1))

	# player selects a random door between 1 and 3
	playerDoor=$(((RANDOM % 3) + 1))

	if [ $playerDoor == $winningDoor ]
	then
		# player chose the winning door already, count it as a loss as the player will be changing
		((changeLosses++))
	else
		# if the player HAS NOT chosen the winning door already and they change, they will win
		# example:
		# - player chooses door 1
		# - winning door is door 3
		# - host opens door 2 showing a goat
		# - player switches to door 3 and wins
		#
		# every variation of this will win since we have already eliminated the aspect of the player
		# having already picked the winning door
		((changeWins++))
	fi
done

keepWinPercent=$(echo "scale=5 ; ($keepWins / $numberOfRuns) * 100" | bc)
changeWinPercent=$(echo "scale=5 ; ($changeWins / $numberOfRuns) * 100" | bc)

echo "Keep Wins/Losses: $keepWins/$keepLosses ($keepWinPercent% wins)"
echo "Change Wins/Losses: $changeWins/$changeLosses ($changeWinPercent% wins)"
