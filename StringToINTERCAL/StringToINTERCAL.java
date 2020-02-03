/**
 * StringToINTERCAL.java
 *
 * Converts a string to an INTERCAL script that will output said string.
 * usage: javac StringToINTERCAL.java && java StringToINTERCAL your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

class StringToINTERCAL {
	static int politeCount = 0;

	static String politeLine(String line) {
		if (politeCount == 3) {
			politeCount = 0;

			return String.format("PLEASE %s\n", line);
		}

		politeCount++;

		return String.format("DO %s\n", line);
	}

	static String leadingZeros(String dec) {
		int count = dec.length();

		if (count < 8) {
			int diff = 8 - count;

			while (diff > 0) {
				dec = String.format("0%s", dec);

				diff--;
			}
		}

		return dec;
	}

	static String convertToINTERCAL(String str) {
		// reset politeCount
		politeCount = 0;

		String ret = politeLine(String.format(",1 <- #%s", str.length()));

		int lastCharLoc = 256;
		for (int i = 0; i < str.length(); i++) {
			int charLoc = Integer.parseInt(new StringBuilder(leadingZeros(Integer.toBinaryString((int) str.charAt(i)))).reverse().toString(), 2);

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

			ret += politeLine(String.format(",1 SUB #%d <- #%d", (i + 1), movePosition));
		}

		ret += politeLine("READ OUT ,1");
		ret += politeLine("GIVE UP");

		return ret;
	}

	public static void main(String[] args) {
		if (args.length > 0) {
			String inputString = String.join(" ", args);

			System.out.println(convertToINTERCAL(inputString));
		}
	}
}
