## ******************************************************************** ##
## spatial_data_prep.R
##
## Author: Matthew Aiello-Lammens
## Date Created: 14 MAY 2013
##
## Purpose: A script to create the various spatial GIS layers to be 
## used in several chapters of my dissertation.
##
## ******************************************************************** ##

## Call required pacages
require(dismo)
require(raster)
require(sp)
require(maptools)
gpclibPermit()
require(rgdal)
require(ggplot2)

## ******************************************************************** ##
## Define the Extent of the area that I am working with. 
## This is an extent that will be used in all of my studies, but is 
## defined here. These values essentially define
## what I refer to as "northeast North America" and are based on the extent
## of *Frangula alnus*, excluding outliers in Wyoming and Tennessee

## Long
## Min = -96.61 -> -97
## Max = -63.00 -> -62

## Lat
## Min = 38.60 -> 38 deg
## Max = 47.82 -> 48 deg
xmin <- -97.5
xmax <- -62.5
ymin <- 38.5
ymax <- 48.5

## Create and `extent` object based on these values
falnus.extent <- extent( xmin, xmax, ymin, ymax )

## Save this extent to be used in all studies 
save( falnus.extent, 
      file='~/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/scripts/falnus.extent.RData')

## ******************************************************************** ##
## Define paths to important directories layers are currently stored in
# From:
GIS_LOCAL_DIR <- "/Volumes/Garage/gis_layers_local/"
GIS_DB_DIR <- "~/Dropbox/gis_layers/"
BIOCLIM_DIR <- "/Volumes/Garage/gis_layers_local/WorldClim_bio/"
BIOCLIM_DIR_5ARCMIN <- "/Volumes/Garage/gis_layers_local/WorldClim_bio_5arcmin/"
HYDE_DIR <- "/Volumes/Garage/gis_layers_local/Hyde/"
# To:
FRAL_GIS <- "/Volumes/Garage/Projects/F-alnus/FRAL_GIS/"
FRAL_CROP_LAYERS_30ARCSEC <- "/Volumes/Garage/Projects/F-alnus/FRAL_GIS/Environ_Layers_30arcsec/"
FRAL_CROP_LAYERS_5ARCMIN <- "/Volumes/Garage/Projects/F-alnus/FRAL_GIS/Environ_Layers_5arcmin/"
FRAL_HYDE_LAYERS <- "/Volumes/Garage/Projects/F-alnus/FRAL_GIS/HYDE_Layers/"

## ******************************************************************** ##
## Make Bioclim Environmental layers that match the `falnus.extent`

# Bioclim layers to convert
bio.layers <- c("bio_1","bio_2","bio_3","bio_4","bio_5","bio_6",
                "bio_7","bio_8","bio_9","bio_10","bio_11","bio_12",
                "bio_13","bio_14","bio_15","bio_16","bio_17",
                "bio_18","bio_19")
# Bio4 - Temperature seasonality
# Bio5 - Max temperature of the warmest month
# Bio6 - Min temperature of the coldest month
# Bio12 - Annual precipitation
# Bio15 - Precipitation seasonality
# Bio18 - Precipitation of the warmest quarter
# Bio19 - Precipitation of the coldest quarter
for ( bio in bio.layers ) {
  bio.layer <- paste( BIOCLIM_DIR, bio,"/","hdr.adf", sep="" )
  print( paste("Cropping bio layer: ", bio.layer) )
  bio.rast <- raster( bio.layer )
  crop( bio.rast, falnus.extent, paste(FRAL_CROP_LAYERS_30ARCSEC,bio,'.asc',sep=""),overwrite=TRUE )
}

## Also clip bioclim layers for 5 arc min resolution
bioclim_5arcmin <- list.files(path=BIOCLIM_DIR_5ARCMIN,pattern='bil$',full.names=TRUE)
for ( bio in bioclim_5arcmin ){
  bio.rast <- raster( bio )
  bio.new <- gsub(pattern='bil$',replacement='asc',basename(bio))
  crop( bio.rast, falnus.extent, paste(FRAL_CROP_LAYERS_5ARCMIN,bio.new,sep=""),overwrite=TRUE )
}
  
### TO DO - SETUP CLIPPING OF LANDCOVER, NDVI AND CTI INDEX

## ******************************************************************** ##
## Make Hyde Crop layers that match the `falnus.extent`

## Get a list of all of the crop land Hyde Layers
hyde.crop.layers <- Sys.glob(file.path(HYDE_DIR,"*","crop*asc"))

## Crop these layers
for ( crop.layer in hyde.crop.layers ) {
  crop.rast <- raster( crop.layer )
  crop( crop.rast, falnus.extent, paste(FRAL_HYDE_LAYERS,basename(crop.layer),sep=""), overwrite=TRUE )
}

## ******************************************************************** ##
## Create an empty raster template for the fral extent
## Do this by reading a raster in the FRAL_HERB_LAYERS dir and multiplying
## it by 0
#temp.rast.file <- '/Volumes/Garage/Projects/F-alnus/Herbarium-Spatial-Work/crop2005AD.asc'
temp.rast.file <- '/Volumes/Garage/gis_layers_local/WorldClim_bio_5arcmin/bio1.bil'
fral.generic.rast <- raster( temp.rast.file )
fral.generic.rast <- crop( fral.generic.rast, falnus.extent )
fral.generic.rast <- fral.generic.rast * 0
writeRaster( fral.generic.rast, filename=paste(FRAL_GIS,'fral_empty_rast.asc',sep=''), overwrite=TRUE )

## ******************************************************************** ##
## Create a raster file that is clipped by the lakes polygon, to remove
## the greate lakes from my analyses
Lakes <- readOGR(dsn='/Users/mlammens/Dropbox/gis_layers/lakes.shp',
                 layer='lakes')
Lakes.rast <- rasterize(Lakes, fral.generic.rast,field=0,background=1)
## This created a layer that has 0 values where the lakes are and 1s everywhere else
writeRaster(Lakes.rast,filename=paste(FRAL_GIS,'Lakes_Rast.asc',sep=''), overwrite=TRUE )
