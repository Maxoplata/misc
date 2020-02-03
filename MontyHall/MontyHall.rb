#!/usr/bin/ruby
# MontyHall.rb
#
# Example Monty Hall problem simulation.
# usage: ruby MontyHall.rb
#
# @author Maxamilian Demian
# @link https://www.maxodev.org
# @link https://github.com/Maxoplata/misc

# The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
numberOfRuns = 1000000

keepWins = 0
keepLosses = 0
changeWins = 0
changeLosses = 0

# loop numberOfRuns without changing our initial door selection
for i in 1..numberOfRuns do
	# pick a winning door between 1 and 3
	winningDoor = rand(3)

	# player selects a random door between 1 and 3
	playerDoor = rand(3)

	if playerDoor == winningDoor
		# player chose the winning door
		keepWins += 1
	else
		# player chose a losing door
		keepLosses += 1
	end
end

# loop numberOfRuns while changing our initial door selection
for i in 1..numberOfRuns do
	# pick a winning door between 1 and 3
	winningDoor = rand(3)

	# player selects a random door between 1 and 3
	playerDoor = rand(3)

	if playerDoor == winningDoor
		# player chose the winning door already, count it as a loss as the player will be changing
		changeLosses += 1
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
		changeWins += 1
	end
end

puts "Keep Wins/Losses: #{keepWins}/#{keepLosses} (#{(keepWins.to_f / numberOfRuns) * 100}% wins)"
puts "Change Wins/Losses: #{changeWins}/#{changeLosses} (#{(changeWins.to_f / numberOfRuns) * 100}% wins)"
