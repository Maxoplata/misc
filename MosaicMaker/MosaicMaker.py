#!/usr/bin/env python
"""
MosaicMaker.py

Creates a mosaic image png
usage: python MosaicMaker.py TILE_SIZE INPUT_TYPE "input url/filepath" "output png file"
example: python MosaicMaker.py 20 "https://raw.githubusercontent.com/Maxoplata/misc/master/MosaicMaker/_readmeAssets/sampleInput.jpg" "./mosaic.png"
example: python MosaicMaker.py 20 "./sampleInput.jpg" "./mosaic.png"

https://www.maxodev.org
https://github.com/Maxoplata/misc
"""

import cStringIO
import os
import sys
import urllib2
from PIL import Image

__author__ = "Maxamilian Demian"
__email__ = "max@maxdemian.com"

# if we have arguments passed to the script
if len(sys.argv) != 4:
	raise Exception('Invalid argument count')

# vars
tileSize = int(sys.argv[1])
inputFile = sys.argv[2]
outputFile = sys.argv[3]

# validate the tile size
if tileSize < 2:
	raise Exception('Invalid tile size (minimum 2)')

# validate input file
urlData = None

if not os.path.exists(inputFile):
	try:
		urlData = urllib2.urlopen(inputFile).read()
	except:
		raise Exception('File does not exist')

try:
	# validate image file
	imgOrig = Image.open(inputFile) if urlData == None else Image.open(cStringIO.StringIO(urlData))

	# get width/height of image
	widthOrig = imgOrig.size[0]
	heightOrig = imgOrig.size[1]

	# create tile of image
	imgOrigResized = imgOrig.resize((tileSize, tileSize))

	# create new image
	imgNew = Image.new('RGB', ((widthOrig * tileSize), (heightOrig * tileSize)))

	# load image pixel data
	imgOrig = imgOrig.convert('RGB')
	pixels = imgOrig.load()

	# iterate through original image pixels
	for x in range(0, widthOrig):
		for y in range(0, heightOrig):
			# add tile to new image
			imgNew.paste(imgOrigResized, ((x * tileSize), (y * tileSize)))

			# get pixel color from original image
			rgb = pixels[x, y]
			r = rgb[0]
			g = rgb[1]
			b = rgb[2]

			# add translucent color layer over tile
			imgColorTile = Image.new('RGBA', (tileSize, tileSize), (r, g, b, 127))
			imgNew.paste(imgColorTile, ((x * tileSize), (y * tileSize)), imgColorTile)

	# save file
	imgNew.save(outputFile, 'PNG')
except Exception as error:
	raise Exception('Failed to create Mosaic: {}'.format(error))
