#!/bin/bash

# GENERAL INFORMATION
# Team BB, Bram Schippers & Bas Wiltenburg
# 12 January 2016 - GeoScripting Lesson 4

# TITLE
# Calculate NDVI from LandSat image and resample and reproject the result

# DESCRIPTION
# Assign the Landsat-image in the subfolder 'data' to a variable
fn=$(ls data/*.tif)

# Assign the result of the calculation (NDVI-image) to a variable
# The result (NDVI-image) is saved in a different folder: 'output' 
outfn="output/ndvi.tif" 

# Calculate the NDVI 
gdal_calc.py -A $fn --A_band=4 -B $fn --B_band=3 --outfile=$outfn --calc="(A.astype(float)-B)/(A.astype(float)+B)" --type='Float32'

# Assign the resampled NDVI-image to a variable 
outres="output/ndvi_resampled.tif"

# Assign the resampled and reprojected NDVI-image to a variable 
outresrep="output/ndvi_resampled_reprojected.tif"

# Resample the NDVI-image, we applied a bilinear resampling technique 
gdalwarp -t_srs '+proj=utm +zone=36 +datum=WGS84' -r bilinear -tr 60 60 $outfn $outres

# Reproject the NDVI-image
gdalwarp -t_srs EPSG:4326 $outres $outresrep

# Delete temporary files
rm "output/ndvi_resampled.tif"
rm "output/ndvi.tif"

# Optionally you can view some statistics by executing the line below
# gdalinfo -hist -stats $outresrep