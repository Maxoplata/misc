#!/usr/bin/perl
#
# MontyHall.pl
#
# Example Monty Hall problem simulation.
# usage: perl MontyHall.pl
#
# Author: Maxamilian Demian
#
# https://www.maxodev.org
# https://github.com/Maxoplata/misc

use strict;
use warnings;

# The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
my $numberOfRuns = 1000000;

my $keepWins = 0;
my $keepLosses = 0;
my $changeWins = 0;
my $changeLosses = 0;

# loop numberOfRuns without changing our initial door selection
for (my $i = 0; $i < $numberOfRuns; $i++) {
	# pick a winning door between 1 and 3
	my $winningDoor = int(rand(3)) + 1;

	# player selects a random door between 1 and 3
	my $playerDoor = int(rand(3)) + 1;

	if ($playerDoor == $winningDoor) {
		# player chose the winning door
		$keepWins++;
	} else {
		# player chose a losing door
		$keepLosses++;
	}
}

# loop numberOfRuns while changing our initial door selection
for (my $i = 0; $i < $numberOfRuns; $i++) {
	# pick a winning door between 1 and 3
	my $winningDoor = int(rand(3)) + 1;

	# player selects a random door between 1 and 3
	my $playerDoor = int(rand(3)) + 1;

	if ($playerDoor == $winningDoor) {
		# player chose the winning door already, count it as a loss as the player will be changing
		$changeLosses++;
	} else {
		# if the player HAS NOT chosen the winning door already and they change, they will win
		# example:
		# - player chooses door 1
		# - winning door is door 3
		# - host opens door 2 showing a goat
		# - player switches to door 3 and wins
		#
		# every variation of this will win since we have already eliminated the aspect of the player
		# having already picked the winning door
		$changeWins++;
	}
}

print "Keep Wins/Losses: ${keepWins}/${keepLosses} (@{[($keepWins / $numberOfRuns) * 100]}% wins)\n";
print "Change Wins/Losses: ${changeWins}/${changeLosses} (@{[($changeWins / $numberOfRuns) * 100]}% wins)\n";
