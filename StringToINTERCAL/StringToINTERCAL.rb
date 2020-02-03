#!/usr/bin/ruby
# StringToINTERCAL.rb
#
# Converts a string to an INTERCAL script that will output said string.
# usage: ruby StringToINTERCAL.rb your string here
#
# @author Maxamilian Demian <max@maxdemian.com>
# @link https://www.maxodev.org
# @link https://github.com/Maxoplata/misc

# class definition
class StringToINTERCAL
	def initialize()
		@politeCount = 0
	end

	def politeLine(line)
		if @politeCount === 3
			@politeCount = 0

			return "PLEASE #{line}\n"
		end

		@politeCount += 1

		return "DO #{line}\n"
	end

	def leadingZeros(dec)
		count = dec.length

		if count < 8
			diff = 8 - count

			while diff > 0
				dec = "0#{dec}"

				diff -= 1
			end
		end

		return dec
	end

	def convertToINTERCAL(string)
		# reset politeCount
		@politeCount = 0

		chars = string.split('')

		ret = self.politeLine(',1 <- #' + chars.count.to_s)

		lastCharLoc = 256
		chars.each_with_index {|char, i|
			charLoc = self.leadingZeros(char.ord.to_s(2)).reverse.to_i(2)

			movePosition = 0

			if charLoc < lastCharLoc
				movePosition = (lastCharLoc - charLoc)
			elsif charLoc > lastCharLoc
				movePosition = (256 - charLoc) + lastCharLoc
			end

			lastCharLoc -= movePosition
			if lastCharLoc < 1
				lastCharLoc = 256 + lastCharLoc
			end

			ret += self.politeLine(',1 SUB #' + (i + 1).to_s + " <- ##{movePosition}")
		}

		ret += self.politeLine('READ OUT ,1')
		ret += self.politeLine('GIVE UP')

		return ret
	end
end

# 1337 codez
if ARGV.count > 0
	inputString = ARGV.join(' ')

	puts StringToINTERCAL.new.convertToINTERCAL(inputString)
end
