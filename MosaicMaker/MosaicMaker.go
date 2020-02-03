/**
 * MosaicMaker.go
 *
 * Creates a mosaic image png
 * usage: go build MosaicMaker.go && ./MosaicMaker TILE_SIZE INPUT_TYPE "input url/filepath" "output png file"
 * example: go build MosaicMaker.go && ./MosaicMaker 20 "https://raw.githubusercontent.com/Maxoplata/misc/master/MosaicMaker/_readmeAssets/sampleInput.jpg" "./mosaic.png"
 * example: go build MosaicMaker.go && ./MosaicMaker 20 "./sampleInput.jpg" "./mosaic.png"
 *
 * @author Maxamilian Demian
 * @link https://www.maxodev.org
 * @link https://github.com/Maxoplata/misc
 */
package main

import (
	"bytes"
	"fmt"
	"image"
	"image/color"
	"image/draw"
	_ "image/gif"
	_ "image/jpeg"
	"image/png"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"

	"github.com/nfnt/resize"
)

func main() {
	var error string = ""

	if (len(os.Args) != 4) {
		error = "Invalid argument count"
	} else {
		// vars
		tileSize, _ := strconv.Atoi(os.Args[1])
		var inputFile string = os.Args[2]
		var outputFile string = os.Args[3]

		// validate the tile size
		if error == "" {
			if tileSize < 2 {
				error = "Invalid tile size (minimum 2)"
			}
		}

		// validate input file
		var urlData []byte
		var fileData *os.File

		if error == "" {
			if _, fileExistsErr := os.Stat(inputFile); os.IsNotExist(fileExistsErr) {
				urlResp, urlErr := http.Get(inputFile)

				if urlResp != nil {
					defer urlResp.Body.Close()
				}

				if urlErr != nil || urlResp.StatusCode != http.StatusOK {
					error = "File does not exist"
				} else {
					urlData, _ = ioutil.ReadAll(urlResp.Body)
				}
			} else {
				fileData, _ = os.Open(inputFile)

				defer fileData.Close()
			}
		}

		// validate image file
		var imgOrig image.Image

		if error == "" {
			var imgFormat string

			if urlData != nil {
				imgOrig, imgFormat, _ = image.Decode(bytes.NewReader(urlData))
			} else {
				imgOrig, imgFormat, _ = image.Decode(fileData)
			}

			if imgFormat != "jpeg" && imgFormat != "png" && imgFormat != "gif" {
				error = "Invalid image"
			}
		}

		if error == "" {
			// get width/height of image
			var widthOrig int = imgOrig.Bounds().Size().X
			var heightOrig int = imgOrig.Bounds().Size().Y

			// create tile of image
			imgOrigResized := resize.Resize(uint(tileSize), uint(tileSize), imgOrig, resize.Lanczos3)

			// create new image
			imgNew := image.NewRGBA(image.Rect(0, 0, (widthOrig * tileSize), (heightOrig * tileSize)))

			// iterate through original image pixels
			for x := 0; x < widthOrig; x++ {
				for y := 0; y < heightOrig; y++ {
					// add tile to new image
					draw.Draw(imgNew, imgOrigResized.Bounds().Add(image.Pt((x * tileSize), (y * tileSize))), imgOrigResized, image.ZP, draw.Over)

					// get pixel color from original image
					r, g, b, _ := imgOrig.At(x, y).RGBA()

					// add translucent color layer over tile
					imgColorTile := image.NewNRGBA(image.Rect(0, 0, tileSize, tileSize))
					translucentColor := color.NRGBA{uint8(r / 257), uint8(g / 257), uint8(b / 257), 127}

					draw.Draw(imgColorTile, imgColorTile.Bounds(), &image.Uniform{translucentColor}, image.ZP, draw.Src)
					draw.Draw(imgNew, imgColorTile.Bounds().Add(image.Pt((x * tileSize), (y * tileSize))), imgColorTile, image.ZP, draw.Over)
				}
			}

			// save file
			fileOpen, _ := os.Create(outputFile)

			defer fileOpen.Close()

			png.Encode(fileOpen, imgNew)
		}
	}

	if (error != "") {
		fmt.Println(error)
	}
}
