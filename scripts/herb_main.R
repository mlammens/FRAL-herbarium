## ******************************************************************** ##
## herb_main.R
##
## Author: Matthew Aiello-Lammens
## Date Created: 06 APR 2013
##   Major Update: 24 MAY 2013
##
## Purpose: A main repository of R scripts used to carryout data colletion
## and analysis for Chapter 3 - Retrospective spatial modeling of *Frangula
## alnus* using herbarium recrods.
##
## Much of this work has been carried out piece meal in other scripts 
## and analyses over the last few years. The preliminary work for this 
## chapter was presented at ESA in 2012 and NENHC in 2012.
##
## EDITS:
## * Data collection has been moved to different script. It is now
##   described in 'scripts/herb_data_prep.Rmd'
##
## ******************************************************************** ##
## Development To-do List:
## 
## * Scale dependence of lag phase
## The appraoch I want to take in this updated version of the mansucript
## (updated from my chapter) is to look at the spread of buckthorn through
## time using different extents, but the same grain size. 
## Essentially, what I suspect is that at smaller (i.e., regional) scales,
## the lag period may differ than when looking at the invasion in its 
## entirety. 
## Is this a trivial expectation? I don't actually think so, especially
## given that my previous reconstruction of the spread indicates that there
## are large jumps to invading new areas, with relatively little buckthorn
## around it. So it's almost as if these jumps constitute a new, separate 
## invasion.
##
## ******************************************************************** ##


## ******************************************************************** ##
## Required Packages and Parameter Specifications
## ******************************************************************** ##

## Required Packages
## -----------------
require(dismo)
require(maptools)
#gpclibPermit()
require(rgdal)
require(ggplot2)
require(sp)
require(PBSmapping)
require(plyr)
require(maps)
require(psych)
require(reshape)
require(zoo)

# ## Define and set working directory
# HERB_PROJECT_DIR <- '/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/'
# setwd( HERB_PROJECT_DIR )

## ******************************************************************** ##
## Define some user-created functions here
## ******************************************************************** ##

## -------------------------------------------------------------------- ##
## Rounding function, used to assign decade values to records. This
## function is from the following post on stackoverflow
## http://stackoverflow.com/questions/6461209/how-to-round-up-to-the-nearest-10-or-100-or-x
round.up <- function(x,to=10) {
  to*(x%/%to + as.logical(x%%to))
}
## -------------------------------------------------------------------- ##
## Calculate the distance of 1 degree of Longitude for the 
## min and max latitudes in my extent
dist.lon <- function(lat.deg) {
  # Distance in km of one degree of latitude at the equator
  lat.1deg <- 111
  # Convert degrees to radians
  lat.rad <- lat.deg * (pi/180)
  # According to the following website, one degree of longitude
  # is the distance of one degree of latitude at the equator multiplied
  # by the cosine of the latitude:
  # http://www.colorado.edu/geography/gcraft/warmup/aquifer/html/distance.html
  lon.1deg <- lat.1deg * cos(lat.rad)
  return(lon.1deg)
}
## -------------------------------------------------------------------- ##
## Make a two column data.frame of the cumulative number of grid cells
## occupied for each year represented in a dataset
make.cummgrids.dfYrs <- function( record.df ) {
  ## Get year of first introduction for each grid cell that is 
  ## occupied
  Grid.Frst.Yr <- ddply(.data=record.df,
                        .variable=c("GridID"),
                        Grid.Frst.Yr=min(CollectionYear),
                        summarize)
  ## Remove NA Rows (points that dont fall into a grid cell)
  if ( length(which(is.na(Grid.Frst.Yr$GridID))) > 0 ) {
    Grid.Frst.Yr <- Grid.Frst.Yr[-which(is.na(Grid.Frst.Yr$GridID)),]
  }
  ## Sort Grid.Frst.Yr by year
  Grid.Frst.Yr <- Grid.Frst.Yr[order(Grid.Frst.Yr$Grid.Frst.Yr),]
  ## Add a column of the total grid cells occupied at that time point. Note
  ## that at this point, there is more than one value for each year, as there
  ## are more than one new grid cells occupied (thus adding to the cumulative
  ## total) per year for *some* years.
  Grid.Frst.Yr$CummGrids <- cumsum(rep(1,times=length(Grid.Frst.Yr$Grid.Frst.Yr)))
  ## Get the max number of occupied grid cells for any given year
  Grid.CummGrids.Yr <- ddply(.data=Grid.Frst.Yr,
                             .variable=c("Grid.Frst.Yr"),
                             Max.Grid=max(CummGrids),
                             summarize)
  return( Grid.CummGrids.Yr )
}
## -------------------------------------------------------------------- ##
## Create a new data.frame were there is a value for the number
## of grid cells occupied cumualtively through time 
make.cummgrids.allYrs <- function( cumm.grid.df ){
  # Convert first year to numeric value
  cumm.grid.df$Grid.Frst.Yr <- as.numeric( cumm.grid.df$Grid.Frst.Yr )
  first.year <- min( cumm.grid.df$Grid.Frst.Yr )
  last.year <- max( cumm.grid.df$Grid.Frst.Yr )
  Years <- first.year:last.year
  # This will yield a vector of length n-1, where n = length of cumm.grid.df$Grid.Frst.Yr
  diff.btw.obsYears <- diff( cumm.grid.df$Grid.Frst.Yr )
  # Add 1 to the end of this vector
  diff.btw.obsYears <- c(diff.btw.obsYears,1)
  OccGrids <- rep( cumm.grid.df$Max.Grid, times=diff.btw.obsYears )
  return(data.frame(Years=Years,OccGrids=OccGrids))
}
## -------------------------------------------------------------------- ##
## Create a new data.frame were there is a value for the number
## of records cumualtively through time 
make.cummrecs.allYrs <- function( cumm.recs.df ){
  # Convert Collection year to numeric value
  cumm.recs.df$CollectionYear <- as.numeric( cumm.recs.df$CollectionYear )
  first.year <- min( cumm.recs.df$CollectionYear )
  last.year <- max( cumm.recs.df$CollectionYear )
  Years <- first.year:last.year
  # This will yield a vector of length n-1, where n = length of cumm.recs.df$CollectionYear
  diff.btw.obsYears <- diff( cumm.recs.df$CollectionYear )
  # Add 1 to the end of this vector
  diff.btw.obsYears <- c(diff.btw.obsYears,1)
  CummRecs <- rep( cumm.recs.df$Cumm.Recs, times=diff.btw.obsYears )
  return(data.frame(Years=Years,CummRecs=CummRecs))
}
## -------------------------------------------------------------------- ##
## Make a two column data.frame of the cumulative number of **counties**
## occupied for each year represented in a dataset
make.cummCntys.dfYrs <- function( cnty.df ) {
  ## Get year of first introduction for each grid cell that is 
  ## occupied
  Cnty.Frst.Yr <- ddply(.data=cnty.df,
                        .variable=c("Admin2"),
                        Cnty.Frst.Yr=min(CollectionYear),
                        summarize)
  ## Sort Cnty.Frst.Yr by year
  Cnty.Frst.Yr <- Cnty.Frst.Yr[order(Cnty.Frst.Yr$Cnty.Frst.Yr),]
  ## Add a column of the total counties occupied at that time point. Note
  ## that at this point, there is more than one value for each year, as there
  ## are more than one new counties occupied (thus adding to the cumulative
  ## total) per year for *some* years.
  Cnty.Frst.Yr$CummCnty <- cumsum(rep(1,times=length(Cnty.Frst.Yr$Cnty.Frst.Yr)))
  ## Get the max number of occupied counties for any given year
  Cumm.Cnty.Yr <- ddply(.data=Cnty.Frst.Yr,
                             .variable=c("Cnty.Frst.Yr"),
                             Max.Cnty=max(CummCnty),
                             summarize)
  return( Cumm.Cnty.Yr )
}
## -------------------------------------------------------------------- ##
## Create a new data.frame were there is a value for the number
## of **counties** occupied cumualtively through time for every year
make.cummCntys.allYrs <- function( cumm.cnty.df ){
  # Convert first year to numeric value
  cumm.cnty.df$Cnty.Frst.Yr <- as.numeric( cumm.cnty.df$Cnty.Frst.Yr )
  first.year <- min( cumm.cnty.df$Cnty.Frst.Yr )
  last.year <- max( cumm.cnty.df$Cnty.Frst.Yr )
  Years <- first.year:last.year
  # This will yield a vector of length n-1, where n = length of cumm.cnty.df$Cnty.Frst.Yr
  diff.btw.obsYears <- diff( cumm.cnty.df$Cnty.Frst.Yr )
  # Add 1 to the end of this vector
  diff.btw.obsYears <- c(diff.btw.obsYears,1)
  OccCounties <- rep( cumm.cnty.df$Max.Cnty, times=diff.btw.obsYears )
  return(data.frame(Years=Years,OccCounties=OccCounties))
}
## -------------------------------------------------------------------- ##
## Write a function to calculate 'annual' slope values for the cubic linear fits
cube.growth <- function( cubic.mod, year ) {
  mod.coef = cubic.mod$coefficients
  slope = mod.coef[2] + (2*mod.coef[3]*year) + (3*mod.coef[4]*(year^2))
  slope = exp(slope)
  return(slope)
}


