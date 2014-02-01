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

source('/Users/mlammens/Dropbox/F-alnus/Chapter-4/R/spatial_data_setup.R')
  
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

## ******************************************************************** ##
## Make Hyde Crop layers that match the `falnus.extent`

## Convert HYDE layers from km2 to % pixel of cover

# Read in pixel area grid
hyde.pixel.area <- raster(paste(GIS_DB_DIR,'mland_cr.asc',sep=''))
# Crop FRAL extent
crop( hyde.pixel.area, falnus.extent, paste(FRAL_HYDE_LAYERS,'mland_cr.asc',sep=""), overwrite=TRUE )
# Read in cropped layer
#hyde.pixel.area <- raster(paste(FRAL_HYDE_LAYERS,'mland_cr.asc',sep=""))

## Get a list of all of the crop land Hyde Layers
hyde.crop.layers <- Sys.glob(file.path(HYDE_DIR,"*","crop*asc"))

## Crop these layers
for ( crop.layer in hyde.crop.layers ) {
  crop.rast <- raster( crop.layer )
  crop.rast <- crop.rast / hyde.pixel.area
  crop_layer_new <- paste(FRAL_HYDE_LAYERS,basename(crop.layer),sep="")
  crop_layer_new <- gsub(pattern='crop',replacement='crop_',crop_layer_new)
  crop_layer_new <- gsub(pattern='AD',replacement='',crop_layer_new)
  crop( crop.rast, falnus.extent, crop_layer_new, overwrite=TRUE )
}

## Get a list of all of the gras land Hyde Layers
hyde.gras.layers <- Sys.glob(file.path(HYDE_DIR,"*","gras*asc"))

## Crop these layers
for ( gras.layer in hyde.gras.layers ) {
  gras.rast <- raster( gras.layer )
  gras.rast <- gras.rast / hyde.pixel.area
  gras_layer_new <- paste(FRAL_HYDE_LAYERS,basename(gras.layer),sep="")
  gras_layer_new <- gsub(pattern='gras',replacement='gras_',gras_layer_new)
  gras_layer_new <- gsub(pattern='AD',replacement='',gras_layer_new)
  crop( gras.rast, falnus.extent, gras_layer_new, overwrite=TRUE )
}

## Get a list of all of the populaiton density Hyde Layers
hyde.popd.layers <- Sys.glob(file.path(HYDE_DIR,"*","popd*asc"))

## Crop these layers
for ( popd.layer in hyde.popd.layers ) {
  popd.rast <- raster( popd.layer )
  popd_layer_new <- paste(FRAL_HYDE_LAYERS,basename(popd.layer),sep="")
  popd_layer_new <- gsub(pattern='AD',replacement='',popd_layer_new)
  crop( popd.rast, falnus.extent, popd_layer_new, overwrite=TRUE )
}

## Also create layers that are in the same projection as the final
## fral patch layers (Lambers equal area and 20 x 20 km)

# Read dem and pot.veg, to get projections used later
dem_na <- raster(paste(GIS_LOCAL_DIR,'gt30h1kna/na_dem.bil',sep=''))
pot.veg <- raster(paste(GIS_DB_DIR,'potentialvegetation.asc',sep=''))

# Get the list of hyde.popd.layers that have been cropped
hyde.popd.layers <- Sys.glob(file.path(FRAL_HYDE_LAYERS,"popd*asc"))

for ( popd.layer in hyde.popd.layers ){
  popd.rast <- raster( popd.layer )
  projection(popd.rast) <- projection(pot.veg)
  # Make a new popd.rast name
  popd_layer_laea <- sub( pattern='*.asc', replacement='_laea.asc', popd.layer )
  # Re-project to Lambers Equal Area
  projectRaster(from=popd.rast,res=c(20000,20000),crs=projection(dem_na),
                filename=popd_layer_laea,overwrite=TRUE)
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

## ******************************************************************** ##
## Clip potential vegetation layer
pot.veg <- raster(paste(GIS_DB_DIR,'potentialvegetation.asc',sep=''))
crop( pot.veg, falnus.extent, paste(FRAL_GIS,'pot_veg.asc',sep=''), overwrite=TRUE )

## ******************************************************************** ##
## Read in, re-project, re-size, and crop CIT Index

# First read dem, to get projection
dem_na <- raster(paste(GIS_LOCAL_DIR,'gt30h1kna/na_dem.bil',sep=''))
hydro1k_proj <- projection(dem_na)

# Read in cti
cti_na <- raster(paste(GIS_LOCAL_DIR,'gt30h1kna/na_cti.bil',sep=''))
projection(cti_na) <- hydro1k_proj

# Re-project raster to match other layers
cti_na_reproj <- projectRaster(from=cti_na,to=pot.veg,
                               filename=paste(GIS_LOCAL_DIR,'gt30h1kna/na_cti_wgs84.bil',sep=''))
cti_na_reproj[cti_na_reproj>5000] <- NA

crop(cti_na_reproj, falnus.extent, paste(FRAL_GIS,'cti_na.asc',sep=''), overwrite=TRUE)

## ******************************************************************** ##
## Read in, clip, and disaagregate layer to go from 0.5 degrees to 5 minutes
soil_ph <- raster(paste(GIS_LOCAL_DIR,'Soil/SAGE_soilph/soilph/hdr.adf',sep=""))
res(soil_ph)
soil_ph <- disaggregate(soil_ph,fact=6)
res(soil_ph)
crop(soil_ph, falnus.extent, paste(FRAL_GIS,'soil_ph.asc',sep=''), overwrite=TRUE)

## ******************************************************************** ##
## Also read in and crop soil pH for topsoil and sub layers
soil_ph_top <- raster(paste(GIS_LOCAL_DIR,'Soil/FAO_soilph/ph_t_ASCII/ph_t',sep=''))
soil_ph_sub <- raster(paste(GIS_LOCAL_DIR,'Soil/FAO_soilph/ph_s_ASCII/ph_s',sep=''))
res(soil_ph_top)

# This layer is ordinal. Here is the inforamtion from the metadata files:
## -------------------------------------------------------------------- ##
# Structure of the attributes
# =======================
#   
#   The first digit indicates the dominant class.
# The second digit indicates the associated class.
# The same classes are used in the first and second digit, except that a zero
# as second digit indicates that the class pointed by the first digit occurs in
# >80% of the pixel.
# 
# pH
# --
#   The classes are:
#   1: pH <4.5
# 2: pH >=4.5-5.5
# 3: pH >5.5-7.2
# 4: pH >7.2-8.5
# 5: pH >8.5
# 97:Water
# 99:Glaciers, Rock, Shifting sand, Missing data
## -------------------------------------------------------------------- ##
# I'm only interested in using the dominant class.
rclass_mat <- c(9,18,1,
                19,28,2,
                29,38,3,
                39,48,4,
                49,58,5,
                90,99,NA)
rclass_mat <- matrix( rclass_mat, ncol=3, byrow=TRUE)
soil_ph_top <- reclassify(soil_ph_top, rclass_mat)
soil_ph_sub <- reclassify(soil_ph_sub, rclass_mat)

crop(soil_ph_top, falnus.extent, paste(FRAL_GIS,'soil_ph_top.asc',sep=''), overwrite=TRUE)
crop(soil_ph_sub, falnus.extent, paste(FRAL_GIS,'soil_ph_sub.asc',sep=''), overwrite=TRUE)

