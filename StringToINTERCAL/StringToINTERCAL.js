/**
 * StringToINTERCAL.js
 *
 * Converts a string to an INTERCAL script that will output said string.
 * usage: node StringToINTERCAL.js your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

// class definition
class StringToINTERCAL {
	constructor() {
		this.politeCount = 0
	}

	politeLine(line) {
		if (this.politeCount === 3) {
			this.politeCount = 0;

			return `PLEASE ${line}\n`;
		}

		this.politeCount++;

		return `DO ${line}\n`;
	}

	leadingZeros(dec) {
		const count = dec.length;

		if (count < 8) {
			let diff = 8 - count;

			while (diff > 0) {
				dec = `0${dec}`;

				diff--;
			}
		}

		return dec;
	}

	convertToINTERCAL(string) {
		// reset politeCount
		this.politeCount = 0;

		let ret = this.politeLine(`,1 <- #${string.length}`);

		let lastCharLoc = 256;
		[...string].forEach((char, i) => {
			const charLoc = parseInt(this.leadingZeros(char.charCodeAt(0).toString(2)).split('').reverse().join(''), 2)

			let movePosition = 0;

			if (charLoc < lastCharLoc) {
				movePosition = (lastCharLoc - charLoc);
			} else if (charLoc > lastCharLoc) {
				movePosition = (256 - charLoc) + lastCharLoc;
			}

			lastCharLoc -= movePosition;
			if (lastCharLoc < 1) {
				lastCharLoc = 256 + lastCharLoc;
			}

			ret += this.politeLine(`,1 SUB #${(i + 1)} <- #${movePosition}`);
		});

		ret += this.politeLine('READ OUT ,1');
		ret += this.politeLine('GIVE UP');

		return ret;
	}
}

// 1337 codez
if (process.argv.length > 2) {
	const inputString = process.argv.splice(2).join(' ');

	const myINTERCAL = new StringToINTERCAL();

	console.log(myINTERCAL.convertToINTERCAL(inputString));
}
