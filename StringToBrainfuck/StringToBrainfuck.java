/**
 * StringToBrainfuck.java
 *
 * Converts a string to a Brainfuck script that will output said string.
 * usage: javac StringToBrainfuck.java && java StringToBrainfuck your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
class StringToBrainfuck {
	public static void main(String[] args) {
		// if we have arguments passed to the script
		if (args.length > 0) {
			String inputString = String.join(" ", args);

			// the Brainfuck code we will output in the end
			String bfCode = "";

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
				int charVal = (int) inputString.charAt(i);

				if (charVal > currentLocation) {
					// move ahead on the "tape" to build the character
					bfCode += new String(new char[(int) Math.floor((charVal - currentLocation) / 10)]).replace("\0", "+");
					bfCode += "[>++++++++++<-]>";
					bfCode += new String(new char[(charVal - currentLocation) % 10]).replace("\0", "+");
				} else if (charVal < currentLocation) {
					// move backwards on the "tape" to build the character
					bfCode += new String(new char[(int) Math.floor((currentLocation - charVal) / 10)]).replace("\0", "+");
					bfCode += "[>----------<-]>";
					bfCode += new String(new char[(currentLocation - charVal) % 10]).replace("\0", "-");
				} else {
					// delete the "<" from the previous command as we are on the same character
					// and we will want to print it out again
					bfCode = bfCode.substring(0, (bfCode.length() - 1));
				}

				// print out the current character
				bfCode += ".";

				// if we are not on the last letter of the string, move pointer position back to 0
				if (i < (inputString.length() - 1)) {
					bfCode += "<";
				}

				currentLocation = charVal;
			}

			System.out.println(bfCode);
		}
	}
}
