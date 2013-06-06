## ******************************************************************** ##
## ******** BEGIN HYDE PROJECT ANALYSIS - PAST LAND USE EFFECTS ******* ##
## ******************************************************************** ##
##
## Using the Hyde Project Layers (http://themasites.pbl.nl/tridion/en/themasites/hyde/index.html),
## examine if there is any relationship between the decade of first 
## presense observation (as determined by herbarium records) and any land
## use transistion.
##
## ******************************************************************** ##

## Get year of first introduction for each grid cell that is occupied
## using the FRAL Herb dataset 
FRAL.Herb.Grid.Frst.Yr <- ddply(.data=Fral.Herb.data,
                                .variable=c("GridID"),
                                Grid.Frst.Yr=min(CollectionYear),
                                summarize)
## Assign a Decade to each of these grid cells
FRAL.Herb.Grid.Frst.Yr$Decade <- roundUp( FRAL.Herb.Grid.Frst.Yr$Grid.Frst.Yr, 10 )

## Read in the Hyde Layers
hyde.files <- Sys.glob(file.path("/Volumes/Garage/Projects/F-alnus/Herbarium-Spatial-Work/",
                                 "crop*asc"))
HYDE.Layers <- stack(hyde.files)

## Extract crop-land use values for each point
Fral.Herb.Hyde.vals <- extract( HYDE.Layers, 
                                cbind(Fral.Herb.data$Longitude,Fral.Herb.data$Latitude) )
## Find NAs
Fral.Herb.Hyde.vals.NAs <- which(is.na(Fral.Herb.Hyde.vals[,1]))
## Remove rows of NAs
Fral.Herb.Hyde.vals <- Fral.Herb.Hyde.vals[ -Fral.Herb.Hyde.vals.NAs, ]
## Also remove these rows from the main dataset
Fral.Herb.data <- Fral.Herb.data[ -Fral.Herb.Hyde.vals.NAs, ]

## Need to match the decade of first intro to the decade assocated 
## with the hyde layer.

## First lets make a vector representing the decades for each
## column of the Hyde Layer
Hyde.cols <- names(HYDE.Layers)
Hyde.decades <- sub( pattern='crop', replacement='', Hyde.cols )
Hyde.decades <- sub( pattern='AD', replacement='', Hyde.decades )
Hyde.decades <- as.numeric( Hyde.decades )

Hyde.vals <- c()
for ( rec.num in 1:length(FRAL.Herb.Grid.Frst.Yr$GridID) ) {
  Hyde.decade.match <- which( FRAL.Herb.Grid.Frst.Yr$Decade[rec.num]==Hyde.decades )
  Hyde.vals <- c( Hyde.vals, Fral.Herb.Hyde.vals[rec.num,Hyde.decade.match] )
}

Hyde.vals.past <- c()
for ( rec.num in 1:length(FRAL.Herb.Grid.Frst.Yr$GridID) ) {
  Hyde.decade.match <- which( FRAL.Herb.Grid.Frst.Yr$Decade[rec.num]==Hyde.decades )
  Hyde.decade.match.past <- Hyde.decade.match-1
  Hyde.decade.match <- ifelse(test=Hyde.decade.match.past>0,
                              yes=Hyde.decade.match.past,
                              no=Hyde.decade.match )
  Hyde.vals.past <- c( Hyde.vals.past, Fral.Herb.Hyde.vals[rec.num,Hyde.decade.match] )
}


## ******************************************************************** ##
## ****************************************************** ##
## ********* SCRATCH WORK BELOW !!! ********************* ##
## ****************************************************** ##
## ******************************************************************** ##

## Rough work here - used to make edd_fral into a shape file
edd_fral <- read.csv('Downloads/5649.csv')
edd_fral <- edd_fral[ -which(is.na(edd_fral$LONGITUDE_DECIMAL)), ]
sp <- SpatialPoints(cbind(edd_fral$LONGITUDE_DECIMAL,edd_fral$LATITUDE_DECIMAL))
spdf <- SpatialPointsDataFrame( sp, edd_fral )
proj4string(spdf) <- GridProjection
writeOGR( spdf, dsn='data/', layer='edd', driver="ESRI Shapefile")

## Georeferencing work
county.shp <- readOGR(dsn="/Users/mlammens/Dropbox/gis_layers/countyp010.shp",
                      layer="countyp010")

## ------------------------------------------------------ ##
## Development of Principal Components Axis Work
## to look at the ecological niche in time

## Start with the FRAL Herb database, since this has records with
## the highest accuracy of georeferencing
summary(fral.herb)

## Remove any records that have coordinate uncertainty greater
## than 10 km (i.e. 10000 m)
if ( length(which(fral.herb$CoordUncertainty > 10000) ) > 1 ){
  fral.herb.res10km <- fral.herb[ -(which(fral.herb$CoordUncertainty > 10000)), ]
} else {
  fral.herb.res10km <- fral.herb
}
## Calculate the Decade each data point was collect during
fral.herb.res10km$Decade <- roundUp(fral.herb.res10km$CollectionYear, 10)

## Read in the Environmental Layers
# Bioclim layers to use
# Bio4 - Temperature seasonality
# Bio5 - Max temperature of the warmest month
# Bio6 - Min temperature of the coldest month
# Bio12 - Annual precipitation
# Bio15 - Precipitation seasonality
# Bio18 - Precipitation of the warmest quarter
# Bio19 - Precipitation of the coldest quarter
# Get all the asc files used in this analysis
env.files <- list.files( path='/Volumes/Garage/Projects/F-alnus/NicheModel-Work/Environ_Layers/', 
                         pattern='asc$', full.names=TRUE )
# Remove Landcover, hydro, and NDVI from this layer
env.files <- env.files[1:19]
env.layers <- stack(env.files)
names( env.layers )

# Get environmental values for each of these points
fral.herb.env.vals <- extract( env.layers, cbind(fral.herb.res10km$Longitude,fral.herb.res10km$Latitude) )
# Clean NAs
fral.herb.env.vals <- fral.herb.env.vals[ -which(is.na(fral.herb.env.vals[,1])), ]
# Standardize these data


## Perform principle components analysis on this new environmental data
fral.herb.pca <- prcomp( fral.herb.env.vals )
summary(fral.herb.pca)
fral.herb.pca$rotation
biplot(fral.herb.pca)
