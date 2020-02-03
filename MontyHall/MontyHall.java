/**
 * MontyHall.java
 *
 * Example Monty Hall problem simulation.
 * usage: javac MontyHall.java && java MontyHall
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
class MontyHall {
	public static void main(String[] args) {
		// The number of times to run for each choice (keep and change will run numberOfRuns times EACH)
		int numberOfRuns = 1000000;

		int keepWins = 0;
		int keepLosses = 0;
		int changeWins = 0;
		int changeLosses = 0;

		// loop numberOfRuns without changing our initial door selection
		for (int i = 0; i < numberOfRuns; i++) {
			// pick a winning door between 1 and 3
			int winningDoor = (int) Math.floor(Math.random() * 3) + 1;

			// player selects a random door between 1 and 3
			int playerDoor = (int) Math.floor(Math.random() * 3) + 1;

			if (playerDoor == winningDoor) {
				// player chose the winning door
				keepWins++;
			} else {
				// player chose a losing door
				keepLosses++;
			}
		}

		// loop numberOfRuns while changing our initial door selection
		for (int i = 0; i < numberOfRuns; i++) {
			// pick a winning door between 1 and 3
			int winningDoor = (int) Math.floor(Math.random() * 3) + 1;

			// player selects a random door between 1 and 3
			int playerDoor = (int) Math.floor(Math.random() * 3) + 1;

			if (playerDoor == winningDoor) {
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

		System.out.printf("Keep Wins/Losses: %d/%d (%f%% wins)\n", keepWins, keepLosses, (((float) keepWins / numberOfRuns) * 100));
		System.out.printf("Change Wins/Losses: %d/%d (%f%% wins)\n", changeWins, changeLosses, (((float) changeWins / numberOfRuns) * 100));
	}
}
