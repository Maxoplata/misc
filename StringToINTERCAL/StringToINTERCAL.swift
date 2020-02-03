#!/usr/bin/swift
/**
 * StringToINTERCAL.swift
 *
 * Converts a string to an INTERCAL script that will output said string.
 * usage: swift StringToINTERCAL.swift your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

// class definition
class StringToINTERCAL {
	var politeCount = 0

	func politeLine(_ line: String) -> String {
		if politeCount == 3 {
			politeCount = 0

			return "PLEASE \(line)\n"
		}

		politeCount += 1

		return "DO \(line)\n"
	}

	func leadingZeros(_ dec: String) -> String {
		let count = dec.count
		var retDec = dec

		if count < 8 {
			var diff = 8 - count

			while diff > 0 {
				retDec = "0\(retDec)"

				diff -= 1
			}
		}

		return retDec
	}

	func convertToINTERCAL(_ str: String) -> String {
		// reset politeCount
		politeCount = 0

		var ret = politeLine(",1 <- #\(str.count)")

		var lastCharLoc = 256
		for (i, char) in str.enumerated() {
			let charLoc = Int(String(leadingZeros(String(Int(char.asciiValue!), radix: 2)).reversed()), radix: 2)!

			var movePosition = 0

			if charLoc < lastCharLoc {
				movePosition = (lastCharLoc - charLoc)
			} else if charLoc > lastCharLoc {
				movePosition = (256 - charLoc) + lastCharLoc
			}

			lastCharLoc -= movePosition
			if lastCharLoc < 1 {
				lastCharLoc = 256 + lastCharLoc
			}

			ret += politeLine(",1 SUB #\(i + 1) <- #\(movePosition)")
		}

		ret += politeLine("READ OUT ,1")
		ret += politeLine("GIVE UP")

		return ret
	}
}

// 1337 codez
if CommandLine.arguments.count > 1 {
	let inputString = CommandLine.arguments[1...].joined(separator: " ")

	let myINTERCAL = StringToINTERCAL()

	print(myINTERCAL.convertToINTERCAL(inputString))
}
