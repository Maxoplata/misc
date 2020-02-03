#!/usr/bin/env python
"""
StringToINTERCAL.py

Converts a string to an INTERCAL script that will output said string.
usage: python StringToINTERCAL.py your string here

https://www.maxodev.org
https://github.com/Maxoplata/misc
"""

import sys

__author__ = "Maxamilian Demian"
__email__ = "max@maxdemian.com"

# class definition
class StringToINTERCAL:
	politeCount = 0

	def politeLine(self, line):
		if self.politeCount == 3:
			self.politeCount = 0

			return 'PLEASE {}\n'.format(line)

		self.politeCount += 1

		return 'DO {}\n'.format(line)

	def leadingZeros(self, dec):
		count = len(dec)

		if count < 8:
			diff = 8 - count

			while diff > 0:
				dec = '0{}'.format(dec)

				diff -= 1

		return dec

	def convertToINTERCAL(self, string):
		# reset politeCount
		self.politeCount = 0

		ret = self.politeLine(',1 <- #{}'.format(len(string)))

		lastCharLoc = 256
		for i in range(0, len(string)):
			charLoc = int(self.leadingZeros('{0:b}'.format(ord(string[i])))[::-1], 2)

			movePosition = 0

			if charLoc < lastCharLoc:
				movePosition = (lastCharLoc - charLoc)
			elif charLoc > lastCharLoc:
				movePosition = (256 - charLoc) + lastCharLoc

			lastCharLoc -= movePosition
			if lastCharLoc < 1:
				lastCharLoc = 256 + lastCharLoc

			ret += self.politeLine(',1 SUB #{} <- #{}'.format((i + 1), movePosition))

		ret += self.politeLine('READ OUT ,1')
		ret += self.politeLine('GIVE UP')

		return ret

# 1337 codez
if len(sys.argv) > 1:
	inputString = ' '.join(sys.argv[1:])

	myINTERCAL = StringToINTERCAL()

	print(myINTERCAL.convertToINTERCAL(inputString))
