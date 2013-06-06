## ******************************************************************** ##
## herb_spread_sim.R
##
## Author: Matthew Aiello-Lammens
## Date Created: 19 MAY 2013
##
## Purpose: A script to create simulations of the spread of
## Glossy buckthorn through northeast North America assuming
## simple spread scenarios.
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
require(plyr)
require(maps)

## ******************************************************************** ##
## Define and set working directory
HERB_PROJECT_DIR <- '/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/'
setwd( HERB_PROJECT_DIR )

## Define other important directories
FRAL_HERB_LAYERS <- "/Volumes/Garage/Projects/F-alnus/Herbarium-Spatial-Work/"

## Spatial extent of the study area
## --------------------------------
## These values are based on the extent values used for Chapter 4 - SDM,
## which I worked extensively on during the Fall of 2012 while taking 
## the ENM class with Rob Anderson at CUNY. These values essentially define
## what I refer to as "northeast North America" and are based on the extent
## of *Frangula alnus*, excluding outliers in Wyoming and Tennessee
##
## The extent is saved in 'scripts/falnus.extent.RData' and has an object
## name of 'falnus.extent'

## Load falnus.extent
load('scripts/falnus.extent.RData')
extent.values <- as.matrix(falnus.extent)
xmin <- extent.values[1,1]
xmax <- extent.values[1,2]
ymin <- extent.values[2,1]
ymax <- extent.values[2,2]

## ******************************************************************** ##
## Read in the Grid File, which was created in Quantum GIS
## using the following procedure:
## Vector -> Research Tools -> Vector Grid
##   Parameter values used: 
##   30ArcMin = 0.5,0.5
##   5ArcMin = 0.08333333,0.08333333
##
Grid.30ArcMin <- readOGR(dsn="/Volumes/Garage/gis_layers_local/FRAL_US_Grids/grid_30arcmin.shp",
                         layer="grid_30arcmin")
Grid.5ArcMin <- readOGR(dsn="/Volumes/Garage/gis_layers_local/FRAL_US_Grids/grid_5arcmin.shp",
                        layer="grid_5arcmin")
GridProjection <- proj4string(Grid.5ArcMin)

## ******************************************************************** ##
## Read in an empty raster that has the correct extent
Fral.empty.rast <- raster( paste(FRAL_HERB_LAYERS,'fral_empty_rast.asc',sep="") )

## ******************************************************************** ##
## Get Herbarium Location Data
## ******************************************************************** ##

## Frangula alnus manually assembled herbarium records dataset
## -------------------
## These data have been collected and collated over several years
## and the most recent database of herbarium records can be found in
## '/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3/...
##   data/Herb-F-alnus-Compiled.xlxs(.csv)'
## The methods I used to collect the records is currently detailed
## in my thesis - Chapter 3.
Fral.Herb <- read.csv('data/Herb-F-alnus-Compiled.csv')

## Remove any points that are outside of the lon,lat range
lon.rm <- which(Fral.Herb$Longitude < xmin | Fral.Herb$Longitude > xmax)
if( length(lon.rm > 0) ) {
  Fral.Herb <- Fral.Herb[ -lon.rm, ]
}
lat.rm <- which(Fral.Herb$Latitude < ymin | Fral.Herb$Latitude > ymax)
if( length(lat.rm > 0) ) {
  Fral.Herb <- Fral.Herb[ -lat.rm, ]
}

## Make a spatial data points file for these data
Fral.Herb.pts <- SpatialPoints( cbind( Fral.Herb$Longitude, Fral.Herb$Latitude ) )
## Assign the GridProjection as the projection layer
proj4string(Fral.Herb.pts) <- GridProjection

## Raasterize these points
Fral.Pts.rast <- rasterize( Fral.Herb.pts, Fral.empty.rast, field=1,
                            filename=paste(FRAL_HERB_LAYERS,'FRAL_Pts_Rast.asc',sep=''),
                            overwrite=TRUE )
## Assign the current projection to this raster
projection(Fral.Pts.rast) <- GridProjection

## Calculate the buffer around these points
b <- buffer( Fral.Pts.rast, width=10000,
             filename=paste(FRAL_HERB_LAYERS,'buffertemp.asc',sep=''),overwrite=TRUE)
plot(b,col='red')

b <- Fral.Pts.rast
for (yr in 1:10) {
  time <- system.time(
  b <- buffer(b,width=10000,doEdge=TRUE) )
  plot(b,col='red')
  print(time)
}

## Read in Lakes file to clean data
Lakes <- raster( paste(FRAL_HERB_LAYERS,'Lakes_Rast.asc',sep="") )
b <- b*Lakes
writeRaster(b,filename=paste(FRAL_HERB_LAYERS,'buffertemp.asc',sep=''),overwrite=TRUE)