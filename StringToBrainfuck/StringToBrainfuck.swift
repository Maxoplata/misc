#!/usr/bin/swift
/**
 * StringToBrainfuck.swift
 *
 * Converts a string to a Brainfuck script that will output said string.
 * usage: swift StringToBrainfuck.swift your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

// if we have arguments passed to the script
if CommandLine.arguments.count > 1 {
	let inputString = CommandLine.arguments[1...].joined(separator: " ")

	// the Brainfuck code we will output in the end
	var bfCode = ""

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
	var currentLocation = 0

	// iterate through each character in the string
	for (i, char) in inputString.enumerated() {
		// get the Unicode code for the current character
		let charVal = Int(char.asciiValue!)

		if charVal > currentLocation {
			// move ahead on the "tape" to build the character
			bfCode += String(repeating: "+", count: ((charVal - currentLocation) / 10))
			bfCode += "[>++++++++++<-]>"
			bfCode += String(repeating: "+", count: ((charVal - currentLocation) % 10))
		} else if charVal < currentLocation {
			// move backwards on the "tape" to build the character
			bfCode += String(repeating: "+", count: ((currentLocation - charVal) / 10))
			bfCode += "[>----------<-]>"
			bfCode += String(repeating: "-", count: ((currentLocation - charVal) % 10))
		} else {
			// delete the "<" from the previous command as we are on the same character
			// and we will want to print it out again
			bfCode = String(bfCode.prefix(bfCode.count - 1))
		}

		// print out the current character
		bfCode += "."

		// if we are not on the last letter of the string, move pointer position back to 0
		if i < (inputString.count - 1) {
			bfCode += "<"
		}

		currentLocation = charVal
	}

	print(bfCode)
}
