/**
 * MontyHall.ts
 *
 * Example Monty Hall problem simulation.
 * usage: ts-node MontyHall.ts
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

// The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
const numberOfRuns: number = 1000000;

let keepWins: number = 0;
let keepLosses: number = 0;
let changeWins: number = 0;
let changeLosses: number = 0;

// loop numberOfRuns without changing our initial door selection
for (let i: number = 0; i < numberOfRuns; i++) {
	// pick a winning door between 1 and 3
	const winningDoor: number = Math.floor(Math.random() * 3) + 1;

	// player selects a random door between 1 and 3
	const playerDoor: number = Math.floor(Math.random() * 3) + 1;

	if (playerDoor === winningDoor) {
		// player chose the winning door
		keepWins++;
	} else {
		// player chose a losing door
		keepLosses++;
	}
}

// loop numberOfRuns while changing our initial door selection
for (let i: number = 0; i < numberOfRuns; i++) {
	// pick a winning door between 1 and 3
	const winningDoor: number = Math.floor(Math.random() * 3) + 1;

	// player selects a random door between 1 and 3
	const playerDoor: number = Math.floor(Math.random() * 3) + 1;

	if (playerDoor === winningDoor) {
		// player chose the winning door already, count it as a loss as the player will be changing
		changeLosses++;
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
		changeWins++;
	}
}

console.log(`Keep Wins/Losses: ${keepWins}/${keepLosses} (${(keepWins / numberOfRuns) * 100}% wins)`);
console.log(`Change Wins/Losses: ${changeWins}/${changeLosses} (${(changeWins / numberOfRuns) * 100}% wins)`);