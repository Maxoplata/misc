#!/usr/bin/perl
#
# StringToINTERCAL.pl
#
# Converts a string to an INTERCAL script that will output said string.
# usage: perl StringToINTERCAL.pl your string here
#
# Author: Maxamilian Demian
#
# https://www.maxodev.org
# https://github.com/Maxoplata/misc

use strict;
use warnings;

# package definition
{
 	package StringToINTERCAL;

	sub new {
		my ($class, $args) = @_;
		my $self = bless {
			politeCount => 0,
		}, $class;
	}

	sub politeLine {
		my ($self, $line) = @_;

		if ($self->{politeCount} == 3) {
			$self->{politeCount} = 0;

			return "PLEASE ${line}\n";
		}

		$self->{politeCount}++;

		return "DO ${line}\n";
	}

	sub convertToINTERCAL {
		my ($self, $string) = @_;

		# reset $politeCount
		$self->{politeCount} = 0;

		my $ret = $self->politeLine(",1 <- #" . length($string));

		my $lastCharLoc = 256;
		for (my $i = 0; $i < length($string); $i++) {
			my $charLoc = oct("0b" . reverse(sprintf("%.8b", ord(substr($string, $i, 1)))));

			my $movePosition = 0;

			if ($charLoc < $lastCharLoc) {
				$movePosition = ($lastCharLoc - $charLoc);
			} elsif ($charLoc > $lastCharLoc) {
				$movePosition = (256 - $charLoc) + $lastCharLoc;
			}

			$lastCharLoc -= $movePosition;
			if ($lastCharLoc < 1) {
				$lastCharLoc = 256 + $lastCharLoc;
			}

			$ret .= $self->politeLine(",1 SUB #" . ($i + 1) . " <- #${movePosition}");
		}

		$ret .= $self->politeLine("READ OUT ,1");
		$ret .= $self->politeLine("GIVE UP");

		return $ret;
	}
}

# 1337 codez
if ($#ARGV >= 0) {
	my $inputString = join(" ", @ARGV);

	my $myINTERCAL = StringToINTERCAL->new;

	print $myINTERCAL->convertToINTERCAL($inputString);
}
