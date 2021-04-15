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

const fs = require('fs');
const Jimp = require('jimp');

(async () => {
	let error = false;

	if (process.argv.length != 5) {
		error = 'Invalid argument count';
	} else {
		const tileSize = parseInt(process.argv[2]);
		const inputFile = process.argv[3];
		const outputFile = process.argv[4];

		// validate tile size
		if (!error) {
			if (tileSize < 2) {
				error = 'Invalid tile size (minimum 2)';
			}
		}

		// validate input file
		let imgOrig;

		if (!error) {
			await Jimp.read(inputFile).then(img => {
				imgOrig = img;
			}).catch(err => {
				error = 'Invalid image';
			});
		}

		if (!error) {
			// get pixel colors from original image
			const widthOrig = imgOrig.bitmap.width;
			const heightOrig = imgOrig.bitmap.height;
			const pixelColors = [];

			for (let x = 0; x < widthOrig; x++) {
				pixelColors[x] = [];

				for (let y = 0; y < heightOrig; y++) {
					pixelColors[x][y] = await imgOrig.getPixelColor(x, y);
				}
			}

			// convert original image to tile
			imgOrig.resize(tileSize, tileSize);

			// create new image
			const imgNew = await new Jimp(widthOrig * tileSize, heightOrig * tileSize);

			// add tiles to new image
			for (let x = 0; x < widthOrig; x++) {
				for (let y = 0; y < heightOrig; y++) {
					// add original image tile
					await imgNew.composite(imgOrig, x * tileSize, y * tileSize, {
						mode: Jimp.BLEND_SOURCE_OVER,
						opacitySource: 1,
						opacityDest: 1,
					})

					// create color tile
					const imgColorTile = await new Jimp(tileSize, tileSize, pixelColors[x][y]);

					// add translucent color tile
					await imgNew.composite(imgColorTile, x * tileSize, y * tileSize, {
						mode: Jimp.BLEND_SOURCE_OVER,
						opacitySource: 0.63,
						opacityDest: 1,
					})
				}
			};

			// output image
			await imgNew.write(outputFile);
		}
	}

	if (error) {
		console.log(error);
	}
})();
