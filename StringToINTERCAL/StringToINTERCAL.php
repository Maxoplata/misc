<?php
/**
 * StringToINTERCAL.php
 *
 * Converts a string to an INTERCAL script that will output said string.
 * usage: php StringToINTERCAL.php your string here
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

// class definition
class StringToINTERCAL
{
	private $politeCount = 0;

	private function politeLine($line)
	{
		if ($this->politeCount === 3) {
			$this->politeCount = 0;

			return "PLEASE {$line}" . PHP_EOL;
		}

		$this->politeCount++;

		return "DO {$line}" . PHP_EOL;
	}

	private function leadingZeros($dec)
	{
		$count = strlen($dec);

		if ($count < 8) {
			$diff = 8 - $count;

			while ($diff > 0) {
				$dec = "0{$dec}";

				$diff--;
			}
		}

		return $dec;
	}

	public function convertToINTERCAL($string)
	{
		// reset $politeCount
		$this->politeCount = 0;

		$chars = str_split($string);

		$ret = $this->politeLine(',1 <- #' . count($chars));

		$lastCharLoc = 256;
		for ($i = 0; $i < count($chars); $i++) {
			$charLoc = bindec(strrev($this->leadingZeros(decbin(ord($chars[$i])))));

			$movePosition = 0;

			if ($charLoc < $lastCharLoc) {
				$movePosition = ($lastCharLoc - $charLoc);
			} elseif ($charLoc > $lastCharLoc) {
				$movePosition = (256 - $charLoc) + $lastCharLoc;
			}

			$lastCharLoc -= $movePosition;
			if ($lastCharLoc < 1) {
				$lastCharLoc = 256 + $lastCharLoc;
			}

			$ret .= $this->politeLine(',1 SUB #' . ($i + 1) . " <- #{$movePosition}");
		}

		$ret .= $this->politeLine('READ OUT ,1');
		$ret .= $this->politeLine('GIVE UP');

		return $ret;
	}
}

// 1337 codez
if (count($argv) > 1) {
	$inputString = implode(' ', array_splice($argv, 1));

	$myINTERCAL = new StringToINTERCAL();

	print $myINTERCAL->convertToINTERCAL($inputString);
}
