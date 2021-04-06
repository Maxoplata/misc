use rand::Rng;

// The number of times to run for each choice (keep and change will run NUMBER_OF_RUNS times EACH)
static NUMBER_OF_RUNS: i32 = 1000000;

fn main() {
	let mut keep_wins := 0;
	let mut keep_losses = 0;
	let mut change_wins = 0;
	let mut change_losses = 0;

	// seed the rng
	let mut rng = rand::thread_rng();

	// loop NUMBER_OF_RUNS without changing our initial door selection
	for _ in 0..NUMBER_OF_RUNS {
		// pick a winning door between 1 and 3
		let winning_door = rng.gen_range(0..3);

		// player selects a random door between 1 and 3
		let player_door = rng.gen_range(0..3);

		if player_door == winning_door {
			// player chose the winning door
			keep_wins = keep_wins + 1;
		} else {
			// player chose a losing door
			keep_losses = keep_losses + 1;
		}
	}

	// loop NUMBER_OF_RUNS while changing our initial door selection
	for _ in 0..NUMBER_OF_RUNS {
		// pick a winning door between 1 and 3
		let winning_door = rng.gen_range(0..3);

		// player selects a random door between 1 and 3
		let player_door = rng.gen_range(0..3);

		if player_door == winning_door {
			// player chose the winning door already, count it as a loss as the player will be changing
			change_losses = change_losses + 1;
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
			change_wins = change_wins + 1;
		}
	}

	println!("Keep Wins/Losses: {}/{} ({}% wins)", keep_wins, keep_losses, (keep_wins as f32 / NUMBER_OF_RUNS as f32) * 100.0);
	println!("Change Wins/Losses: {}/{} ({}% wins)", change_wins, change_losses, (change_wins as f32 / NUMBER_OF_RUNS as f32) * 100.0);
}