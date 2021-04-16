/**
 * MosaicMaker.js
 *
 * Creates a mosaic image png
 * usage: node MosaicMaker.js TILE_SIZE "input url/filepath" "output png file"
 * example: node MosaicMaker.js 20 "https://raw.githubusercontent.com/Maxoplata/misc/master/MosaicMaker/_readmeAssets/sampleInput.jpg" "./mosaic.png"
 * example: node MosaicMaker.js 20 "./sampleInput.jpg" "./mosaic.png"
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */

const Jimp = require('jimp');

(async () => {
	if (process.argv.length != 5) {
		throw new Error('Invalid argument count');
	}

	const tileSize = parseInt(process.argv[2]);
	const inputFile = process.argv[3];
	const outputFile = process.argv[4];

	// validate tile size
	if (tileSize < 2) {
		throw new Error('Invalid tile size (minimum 2)');
	}

	try {
		// load input file
		let imgOrig = await Jimp.read(inputFile);

		// get pixel colors from original image
		const widthOrig = imgOrig.bitmap.width;
		const heightOrig = imgOrig.bitmap.height;
		const pixelColors = [];

		for (let x = 0; x < widthOrig; x++) {
			pixelColors[x] = [];

			for (let y = 0; y < heightOrig; y++) {
				pixelColors[x][y] = imgOrig.getPixelColor(x, y);
			}
		}

		// convert original image to tile
		imgOrig.resize(tileSize, tileSize);

		// create new image
		const imgNew = new Jimp(widthOrig * tileSize, heightOrig * tileSize);

		// add tiles to new image
		for (let x = 0; x < widthOrig; x++) {
			for (let y = 0; y < heightOrig; y++) {
				// add original image tile
				imgNew.composite(imgOrig, x * tileSize, y * tileSize, {
					mode: Jimp.BLEND_SOURCE_OVER,
					opacitySource: 1,
					opacityDest: 1,
				})

				// create color tile
				const imgColorTile = new Jimp(tileSize, tileSize, pixelColors[x][y]);

				// add translucent color tile
				imgNew.composite(imgColorTile, x * tileSize, y * tileSize, {
					mode: Jimp.BLEND_SOURCE_OVER,
					opacitySource: 0.63,
					opacityDest: 1,
				})
			}
		}

		// output image
		imgNew.write(outputFile);
	} catch (error) {
		throw new Error(`Failed to create Mosaic: ${error}`);
	}
})();
