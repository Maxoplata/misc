/**
 * MontyHall.go
 *
 * Example Monty Hall problem simulation.
 * usage: go build MontyHall.go && ./MontyHall
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	// The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
	const numberOfRuns int = 1000000

	keepWins := 0
	keepLosses := 0
	changeWins := 0
	changeLosses := 0

	// seed the rng
	rand.Seed(time.Now().UnixNano())

	// loop numberOfRuns without changing our initial door selection
	for i := 1; i <= numberOfRuns; i++ {
		// pick a winning door between 1 and 3
		winningDoor := rand.Intn(3) + 1

		// player selects a random door between 1 and 3
		playerDoor := rand.Intn(3) + 1

		if playerDoor == winningDoor {
			// player chose the winning door
			keepWins++
		} else {
			// player chose a losing door
			keepLosses++
		}
	}

	// loop numberOfRuns while changing our initial door selection
	for i := 1; i <= numberOfRuns; i++ {
		// pick a winning door between 1 and 3
		winningDoor := rand.Intn(3) + 1

		// player selects a random door between 1 and 3
		playerDoor := rand.Intn(3) + 1

		if playerDoor == winningDoor {
			// player chose the winning door already, count it as a loss as the player will be changing
			changeLosses++
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
			changeWins++
		}
	}

	fmt.Printf("Keep Wins/Losses: %d/%d (%f%% wins)\n", keepWins, keepLosses, ((float64(keepWins) / float64(numberOfRuns)) * 100))
	fmt.Printf("Change Wins/Losses: %d/%d (%f%% wins)\n", changeWins, changeLosses, ((float64(changeWins) / float64(numberOfRuns)) * 100))
}
