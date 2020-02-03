/**
 * StringToINTERCAL.go
 *
 * Converts a string to an INTERCAL script that will output said string.
 * usage: go build StringToINTERCAL.go && ./StringToINTERCAL your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
 package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

// struct definition
type StringToINTERCAL struct {
	politeCount int
}

func (self *StringToINTERCAL) politeLine(line string) string {
	if self.politeCount == 3 {
		self.politeCount = 0

		return fmt.Sprintf("PLEASE %s\n", line)
	}

	self.politeCount++

	return fmt.Sprintf("DO %s\n", line)
}

func (self *StringToINTERCAL) leadingZeros(dec string) string {
	count := len(dec)

	if count < 8 {
		diff := 8 - count

		for diff > 0 {
			dec = fmt.Sprintf("0%s", dec)

			diff--
		}
	}

	return dec
}

func (self *StringToINTERCAL) convertToINTERCAL(str string) string {
	// reset politeCount
	self.politeCount = 0

	ret := self.politeLine(fmt.Sprintf(",1 <- #%d", len(str)))

	lastCharLoc := 256
	for i, char := range str {
		// get the binary value of the character
		charLocBinary := self.leadingZeros(strconv.FormatInt(int64(char), 2))

		// reverse the binary string
		charLocBinaryReversed := ""
		for i := (len(charLocBinary) - 1); i >= 0; i-- {
			charLocBinaryReversed += string(charLocBinary[i])
		}

		// get the integer value of the reversed binary string
		charLocString, _ := strconv.ParseInt(string(charLocBinaryReversed), 2, 64)

		charLoc := int(charLocString)

		movePosition := 0

		if charLoc < lastCharLoc {
			movePosition = (lastCharLoc - charLoc)
		} else if charLoc > lastCharLoc {
			movePosition = (256 - charLoc) + lastCharLoc
		}

		lastCharLoc -= movePosition
		if lastCharLoc < 1 {
			lastCharLoc = 256 + lastCharLoc
		}

		ret += self.politeLine(fmt.Sprintf(",1 SUB #%d <- #%d", (i + 1), movePosition))
	}

	ret += self.politeLine("READ OUT ,1")
	ret += self.politeLine("GIVE UP")

	return ret
}

// 1337 codez
func main() {
	if (len(os.Args) > 1) {
		inputString := strings.Join(os.Args[1:], " ")

		myINTERCAL := StringToINTERCAL{politeCount: 0}

		fmt.Println(myINTERCAL.convertToINTERCAL(inputString))
	}
}
