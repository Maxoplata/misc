/**
 * StringToINTERCAL.cpp
 *
 * Converts a string to an INTERCAL script that will output said string.
 * usage: g++ StringToINTERCAL.cpp -o StringToINTERCAL && ./StringToINTERCAL your string here
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
#include <iostream>

// class definition
class StringToINTERCAL {
	private:
		int politeCount;

		std::string politeLine(std::string line) {
			if (politeCount == 3) {
				politeCount = 0;

				return "PLEASE " + line + "\n";
			}

			politeCount++;

			return "DO " + line + "\n";
		}

	public:
		StringToINTERCAL() {
			politeCount = 0;
		}

		std::string convertToINTERCAL(std::string str) {
			// reset politeCount
			politeCount = 0;

			std::string ret = politeLine(",1 <- #" + std::to_string(str.length()));

			int lastCharLoc = 256;
			for (int i = 0; i < str.length(); i++) {
				// convert char to its binary value
				std::string charLocBinary = std::bitset<8>((int) str.at(i)).to_string();

				// reverse binary string
				reverse(charLocBinary.begin(), charLocBinary.end());

				// convert reversed binary string to integer
				int charLoc = stoi(charLocBinary, nullptr, 2);

				int movePosition = 0;

				if (charLoc < lastCharLoc) {
					movePosition = (lastCharLoc - charLoc);
				} else if (charLoc > lastCharLoc) {
					movePosition = (256 - charLoc) + lastCharLoc;
				}

				lastCharLoc -= movePosition;
				if (lastCharLoc < 1) {
					lastCharLoc = 256 + lastCharLoc;
				}

				ret += politeLine(",1 SUB #" + std::to_string(i + 1) + " <- #" + std::to_string(movePosition));
			}

			ret += politeLine("READ OUT ,1");
			ret += politeLine("GIVE UP");

			return ret;
		}
};

// 1337 codez
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

		// do magic...
		StringToINTERCAL myINTERCAL;

		std::cout << myINTERCAL.convertToINTERCAL(inputString) << std::endl;
	}
}