## ******************************************************************** ##
## Set some study specific values
## ******************************************************************** ##

## First year Frangula alnus was observed in the US
Fral.Herb.FirstYr <- 1879

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

## A few random calcualtions looking at the effect of 
## latitude on area contained in a grid cell
# Minimum distance for longitude
dist.lon(48)
# Maximum distance for longitude
dist.lon(38)
# Minimum area for 5 minute grid cells
(dist.lon(48)/60)*5 * (111/60)*5
# Maximum area for 5 minute grid cells
(dist.lon(38)/60)*5 * (111/60)*5

## ******************************************************************** ##
## Load in Data
## ******************************************************************** ##

## Frangula alnus manually assembled herbarium records dataset
## -----------------------------------------------------------
## These data have been collected and collated over several years
## and the most recent database of herbarium records can be found in
## '/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3/...
##   data/FRAL_HERB_Compiled.csv'
##
## The file 'Herb-F-alnus-Compiled_ORIG.csv' has the original 'hand compiled'
## dataset, before cleaning done in 'herb_data_prep.Rmd'
##
## The methods I used to collect the records is currently detailed
## in my thesis - Chapter 3.
FRAL.Herb <- read.csv('data/FRAL_HERB_Compiled.csv',as.is=TRUE)
## Remove any records marked for exclusion
if( length(which(FRAL.Herb$Remove==1)) > 0 ){
  FRAL.Herb <- FRAL.Herb[ -which(FRAL.Herb$Remove==1), ]
}

## Create a table to determine the different Herbarium sources
table(FRAL.Herb$HerbariumCode)
## Write this a csv file to easily make it into a table for my paper
## NOTE: Commented out so it is not remade each run through the code
# write.csv(table(FRAL.Herb$HerbariumCode),
#           'data/TABLE_FRAL_Herb_Records_by_Code.csv',
#           row.names=FALSE,
#           quote=FALSE)
# #table(FRAL.Herb$Source) ## This one is messy!

## FRAL GBIF Records
## -----------------
## I previously compiled FRAL records from GBIF alone, and was using these
## as a comparison to the records for the group of associated species from
## GBIF
FRAL.GBIF <- read.csv('data/GBIF.FRAL.csv',as.is=TRUE)

## Group of Associated Plants 
## --------------------------
## To account for effects of potential uneven sampling effort
## of *Frangula alnus* I collected presence records for other 
## plants that grow in similar ecological conditions.
## 
## List of associated plants:
## * Speckled Alder = Alnus rugosa
## * Grey Alder = Alnus incana 
## * Smooth Alder = Alnus serrulata
## * Alder (Alderleaf) Buckthorn = Rhamnus alnifolia
## * White Ash = Fraxinus americana 
## * Witch Hazel = Hamamelis virginica (syn. macrophylla)
##
## These records were acquired using GBIF and a number of herbarium
## online databases. The process of construcing this dataset
## is documented in 'herb_data_prep.Rmd'

