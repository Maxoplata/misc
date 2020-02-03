/**
 * StringToBrainfuck.cpp
 *
 * Converts a string to a Brainfuck script that will output said string.
 * usage: g++ StringToBrainfuck.cpp -o StringToBrainfuck && ./StringToBrainfuck your string here
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
#include <iostream>
#include <math.h>

int main(int argc, char *argv[]) {
	// if we have arguments passed to the script
	if (argc > 1) {
		// build input string
		std::string inputString = "";

		for (int i = 1; i < argc; i++) {
			if (inputString != "") {
				inputString.append(" ");
			}

			inputString.append(argv[i]);
		}

		// the Brainfuck code we will output in the end
		std::string bfCode = "";

		/**
		 * our current location on the "tape" (pointer 1).
		 * we use pointer 0 as a multiplier for pointer 1 to shorten the output script.
		 *
		 * e.g.
		 * A(65) = ++++++[>++++++++++<-]>+++++.
		 * ++++++      = add 6 to current pointer value (pointer 0)
		 * [           = while current pointer (pointer 0)'s value > 0
		 * >           = move pointer ahead one (to pointer 1)
		 * ++++++++++  = add 10 to current pointer value (pointer 1)
		 * <           = move pointer back one (to pointer 0)
		 * -           = subtract 1 from current pointervalue (pointer 0)
		 * ]           = end while loop
		 * >           = move pointer ahead one (to pointer 1)
		 * +++++       = add 5 to current pointer value (pointer 1)
		 * .           = print out character at current pointer value (pointer 1, value 65, char 'A')
		 *
		 * instead of:
		 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.
		 */
		int currentLocation = 0;

		// iterate through each character in the string
		for (int i = 0; i < inputString.length(); i++) {
			// get the Unicode code for the current character
			int charVal = (int) inputString.at(i);

			if (charVal > currentLocation) {
				// move ahead on the "tape" to build the character
				bfCode += std::string(floor((charVal - currentLocation) / 10), '+');
				bfCode += "[>++++++++++<-]>";
				bfCode += std::string(((charVal - currentLocation) % 10), '+');
			} else if (charVal < currentLocation) {
				// move backwards on the "tape" to build the character
				bfCode += std::string(floor((currentLocation - charVal) / 10), '+');
				bfCode += "[>----------<-]>";
				bfCode += std::string(((currentLocation - charVal) % 10), '-');
			} else {
				// delete the "<" from the previous command as we are on the same character
				// and we will want to print it out again
				bfCode = bfCode.substr(0, (bfCode.length() - 1));
			}

			// print out the current character
			bfCode += ".";

			// if we are not on the last letter of the string, move pointer position back to 0
			if (i < (inputString.length() - 1)) {
				bfCode += "<";
			}

			currentLocation = charVal;
		}

		std::cout << bfCode << std::endl;
	}
}
