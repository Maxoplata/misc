<?php
/**
 * MosaicMaker.php
 *
 * Creates a mosaic image png
 * usage: php MosaicMaker.php TILE_SIZE "input url/filepath" "output png file"
 * example: php MosaicMaker.php 20 "https://raw.githubusercontent.com/Maxoplata/misc/master/MosaicMaker/_readmeAssets/sampleInput.jpg" "./mosaic.png"
 * example: php MosaicMaker.php 20 "./sampleInput.jpg" "./mosaic.png"
 *
 * @author Maxamilian Demian <max@maxdemian.com>
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
set_time_limit(0);

if (count($argv) !== 4) {
	throw new Exception('Invalid argument count');
}

$tileSize = intval($argv[1]);
$inputFile = $argv[2];
$outputFile = $argv[3];

// validate tile size
if ($tileSize < 2) {
	throw new Exception('Invalid tile size (minimum 2)');
}

try {
	// load input file
	$fileData = file_get_contents($inputFile);

	// validate image file
	$imgOrig = imagecreatefromstring($fileData);

	if ($imgOrig === false) {
		throw new Exception('Invalid image');
	}

	// get width/height of image
	$widthOrig = imagesx($imgOrig);
	$heightOrig = imagesy($imgOrig);

	// create new image
	$imgNew = imagecreatetruecolor(($widthOrig * $tileSize), ($heightOrig * $tileSize));

	// iterate through original image pixels
	for ($x = 0; $x < $widthOrig; $x++) {
		for ($y = 0; $y < $heightOrig; $y++) {
			// add tile to new image
			imagecopyresampled($imgNew, $imgOrig, ($x * $tileSize), ($y * $tileSize), 0, 0, $tileSize, $tileSize, $widthOrig, $heightOrig);

			// get pixel color from original image
			$rgb = imagecolorat($imgOrig, $x, $y);
			$colors = imagecolorsforindex($imgOrig, $rgb);

			// add translucent color layer over tile
			$imgLayer = imagecreatetruecolor($tileSize, $tileSize);
			$colorLayer = imagecolorallocatealpha($imgLayer, $colors['red'], $colors['green'], $colors['blue'], 63);

			imagefill($imgLayer, 0, 0, $colorLayer);
			imagecopyresampled($imgNew, $imgLayer, ($x * $tileSize), ($y * $tileSize), 0, 0, $tileSize, $tileSize, $tileSize, $tileSize);
			imagedestroy($imgLayer);
		}
	}

	// cleanup original image
	imagedestroy($imgOrig);

	// output image
	imagepng($imgNew, $outputFile);

	// cleanup new image
	imagedestroy($imgNew);
} catch (Exception $error) {
	throw new Exception("Failed to create Mosaic: {$error->getMessage()}");
}