Associated.Spec <- read.csv('data/Associated_Spec_Compiled.csv', as.is=TRUE)
# Remove any records that do not have a collection year
if ( length(which(is.na(Associated.Spec$CollectionYear))) > 0 ){
  Associated.Spec <- Associated.Spec[-which(is.na(Associated.Spec$CollectionYear)),]
}
## Remove any records marked for exclusion
if( length(which(Associated.Spec$Remove==1)) > 0 ){
  Associated.Spec <- Associated.Spec[ -which(Associated.Spec$Remove==1), ]
}
## A little further cleaning of Admin2 is necessary here
Associated.Spec$Admin2 <-
  sub(pattern=" Co\\..*",replacement="",Associated.Spec$Admin2)
Associated.Spec$Admin2 <- 
  sub(pattern=" \\(.*",replacement="",Associated.Spec$Admin2)
Associated.Spec$Admin2 <-
  sub(pattern="Saint ",replacement="St. ",Associated.Spec$Admin2)

## ******************************************************************** ##
## Assign Grid cell IDs to records:
## For each data set, overlay grid shape files and get point 
## grid memberships
## ******************************************************************** ##

## Read in the Grid Files, which were created in Quantum GIS
## using the following procedure:
## Vector -> Research Tools -> Vector Grid
##   Parameter values used: 
##   30ArcMin = 0.5,0.5
##   5ArcMin = 0.08333333,0.08333333
##
Grid.30ArcMin <- readOGR(dsn="/Users/maiellolammens/Dropbox/gis_layers_local/FRAL_US_Grids/grid_30arcmin.shp",
                         layer="grid_30arcmin")
Grid.5ArcMin <- readOGR(dsn="/Users/maiellolammens/Dropbox/gis_layers_local/FRAL_US_Grids/grid_5arcmin.shp",
                        layer="grid_5arcmin")
GridProjection <- proj4string(Grid.5ArcMin)
## Set the Grid.Layer - this is so I can set the layer to use here
## and easily change it and re-run the code that follows
Grid.Layer <- Grid.5ArcMin
## *******************************************************

## Assign Grid IDs to FRAL.Herb data.frame
## ---------------------------------------
## Make a spatial object with herbarium points
FRAL.Herb.pts <- SpatialPoints( cbind( FRAL.Herb$Longitude, FRAL.Herb$Latitude ) )
## Assign the GridProjection as the projection layer
proj4string(FRAL.Herb.pts) <- GridProjection
GridOverlay.Fral.Herb <- over(x=FRAL.Herb.pts,y=Grid.Layer)
## Get Grid cell values for the 30 arc minute grid
GridOverlay.Fral.Herb.30arcmin <- over(x=FRAL.Herb.pts,y=Grid.30ArcMin)
## Add the Grid cell IDs to the FRAL.Herb data.frame 
FRAL.Herb$GridID <- GridOverlay.Fral.Herb$ID
FRAL.Herb$GridID.30arcmin <- GridOverlay.Fral.Herb.30arcmin$ID
## Now clean the locations that have NA for grid cell ids
if( length(which(is.na(FRAL.Herb$GridID.30arcmin))) > 0 ) {
  FRAL.Herb <- FRAL.Herb[ -which(is.na(FRAL.Herb$GridID.30arcmin)), ]
}
## Clean up
rm( FRAL.Herb.pts, GridOverlay.Fral.Herb, GridOverlay.Fral.Herb.30arcmin )

## Assign Grid IDs to FRAL.GBIF data.frame
## ---------------------------------------
## Make a spatial object with FRAL GBIF points
FRAL.GBIF.pts <- SpatialPoints( cbind( FRAL.GBIF$lon, FRAL.GBIF$lat ) )
## Assign the GridProjection as the projection layer
proj4string(FRAL.GBIF.pts) <- GridProjection
GridOverlay.FRAL.GBIF <- over(x=FRAL.GBIF.pts,y=Grid.Layer)
## Get Grid cell values for the 30 arc minute grid
GridOverlay.FRAL.GBIF.30arcmin <- over(x=FRAL.GBIF.pts,y=Grid.30ArcMin)
## Add the Grid cell IDs to the FRAL.GBIF data.frame 
FRAL.GBIF$GridID <- GridOverlay.FRAL.GBIF$ID
FRAL.GBIF$GridID.30arcmin <- GridOverlay.FRAL.GBIF.30arcmin$ID
## Now clean the locations that have NA for grid cell ids
if( length(which(is.na(FRAL.GBIF$GridID.30arcmin))) > 0 ) {
  FRAL.GBIF <- FRAL.GBIF[ -which(is.na(FRAL.GBIF$GridID.30arcmin)), ]
}
## Clean up
rm( FRAL.GBIF.pts, GridOverlay.FRAL.GBIF, GridOverlay.FRAL.GBIF.30arcmin )

## Assign Grid IDs to Associated.Spec data.frame
## ---------------------------------------------
## Make a spatial object with associated species points
Associated.Spec.pts <- SpatialPoints( cbind( Associated.Spec$Longitude, Associated.Spec$Latitude ) )
## Assign the GridProjection as the projection layer
proj4string(Associated.Spec.pts) <- GridProjection
GridOverlay.Associated.Spec <- over(x=Associated.Spec.pts,y=Grid.Layer)
## Get Grid cell values for the 30 arc minute grid
GridOverlay.Associated.Spec.30arcmin <- over(x=Associated.Spec.pts,y=Grid.30ArcMin)
## Add the Grid cell IDs to the Associated.Spec data.frame 
Associated.Spec$GridID <- GridOverlay.Associated.Spec$ID
Associated.Spec$GridID.30arcmin <- GridOverlay.Associated.Spec.30arcmin$ID
## Now clean the locations that have NA for grid cell ids
if( length(which(is.na(Associated.Spec$GridID.30arcmin))) > 0 ) {
  Associated.Spec <- Associated.Spec[ -which(is.na(Associated.Spec$GridID.30arcmin)), ]
}
## Clean up
rm( Associated.Spec.pts, GridOverlay.Associated.Spec, GridOverlay.Associated.Spec.30arcmin )



## ******************************************************************** ##
## Construct reduced datasets for FRAL.Herb and Associated.Spec based
## on the following two criteria:
## 1. Records are georeferenced at a spatial resolution **FINER than County**
## 2. Records are in a 30 arc minute grid cell that contains both FRAL and at
##    least one Associated Spec record over the study period - 1879 to present
## ******************************************************************** ##

