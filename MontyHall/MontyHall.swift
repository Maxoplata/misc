#!/usr/bin/swift
/**
 * MontyHall.swift
 *
 * Example Monty Hall problem simulation.
 * usage: swift MontyHall.swift
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

// The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
let numberOfRuns = 1000000

var keepWins = 0
var keepLosses = 0
var changeWins = 0
var changeLosses = 0

// loop numberOfRuns without changing our initial door selection
for _ in 1...numberOfRuns {
	// pick a winning door between 1 and 3
	let winningDoor = Int.random(in: 1...3)

	// player selects a random door between 1 and 3
	let playerDoor = Int.random(in: 1...3)

	if playerDoor == winningDoor {
		// player chose the winning door
		keepWins += 1
	} else {
		// player chose a losing door
		keepLosses += 1
	}
}

// loop numberOfRuns while changing our initial door selection
for _ in 1...numberOfRuns {
	// pick a winning door between 1 and 3
	let winningDoor = Int.random(in: 1...3)

	// player selects a random door between 1 and 3
	let playerDoor = Int.random(in: 1...3)

	if playerDoor == winningDoor {
		// player chose the winning door already, count it as a loss as the player will be changing
		changeLosses += 1
	} else {
		/* if the player HAS NOT chosen the winning door already and they change, they will win
		 * example:
		 * - player chooses door 1
		 * - winning door is door 3
		 * - host opens door 2 showing a goat
		 * - player switches to door 3 and wins
		 *
		 * every variation of this will win since we have already eliminated the aspect of the player
		 * having already picked the winning door
		 */
		changeWins += 1
	}
}

print("Keep Wins/Losses: \(keepWins)/\(keepLosses) (\((Float(keepWins) / Float(numberOfRuns)) * 100)% wins)")
print("Change Wins/Losses: \(changeWins)/\(changeLosses) (\((Float(changeWins) / Float(numberOfRuns)) * 100)% wins)")
