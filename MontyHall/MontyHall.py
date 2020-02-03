#!/usr/bin/env python
"""
MontyHall.py

Example Monty Hall problem simulation.
usage: python MontyHall.py

https://www.maxodev.org
https://github.com/Maxoplata/misc
"""

import random

__author__ = "Maxamilian Demian"
__email__ = "max@maxdemian.com"

# The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
numberOfRuns = 1000000

keepWins = 0
keepLosses = 0
changeWins = 0
changeLosses = 0

# loop numberOfRuns without changing our initial door selection
for i in range(0, numberOfRuns):
	# pick a winning door between 1 and 3
	winningDoor = random.randint(1, 3)

	# player selects a random door between 1 and 3
	playerDoor = random.randint(1, 3)

	if playerDoor == winningDoor:
		# player chose the winning door
		keepWins += 1
	else:
		# player chose a losing door
		keepLosses += 1

# loop numberOfRuns while changing our initial door selection
for i in range(0, numberOfRuns):
	# pick a winning door between 1 and 3
	winningDoor = random.randint(1, 3)

	# player selects a random door between 1 and 3
	playerDoor = random.randint(1, 3)

	if playerDoor == winningDoor:
		# player chose the winning door already, count it as a loss as the player will be changing
		changeLosses += 1
	else:
		# if the player HAS NOT chosen the winning door already and they change, they will win
		# example:
		# - player chooses door 1
		# - winning door is door 3
		# - host opens door 2 showing a goat
		# - player switches to door 3 and wins
		#
		# every variation of this will win since we have already eliminated the aspect of the player
		# having already picked the winning door
		changeWins += 1

print('Keep Wins/Losses: {}/{} {}% wins)'.format(keepWins, keepLosses, ((float(keepWins) / numberOfRuns) * 100)))
print('Change Wins/Losses: {}/{} {}% wins)'.format(changeWins, changeLosses, ((float(changeWins) / numberOfRuns) * 100)))