## First reduce the data sets to only those that are georeferenced to 
## a spatial resolution finer than County
FRAL.Herb.Loc <- FRAL.Herb[ which(FRAL.Herb$CountyLevelOnly==0), ]
Associated.Spec.Loc <- Associated.Spec[ which(Associated.Spec$CountyLevelOnly==0), ]

## Next make reduced data sets to look at only locations for FRAL and 
## Associates that fall within the same 30 arc minute grid cell at 
## some point during the study period
FRAL.Herb.Assoc.Spec.Overlap <- 
  intersect(Associated.Spec.Loc$GridID.30arcmin,FRAL.Herb.Loc$GridID.30arcmin)

## Make a reduced FRAL.Herb.Loc dataset that only includes the overlapped 30 arcmin cells
FRAL.Herb.Loc.Overlap <- 
  FRAL.Herb.Loc[ which(!is.na(match(FRAL.Herb.Loc$GridID.30arcmin,FRAL.Herb.Assoc.Spec.Overlap))), ]
## Make a reduced Associated.Spec.Loc dataset that only includes the overlapped 30 arcmin cells
Associated.Spec.Loc.Overlap <-
  Associated.Spec.Loc[ which(!is.na(match(Associated.Spec.Loc$GridID.30arcmin,FRAL.Herb.Assoc.Spec.Overlap))), ]

## Calculate the cumulative number of occupied grid cells through time
FRAL.Herb.Loc.Overlap_Cumm.Grid <- 
  make.cummgrids.allYrs( make.cummgrids.dfYrs( FRAL.Herb.Loc.Overlap ))
Associated.Spec.Loc.Overlap_Cumm.Grid <-
  make.cummgrids.allYrs( make.cummgrids.dfYrs( Associated.Spec.Loc.Overlap ))



# ## ----------------------------------------------------------- ##
# ## Calculate regressions using **Log** cumulative occupied grid cells
# ## 2018-04-17: Commented out, because this analysis is supported by 
# ## expansion theory. 
# ## ----------------------------------------------------------- ##
# ## Linear regression on Cummulativie Occupied Grid Cell numbers
# ## -- This allow for one way to calculate growth rates. I use a 
# ## -- second method below as well.
# 
# ## Perform a simple linear regression on the Cumulative grid cell curves Lines
# fral.lm <- lm( log(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids)~
#                  FRAL.Herb.Loc.Overlap_Cumm.Grid$Years )
# assoc.lm <- lm( log(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids)~
#                   Associated.Spec.Loc.Overlap_Cumm.Grid$Years )
# 
# ## Try a polynomial regression for these data
# # Fral.Herb
# fral.lm2 <- lm( log(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids)~
#                   FRAL.Herb.Loc.Overlap_Cumm.Grid$Years + 
#                   I(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years^2) )
# x.fh <- seq(min(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
#             max(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
#             l=length(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years) )
# # Assoc
# assoc.lm2 <- lm( log(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids)~
#                   Associated.Spec.Loc.Overlap_Cumm.Grid$Years +
#                   I(Associated.Spec.Loc.Overlap_Cumm.Grid$Years^2) )
# x <- seq(min(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
#          max(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
#          l=length(Associated.Spec.Loc.Overlap_Cumm.Grid$Years) )
# ## Is the more complicate model signficantly better?
# anova(assoc.lm,assoc.lm2) # YES
# anova(fral.lm,fral.lm2) # YES
# 
# # Cubic?
# fral.lm3 <- lm( log(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids)~
#                   FRAL.Herb.Loc.Overlap_Cumm.Grid$Years + 
#                   I(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years^2) +
#                   I(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years^3) )
# assoc.lm3 <- lm( log(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids)~
#                    Associated.Spec.Loc.Overlap_Cumm.Grid$Years +
#                    I(Associated.Spec.Loc.Overlap_Cumm.Grid$Years^2) +
#                    I(Associated.Spec.Loc.Overlap_Cumm.Grid$Years^3) )
# # Significant?
# anova(assoc.lm2,assoc.lm3) # YES
# anova(fral.lm2,fral.lm3) # YES
# 
# ## NOTE: I calculate the interpreted growth rates below, **after** I merge
# ## the two datasets.

## ----------------------------------------------------------- ##
## Calculated using **Sqrt** cumulative occupied grid cells
## ----------------------------------------------------------- ##
## Linear regression on Cummulativie Occupied Grid Cell numbers
## -- This allow for one way to calculate growth rates. I use a 
## -- second method below as well.

## Perform a simple linear regression on the Cumulative grid cell curves Lines
fral.lm.sqrt <- lm( sqrt(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids)~
                 FRAL.Herb.Loc.Overlap_Cumm.Grid$Years )
assoc.lm.sqrt <- lm( sqrt(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids)~
                  Associated.Spec.Loc.Overlap_Cumm.Grid$Years )

## Try a polynomial regression for these data
# Fral.Herb
fral.lm2.sqrt <- lm( sqrt(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids)~
                  FRAL.Herb.Loc.Overlap_Cumm.Grid$Years + 
                  I(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years^2) )
