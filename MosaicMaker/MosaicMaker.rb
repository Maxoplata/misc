#!/usr/bin/ruby
# MosaicMaker.rb
#
# Creates a mosaic image png
# usage: ruby MosaicMaker.rb TILE_SIZE "input url/filepath" "output png file"
# example: ruby MosaicMaker.rb 20 "https://raw.githubusercontent.com/Maxoplata/misc/master/MosaicMaker/_readmeAssets/sampleInput.jpg" "./mosaic.png"
# example: ruby MosaicMaker.rb 20 "./sampleInput.jpg" "./mosaic.png"
#
# @author Maxamilian Demian
# @link https://www.maxodev.org
# @link https://github.com/Maxoplata/misc
require 'open-uri'
require 'rmagick'

error = nil

if ARGV.count != 3
	error = 'Invalid argument count'
else
	tileSize = ARGV[0].to_i
	inputFile = ARGV[1]
	outputFile = ARGV[2]

	# validate tile size
	if !error
		if tileSize < 2
			error = 'Invalid tile size (minimum 2)'
		end
	end

	# validate image file
	imgOrig = nil
	imgOrigResized = nil

	if !error
		begin
			if File.file?(inputFile)
				imgOrig = Magick::Image.read(inputFile).first
				imgOrigResized = imgOrig.dup
			else
				# Magick::Image.read can handle URLs, but fails on HTTPS
				# so we manually handle URLs
				urlData = open(inputFile).read

				imgOrig = Magick::ImageList.new
				imgOrigResized = Magick::ImageList.new

				imgOrig.from_blob(urlData)
				imgOrigResized.from_blob(urlData)
				# for some reason, using imgOrig.dup if we used imgOrig.from_blob
				# will keep both vars pointed to the same item in memory
			end
		rescue
			error = 'Invalid image'
		end
	end

	if !error
		# get width/height of image
		widthOrig = imgOrig.columns
		heightOrig = imgOrig.rows

		# create tile of image
		imgOrigResized.resize_to_fit!(tileSize, tileSize)

		# create new image
		newImg = Magick::Image.new((widthOrig * tileSize), (heightOrig * tileSize)) do
			self.background_color = 'transparent'
		end

		# iterate through original image pixels
		for x in 0..(widthOrig - 1) do
			for y in 0..(heightOrig - 1) do
				# add tile to new image
				newImg.composite!(imgOrigResized, (x * tileSize), (y * tileSize), Magick::OverCompositeOp)

				# get pixel color from original image
				rgb = imgOrig.pixel_color(x, y)
				r = (rgb.red / 257).to_i
				g = (rgb.green / 257).to_i
				b = (rgb.blue / 257).to_i

				# add translucent color layer over tile
				imgColorTile = Magick::Image.new(tileSize, tileSize) do
					self.background_color = "rgba(#{r}, #{g}, #{b}, 0.5)"
				end

				newImg.composite!(imgColorTile, (x * tileSize), (y * tileSize), Magick::OverCompositeOp)
			end
		end

		newImg.write(outputFile)
	end
end

if error
	puts error
end
