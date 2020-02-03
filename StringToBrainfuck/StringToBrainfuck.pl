#!/usr/bin/perl
#
# StringToBrainfuck.pl
#
# Converts a string to a Brainfuck script that will output said string.
# usage: perl StringToBrainfuck.pl your string here
#
# Author: Maxamilian Demian
#
# https://www.maxodev.org
# https://github.com/Maxoplata/misc

use strict;
use warnings;
use POSIX;

# if we have arguments passed to the script
if ($#ARGV >= 0) {
	my $inputString = join(" ", @ARGV);

	# the Brainfuck code we will output in the end
	my $bfCode = "";

	# our current location on the "tape" (pointer 1).
	# we use pointer 0 as a multiplier for pointer 1 to shorten the output script.
	#
	# e.g.
	# A(65) = ++++++[>++++++++++<-]>+++++.
	# ++++++      = add 6 to current pointer value (pointer 0)
	# [           = while current pointer (pointer 0)'s value > 0
	# >           = move pointer ahead one (to pointer 1)
	# ++++++++++  = add 10 to current pointer value (pointer 1)
	# <           = move pointer back one (to pointer 0)
	# -           = subtract 1 from current pointervalue (pointer 0)
	# ]           = end while loop
	# >           = move pointer ahead one (to pointer 1)
	# +++++       = add 5 to current pointer value (pointer 1)
	# .           = print out character at current pointer value (pointer 1, value 65, char 'A')
	#
	# instead of:
	# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.
	my $currentLocation = 0;

	# iterate through each character in the string
	for (my $i = 0; $i < length($inputString); $i++) {
		# get the Unicode code for the current character
		my $charVal = ord(substr($inputString, $i, 1));

		if ($charVal > $currentLocation) {
			# move ahead on the "tape" to build the character
			$bfCode .= "+" x floor(($charVal - $currentLocation) / 10);
			$bfCode .= "[>++++++++++<-]>";
			$bfCode .= "+" x (($charVal - $currentLocation) % 10);
		} elsif ($charVal < $currentLocation) {
			# move backwards on the "tape" to build the character
			$bfCode .= "+" x floor(($currentLocation - $charVal) / 10);
			$bfCode .= "[>----------<-]>";
			$bfCode .= "-" x (($currentLocation - $charVal) % 10);
		} else {
			# delete the "<" from the previous command as we are on the same character
			# and we will want to print it out again
			$bfCode = substr($bfCode, 0, -1);
		}

		# print out the current character
		$bfCode .= ".";

		# if we are not on the last letter of the string, move pointer position back to 0
		if ($i < (length($inputString) - 1)) {
			$bfCode .= "<";
		}

		$currentLocation = $charVal;
	}

	print "${bfCode}\n";
}