x.fh <- seq(min(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
            max(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
            l=length(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years) )
# Assoc
assoc.lm2.sqrt <- lm( sqrt(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids)~
                  Associated.Spec.Loc.Overlap_Cumm.Grid$Years +
                  I(Associated.Spec.Loc.Overlap_Cumm.Grid$Years^2) )
x <- seq(min(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
         max(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
         l=length(Associated.Spec.Loc.Overlap_Cumm.Grid$Years) )
## Is the more complicate model signficantly better?
anova(assoc.lm.sqrt,assoc.lm2.sqrt) # YES
anova(fral.lm.sqrt,fral.lm2.sqrt) # YES

# Cubic?
fral.lm3.sqrt <- lm( sqrt(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids)~
                  FRAL.Herb.Loc.Overlap_Cumm.Grid$Years + 
                  I(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years^2) +
                  I(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years^3) )
assoc.lm3.sqrt <- lm( sqrt(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids)~
                   Associated.Spec.Loc.Overlap_Cumm.Grid$Years +
                   I(Associated.Spec.Loc.Overlap_Cumm.Grid$Years^2) +
                   I(Associated.Spec.Loc.Overlap_Cumm.Grid$Years^3) )
# Significant?
anova(assoc.lm2.sqrt,assoc.lm3.sqrt) # YES
anova(fral.lm2.sqrt,fral.lm3.sqrt) # NO

## Print summary information to the console
summary(fral.lm2.sqrt)
summary(assoc.lm3.sqrt)

## Write a function to calculate 'annual' slope values for the cubic linear fits
cube.growth.sqrt <- function( cubic.mod, year ) {
  mod.coef = cubic.mod$coefficients
  slope = mod.coef[2] + (2*mod.coef[3]*year) + (3*mod.coef[4]*(year^2))
  slope = slope^2
  return(slope)
}
## Write a function to calculate 'annual' slope values for the quadratic linear fits
quad.growth.sqrt <- function( quad.mod, year ) {
  mod.coef = quad.mod$coefficients
  slope = mod.coef[2] + (2*mod.coef[3]*year)
  slope = slope^2
  return(slope)
}
## NOTE: I calculate the interpreted growth rates below, **after** I merge
## the two datasets.
## ----------------------------------------------------------- ##

## Merge the datasets for Fral and ALL based on overlapping years
# --this merge results in columns with names OccGrids.x and
# --OccGrids.y, so I rename the columns
FRAL.Herb.Assoc.allYrs.Overlap <-
  merge( FRAL.Herb.Loc.Overlap_Cumm.Grid, Associated.Spec.Loc.Overlap_Cumm.Grid, by="Years")
names(FRAL.Herb.Assoc.allYrs.Overlap) <- c('Years','FRAL.OccGrids','Assoc.OccGrids')
## Calcualte ratio of area (sensu Delisle et al 2003)
FRAL.Herb.Assoc.allYrs.Overlap$AOO.Ratio <-
  FRAL.Herb.Assoc.allYrs.Overlap$FRAL.OccGrids / FRAL.Herb.Assoc.allYrs.Overlap$Assoc.OccGrids
## Calculate total grid counts
FRAL.Herb.Assoc.allYrs.Overlap$TotalGrids <-
  FRAL.Herb.Assoc.allYrs.Overlap$FRAL.OccGrids + FRAL.Herb.Assoc.allYrs.Overlap$Assoc.OccGrids

## Now calculate annual 'growth rates' for growth in the number of 
## grid cells occupied
# Get a matrix for number of grids at time point t+1
t.plus.1 <- as.matrix(FRAL.Herb.Assoc.allYrs.Overlap[-1,c('FRAL.OccGrids','Assoc.OccGrids')])
# Get a matrix for number of grids at time point t
t.pres <- as.matrix(FRAL.Herb.Assoc.allYrs.Overlap[-length(FRAL.Herb.Assoc.allYrs.Overlap$Years),
                                                   c('FRAL.OccGrids','Assoc.OccGrids')])
## Calculate annual R values
Cumm.Grid.R <- t.plus.1/t.pres
# Add a first Row of NA values
Cumm.Grid.R <- rbind( rep(NA,2), Cumm.Grid.R )
# Add names to the columns
colnames(Cumm.Grid.R) <- c('Fral.Cumm.Grid.R','Assoc.Cumm.Grid.R')
# Add these columns to teh Grid.Cumm.All data.frame
FRAL.Herb.Assoc.allYrs.Overlap <- 
  data.frame(FRAL.Herb.Assoc.allYrs.Overlap,Cumm.Grid.R)
## Clean up
rm(Cumm.Grid.R,t.plus.1,t.pres)

## Calculate the **difference** in growth rate
# FRAL.Herb.Assoc.allYrs.Overlap$Cumm.Grid.R.Diff <-
#   FRAL.Herb.Assoc.allYrs.Overlap$Fral.Cumm.Grid.R - FRAL.Herb.Assoc.allYrs.Overlap$Assoc.Cumm.Grid.R
FRAL.Herb.Assoc.allYrs.Overlap$Cumm.Grid.R.Diff <-
  FRAL.Herb.Assoc.allYrs.Overlap$Fral.Cumm.Grid.R / FRAL.Herb.Assoc.allYrs.Overlap$Assoc.Cumm.Grid.R

## Calculate the interpreted growth rates for overlapping years
## based on the linear model regression fits
FRAL.growth.fit <- cube.growth.sqrt(cubic.mod=fral.lm3.sqrt,
                               year=FRAL.Herb.Assoc.allYrs.Overlap$Years)
Assoc.growth.fit <- cube.growth.sqrt(cubic.mod=assoc.lm3.sqrt,
                                year=FRAL.Herb.Assoc.allYrs.Overlap$Years)
#Cumm.Grid.growth.Diff.fit <- FRAL.growth.fit - Assoc.growth.fit
Cumm.Grid.growth.Diff.fit <- FRAL.growth.fit / Assoc.growth.fit

## Calculate the 10-year moving average window of R
# First make a reduced dataset that only has values when both
# FRAL and Assoc R is not an NA
Cum.Grid.R <- 
  FRAL.Herb.Assoc.allYrs.Overlap[ which(!is.na(FRAL.Herb.Assoc.allYrs.Overlap$Assoc.Cumm.Grid.R) & 
                                          !is.na(FRAL.Herb.Assoc.allYrs.Overlap$Fral.Cumm.Grid.R)), ]
# For FRAL this will start in 1881
Cum.Grid.Fral.MA <- rollapply(data=Cum.Grid.R$Fral.Cumm.Grid.R,width=10,align='center',FUN=geometric.mean)
Cum.Grid.Assoc.MA <- rollapply(data=Cum.Grid.R$Assoc.Cumm.Grid.R,width=10,align='center',FUN=geometric.mean)
Cum.Grid.R.Diff <- Cum.Grid.Fral.MA/Cum.Grid.Assoc.MA




## ******************************************************************** ##
## Construct reduced datasets for FRAL.Herb and Associated.Spec based
## on the following two criteria:
## 1. Records are georeferenced at a spatial resolution of AT LEAST the **County**
## 2. Records occure in a **county** that contains both FRAL and at
##    least one Associated Spec record over the study period - 1879 to present
## ******************************************************************** ##

## Remove records that do not have values for 'Admin2'
# FRAL.Herb
FRAL.Herb.Cnty <- FRAL.Herb
if ( length(which(FRAL.Herb.Cnty$Admin2=='')) > 0 ){
  FRAL.Herb.Cnty <- FRAL.Herb.Cnty[ -which(FRAL.Herb.Cnty$Admin2==''), ]
}
if ( length(which(is.na(FRAL.Herb.Cnty$Admin2))) > 0 ){
  FRAL.Herb.Cnty <- FRAL.Herb.Cnty[ -which(is.na(FRAL.Herb.Cnty$Admin2)), ]
}
# FRAL.GBIF
FRAL.GBIF.Cnty <- FRAL.GBIF
if ( length(which(FRAL.GBIF.Cnty$adm2=='')) > 0 ){
  FRAL.GBIF.Cnty <- FRAL.GBIF.Cnty[ -which(FRAL.GBIF.Cnty$adm2==''), ]
}
if ( length(which(is.na(FRAL.GBIF.Cnty$adm2))) > 0 ){
  FRAL.GBIF.Cnty <- FRAL.GBIF.Cnty[ -which(is.na(FRAL.GBIF.Cnty$adm2)), ]
}
# Associated.Spec
Associated.Spec.Cnty <- Associated.Spec
if ( length(which(Associated.Spec.Cnty$Admin2=='')) > 0 ){
  Associated.Spec.Cnty <- Associated.Spec.Cnty[ -which(Associated.Spec.Cnty$Admin2==''), ]
}
if ( length(which(is.na(Associated.Spec.Cnty$Admin2))) > 0 ){
  Associated.Spec.Cnty <- Associated.Spec.Cnty[ -which(is.na(Associated.Spec.Cnty$Admin2)), ]
}

## Make reduced datasets to look at only records that are reported
## from counties that have had both FRAL and Associated Species at some
## time during the study period
FRAL.Herb.Assoc.Spec.Cnty.Overlap <-
  intersect(paste(FRAL.Herb.Cnty$Admin1,FRAL.Herb.Cnty$Admin2),
            paste(Associated.Spec.Cnty$Admin1,Associated.Spec.Cnty$Admin2))

## Preliminary results notes
# Unique Counties for Associated Species
length(unique(Associated.Spec.Cnty$Admin2)) # 470
# Unique Counties for FRAL 
length(unique(FRAL.Herb.Cnty$Admin2)) # 195
# Length of overlapping counties
length(intersect(FRAL.Herb.Cnty$Admin2,Associated.Spec.Cnty$Admin2)) # 175
## Looking at these numbers, it's clear that I have a much greater
## representation of the associated species (spatially) than FRAL.
## I'm also happy to see that I only lose 31 counties by restricting
## my results to overlapping counties. However, this is only an rough
## approximation of this, since some states have counties with the same
## name. I do make sure to account for this in the subsequent analysis.

## Make a reduced FRAL.Herb.Loc dataset that only includes the overlapped 30 arcmin cells
FRAL.Herb.Cnty.Overlap <- 
  FRAL.Herb.Cnty[ which(!is.na(match(paste(FRAL.Herb.Cnty$Admin1,FRAL.Herb.Cnty$Admin2),
                                     FRAL.Herb.Assoc.Spec.Cnty.Overlap))), ]
## Make a reduced Associated.Spec.Loc dataset that only includes the overlapped 30 arcmin cells
Associated.Spec.Cnty.Overlap <-
  Associated.Spec.Cnty[ which(!is.na(match(paste(Associated.Spec.Cnty$Admin1,Associated.Spec.Cnty$Admin2),
                                           FRAL.Herb.Assoc.Spec.Cnty.Overlap))), ]

## Determine the first year each county was classified as occupied
FRAL.Herb.Cnty.YrFrstOcc <- ddply(.data=FRAL.Herb.Cnty.Overlap,
                                  .variable=c('Admin1','Admin2'),
                                  YrFrstOcc=min(CollectionYear),
                                  summarize)
Associated.Spec.Cnty.YrFrstOcc <- ddply(.data=Associated.Spec.Cnty.Overlap,
                                        .variable=c('Admin1','Admin2'),
                                        YrFrstOcc=min(CollectionYear),
                                        summarize)

## Calculate the number of years FRAL was detected in a county AFTER the first 
## associated species was detected
FRAL.Delay <- FRAL.Herb.Cnty.YrFrstOcc$YrFrstOcc-Associated.Spec.Cnty.YrFrstOcc$YrFrstOcc
## What's the mean and median delay?
mean(FRAL.Delay) # 48+ years
median(FRAL.Delay) # 52 years
## How many counties have FRAL before an Associate species?
length(which(FRAL.Delay<0)) # 28 Counties
## Which counties are they?
FRAL.Herb.Cnty.YrFrstOcc$Admin2[which(FRAL.Delay<0)]

## Perform a t-test to see if the difference is significant
t.test(Associated.Spec.Cnty.YrFrstOcc$YrFrstOcc,FRAL.Herb.Cnty.YrFrstOcc$YrFrstOcc,paired=T)



## Calculate the cumulative number of **Counties** Occupied
FRAL.Herb.Cnty.Overlap_Cumm.Cnty <- 
  make.cummCntys.allYrs( make.cummCntys.dfYrs(cnty.df=FRAL.Herb.Cnty.Overlap) )
Associated.Spec.Cnty.Overlap_Cumm.Cnty <-
  make.cummCntys.allYrs( make.cummCntys.dfYrs(cnty.df=Associated.Spec.Cnty.Overlap) )


## ******************************************************************** ##
## Peform regression analyses on county data
## ******************************************************************** ##

## Linear Regression
fral.cnt.lm <- lm( sqrt(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties) ~
                     FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years )   
assoc.cnt.lm <- lm( sqrt(Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties) ~
                      Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years )

## Polynomial regression
fral.cnt.lm2 <- lm( sqrt(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties) ~
                      FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years + 
                      I(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years^2) 
                    )   
assoc.cnt.lm2 <- lm( sqrt(Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties) ~
                       Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years +
                       I(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years^2)
                     )
fral.cnt.lm3 <- lm( sqrt(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties) ~
                      FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years + 
                      I(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years^2) +
                      I(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years^3)
)   
assoc.cnt.lm3 <- lm( sqrt(Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties) ~
                       Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years +
                       I(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years^2) +
                       I(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years^3)
)

## Use likelihood ratio test to see which models are best
anova(fral.cnt.lm,fral.cnt.lm2) # YES
anova(fral.cnt.lm2,fral.cnt.lm3) # YES
anova(assoc.cnt.lm,assoc.cnt.lm2) # YES
anova(assoc.cnt.lm2,assoc.cnt.lm3) # YES

## Print summary of best fit models
summary(fral.cnt.lm3)
summary(assoc.cnt.lm3)


## ************************************************************************** ##
## Merge the datasets for FRAL and Associated Species based on 
## overlapping years
Cumm.Cnty.Combined.df <- 
  merge( FRAL.Herb.Cnty.Overlap_Cumm.Cnty, Associated.Spec.Cnty.Overlap_Cumm.Cnty, by="Years" )
names(Cumm.Cnty.Combined.df) <- c('Years','FRAL.OccCnty','Assoc.OccCnty')

## Calcualte ratio of area (i.e. counties) (sensu Delisle et al 2003)
Cumm.Cnty.Combined.df$AOO.Ratio <-
  Cumm.Cnty.Combined.df$FRAL.OccCnty / Cumm.Cnty.Combined.df$Assoc.OccCnty
## Calculate total County counts
Cumm.Cnty.Combined.df$TotalCnty <-
  Cumm.Cnty.Combined.df$FRAL.OccCnty + Cumm.Cnty.Combined.df$Assoc.OccCnty

## Now calculate annual 'growth rates' for growth in the number of 
## counties occupied
# Get a matrix for number of counties at time point t+1
t.plus.1 <- as.matrix(Cumm.Cnty.Combined.df[-1,c('FRAL.OccCnty','Assoc.OccCnty')])
# Get a matrix for number of grids at time point t
t.pres <- as.matrix(Cumm.Cnty.Combined.df[-length(Cumm.Cnty.Combined.df$Years),
                                                   c('FRAL.OccCnty','Assoc.OccCnty')])
## Calculate annual R values
Cumm.Cnty.R <- t.plus.1/t.pres
# Add a first Row of NA values
Cumm.Cnty.R <- rbind( rep(NA,2), Cumm.Cnty.R )
# Add names to the columns
colnames(Cumm.Cnty.R) <- c('Fral.Cumm.Cnty.R','Assoc.Cumm.Cnty.R')
# Add these columns to the Cumm.Cnty.Combined.df data.frame
Cumm.Cnty.Combined.df <- 
  data.frame(Cumm.Cnty.Combined.df,Cumm.Cnty.R)
## Clean up
rm(Cumm.Cnty.R,t.plus.1,t.pres)

## Calculate the **difference** in growth rate
#Cumm.Cnty.Combined.df$Cumm.Cnty.R.Diff <-
#  Cumm.Cnty.Combined.df$Fral.Cumm.Cnty.R - Cumm.Cnty.Combined.df$Assoc.Cumm.Cnty.R
Cumm.Cnty.Combined.df$Cumm.Cnty.R.Diff <-
  Cumm.Cnty.Combined.df$Fral.Cumm.Cnty.R / Cumm.Cnty.Combined.df$Assoc.Cumm.Cnty.R

## Calculate the 10-year moving average window of R
# First make a reduced dataset that only has values when both
# FRAL and Assoc R is not an NA
Cum.Cnty.R <- 
  Cumm.Cnty.Combined.df[ which(!is.na(Cumm.Cnty.Combined.df$Assoc.Cumm.Cnty.R) & 
                                 !is.na(Cumm.Cnty.Combined.df$Fral.Cumm.Cnty.R)), ]
# For FRAL this will start in 1880
Cum.Cnty.Fral.MA <- rollapply(data=Cum.Cnty.R$Fral.Cumm.Cnty.R,width=10,align='center',FUN=geometric.mean)
Cum.Cnty.Assoc.MA <- rollapply(data=Cum.Cnty.R$Assoc.Cumm.Cnty.R,width=10,align='center',FUN=geometric.mean)
Cum.Cnty.R.Diff <- Cum.Cnty.Fral.MA/Cum.Cnty.Assoc.MA

## ******************************************************************** ##
## Miscellaneous calculations made to include in the paper
## ******************************************************************** ##

## ID of the earliest FRAL record
FRAL.Herb[which(FRAL.Herb$CollectionYear==min(FRAL.Herb$CollectionYear)),]

## ID of the earliest Associate reocord
Associated.Spec[which(Associated.Spec$CollectionYear==min(Associated.Spec$CollectionYear)),]
## and the year for this record
min(Associated.Spec$CollectionYear)

## Total number of Associated records collected before the first FRAL records was collected
length(which(Associated.Spec$CollectionYear<min(FRAL.Herb$CollectionYear)))
## Percentage of records collected by this time
length(which(Associated.Spec$CollectionYear<min(FRAL.Herb$CollectionYear))) / nrow(Associated.Spec) * 100
## Total number of Associated Records collected before 1900
length(which(Associated.Spec$CollectionYear<1900))
## Total number of Associated Records collected before 1920
length(which(Associated.Spec$CollectionYear<1920))

## Total number of FRAL Records collected before 1900
length(which(FRAL.Herb$CollectionYear<1900))
## Total number of FRAL Records collected before 1920
length(which(FRAL.Herb$CollectionYear<1920))





## ******************************************************************** ##
## Look at the cumulative number of **RECORDS** through time **WITHOUT ANY
## SPATIAL BASED FILTERING
## ******************************************************************** ##

# Remove records from the three Herbaria that I was not able to get
# associated species records from: CHRB, CM, MU
FRAL.Herb.limited <- subset(FRAL.Herb,
                            subset=(FRAL.Herb$HerbariumCode!='CHRB' & FRAL.Herb$HerbariumCode!='CM' & FRAL.Herb$HerbariumCode!='MU') )
# FRAL Herb
FRAL.Herb.Cumm.Records <- ddply(.data=FRAL.Herb.limited,.variables='CollectionYear',
                                Annual.Recs=length(CollectionYear),summarize)
FRAL.Herb.Cumm.Records$Cumm.Recs <- cumsum(FRAL.Herb.Cumm.Records$Annual.Recs)
FRAL.Herb.Cumm.Records.allYrs <- make.cummrecs.allYrs(FRAL.Herb.Cumm.Records)
# Associated Species
Assoc.Cumm.Records <- ddply(.data=Associated.Spec,.variables='CollectionYear',
                               Annual.Recs=length(CollectionYear),summarize)
Assoc.Cumm.Records$Cumm.Recs <- cumsum(Assoc.Cumm.Records$Annual.Recs)
Assoc.Cumm.Records.allYrs <- make.cummrecs.allYrs(Assoc.Cumm.Records)

## Make one large data.frame that has all of the cumulative record information
Records.Cumm.All <- Assoc.Cumm.Records.allYrs
names(Records.Cumm.All) <- c('Years','CummRec.Assoc')
Records.Cumm.All$CummRec.Fral.Herb <- NA
Records.Cumm.All$CummRec.Fral.Herb[match(FRAL.Herb.Cumm.Records.allYrs$Years,Assoc.Cumm.Records.allYrs$Years)] <-
  FRAL.Herb.Cumm.Records.allYrs$CummRecs

## Linear and polynomial regression on Cummulative Number of Records
fral.rec.lm <- lm( log(Records.Cumm.All$CummRec.Fral.Herb) ~
                     Records.Cumm.All$Years )
assoc.rec.lm <- lm( log(Records.Cumm.All$CummRec.Assoc) ~
                      Records.Cumm.All$Years)
fral.rec.lm2 <- lm( log(Records.Cumm.All$CummRec.Fral.Herb) ~
                      Records.Cumm.All$Years +
                      I(Records.Cumm.All$Years^2) )
assoc.rec.lm2 <- lm( log(Records.Cumm.All$CummRec.Assoc) ~
                       Records.Cumm.All$Years +
                       I(Records.Cumm.All$Years^2) )
fral.rec.lm3 <- lm( log(Records.Cumm.All$CummRec.Fral.Herb) ~
                      Records.Cumm.All$Years +
                      I(Records.Cumm.All$Years^2) +
                      I(Records.Cumm.All$Years^3) )
assoc.rec.lm3 <- lm( log(Records.Cumm.All$CummRec.Assoc) ~
                       Records.Cumm.All$Years +
                       I(Records.Cumm.All$Years^2) +
                       I(Records.Cumm.All$Years^3) )
x <- seq( min(Records.Cumm.All$Years),
          max(Records.Cumm.All$Years),
          l=length(Records.Cumm.All$Years) )

## Model Comparisons
anova(fral.rec.lm,fral.rec.lm2) # LM2
anova(assoc.rec.lm,assoc.rec.lm2) # LM2
anova(fral.rec.lm2,fral.rec.lm3) # LM3
anova(assoc.rec.lm2,assoc.rec.lm3) # LM2

## Print summary info to console
summary(fral.rec.lm3)
summary(assoc.rec.lm2)



##### NOTE - GOT THIS FAR IN MY REDEVELOPMENT

# ## Plot the number of grid cells occupied (AOO) for a given decade, **NOT CUMMULATIVE**.
# ## This is based on a suggestion by Resit.
# Fral.Herb.data$Decade <- round.up(Fral.Herb.data$CollectionYear)
# FRAL.Herb.AOO.ByDecade <- ddply(.data=Fral.Herb.data,
#                                 .variable=c("Decade"),
#                                 AOO.by.Decade=length(unique(GridID)),
#                                 summarize)
# ## Plot the AOO for a given decad, **NOT CUMMULATIVE**.
# ## This is based on a suggestion by Resit.
# GBIF.Data$Decade <- round.up(as.numeric(GBIF.Data$CollectionYear))
# GBIF.Data.AOO.ByDecade <- ddply(.data=GBIF.Data,
#                                 .variable=c("Decade"),
#                                 AOO.by.Decade=length(unique(GridID)),
#                                 summarize)
# ## Plot the AOO for a given decad, **NOT CUMMULATIVE**.
# ## This is based on a suggestion by Resit.
# GBIF.Data.FRAL$Decade <- round.up(as.numeric(GBIF.Data.FRAL$CollectionYear))
# GBIF.FRAL.AOO.ByDecade <- ddply(.data=GBIF.Data.FRAL,
#                                 .variable=c("Decade"),
#                                 AOO.by.Decade=length(unique(GridID)),
#                                 summarize)
# 
# 
# ## ******************************************************************** ##
# ## Plots based on **Non-Cumulative AOO**
# 
# ## Merge FRAL.Herb.AOO.ByDecade with GBIF.Data.AOO.ByDecade
# ## --this merge results in columns with names AOO.by.Decade.x and
# ## --AOO.by.Decade.y
# FRAL.Herb.AOO.ByDecade <- merge(FRAL.Herb.AOO.ByDecade,GBIF.Data.AOO.ByDecade,by="Decade")
# ## Calcualte the ratio of occupied grids in decades
# FRAL.Herb.AOO.ByDecade$Ratio <- 
#   FRAL.Herb.AOO.ByDecade$AOO.by.Decade.x / FRAL.Herb.AOO.ByDecade$AOO.by.Decade.y
# ## And calcualte the total number of records reportd for a given decade
# FRAL.Herb.AOO.ByDecade$TotalGrids <-
#   FRAL.Herb.AOO.ByDecade$AOO.by.Decade.x + FRAL.Herb.AOO.ByDecade$AOO.by.Decade.y
# 
# ## ******************************************************************** ##
# ## FIGURE XX - Herb_Fral_to_GBIF_All_ratio_NONCUMMULATIVE.pdf
# pdf(file='figures/Herb_Fral_to_GBIF_All_ratio_NONCUMMULATIVE.pdf',width=10)
# fral.gbif.ratio.noncumm <- ggplot( FRAL.Herb.AOO.ByDecade, aes(x=(Decade*10), y=Ratio, size=TotalGrids) ) +
#   geom_point() +
#   xlab("Decade") +
#   ylab("Ratio of AOO of FRAL to ALL") +
#   labs(size="Occ. Grid Count")
# print(fral.gbif.ratio.noncumm)
# dev.off()
# ## ******************************************************************** ##

