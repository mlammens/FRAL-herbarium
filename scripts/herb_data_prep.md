Herbarium Data Collection and Preperation
========================================================

## Key components of this file

* In this script I am documenting the acquisition and filteing of
records for the group of associated species 
that will be used in the cummulative record analysis

* Data cleaning for the previously collated historical presence 
records for *Frangula alnus*. Record collection is documented in Chapter 3
of my PhD dissertation.

* In this script I assigne Long/Lat values to Counties for records
that were not georeferenced to the highest resolution possible. These records
are mostly those in the **group of associated species** and **FRAL** records
collected from Ohio State University Herbarium and University of Minnesota 
Herbarium. The **FRAL** records that were not georeferenced are records that I 
was only able to aquire recently.


## Define the group of asscocated species

First I had to define a group of associated species. I did this be
selecting a number of plants that have similar ecological requirements
as Glossy buckthorn and/or have been compared to GB in previous analyses

### Associated Species

* Speckled Alder = Alnus rugosa
* Grey Alder = Alnus incana 
* Smooth Alder = Alnus serrulata
* Alder (Alderleaf) Buckthorn = Rhamnus alnifolia
* White Ash = Fraxinus americana 
* Witch Hazel = Hamamelis virginiana 
* Withc Hazel (syn) = Hamamelis macrophylla

***
## GBIF Records 

First, I'm going to aquire all the records that I can from GBIF. Because
of the way I am doing this, by collecting data from a specific spatial extent,
I am only getting recordst that have **Latitude** and **Longitude** values.
Thus, these records **DO NOT** have to be georeferenced to the county level.
However, I do have to make sure that they all have county names for a later
analysis.

### Preliminaries: Load the required packages and set a few parameters

R code disabled
```
## Required Packages
## -----------------
require(dismo)
require(maptools)
gpclibPermit()
require(rgdal)
require(ggplot2)
require(sp)
require(PBSmapping)
require(plyr)
require(maps)
require(psych)
require(reshape)

## Define and set working directory
HERB_PROJECT_DIR <- '/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/'
setwd( HERB_PROJECT_DIR )

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

```

### Use `gbif` function to get records

R code disabled
```
## I'm also going to get the data in 'gbif' for Frangula alnus. Note that
## I have already done this and included it in the data set just read in,
## however, that dataset also includes a lot of data **not** in 'gbif', so
## I think this may be a better data set to compare with.

## Get Frangula alnus records (Glossy Buckthorn)
Frangula.alnus <- gbif( genus="Frangula", species="alnus*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Frangula.alnus$collection=="USDA Plants")) > 0 ) {
  Frangula.alnus <- Frangula.alnus[ -(which(Frangula.alnus$collection=="USDA Plants")), ]
}

Rhamnus.frangula <- gbif( genus="Rhamnus", species="frangula*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Rhamnus.frangula$collection=="USDA Plants")) > 0 ) {
  Rhamnus.frangula <- Rhamnus.frangula[ -(which(Rhamnus.frangula$collection=="USDA Plants")), ]
}

## Associated plants data
## ----------------------
## To account for effects of potential uneven sampling effort
## of *Frangula alnus* I am collecting presence records for other 
## plants that grow in similar ecological conditions.
## 
## Get Alnus incana records
Alnus.incana <- gbif( genus="Alnus", species="incana*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Alnus.incana$collection=="USDA Plants")) > 0 ) {
  Alnus.incana <- Alnus.incana[ -(which(Alnus.incana$collection=="USDA Plants")), ]
}

## Get Alnus incana records
Alnus.rugosa <- gbif( genus="Alnus", species="rugosa*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Alnus.rugosa$collection=="USDA Plants")) > 0 ) {
  Alnus.rugosa <- Alnus.rugosa[ -(which(Alnus.rugosa$collection=="USDA Plants")), ]
}

## Get Alnus serrulata records
Alnus.serrulata <- gbif( genus="Alnus", species="serrulata*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Alnus.serrulata$collection=="USDA Plants")) > 0 ) {
  Alnus.serrulata <- Alnus.serrulata[ -(which(Alnus.serrulata$collection=="USDA Plants")), ]
}

## Get Rhamnus incana records
Rhamnus.alnifolia <- gbif( genus="Rhamnus", species="alnifolia*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Rhamnus.alnifolia$collection=="USDA Plants")) > 0 ) {
  Rhamnus.alnifolia <- Rhamnus.alnifolia[ -(which(Rhamnus.alnifolia$collection=="USDA Plants")), ]
}

## Get Hamamelis virginiana records (Witch Hazel)
Hamamelis.virginiana <- gbif( genus="Hamamelis", species="virginiana*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Hamamelis.virginiana$collection=="USDA Plants")) > 0 ) {
  Hamamelis.virginiana <- Hamamelis.virginiana[ -(which(Hamamelis.virginiana$collection=="USDA Plants")), ]
}

## Get Hamamelis macrophylla records (Witch Hazel - synonym)
Hamamelis.macrophylla <- gbif( genus="Hamamelis", species="macrophylla*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Hamamelis.macrophylla$collection=="USDA Plants")) > 0 ) {
  Hamamelis.macrophylla <- Hamamelis.macrophylla[ -(which(Hamamelis.macrophylla$collection=="USDA Plants")), ]
}

## Get Fraxinus americana records (White Ash)
Fraxinus.americana <- gbif( genus="Fraxinus", species="americana*", ext=falnus.extent )
## Remove any records associated with the USDA Plants data
if ( length(which(Fraxinus.americana$collection=="USDA Plants")) > 0 ) {
  Fraxinus.americana <- Fraxinus.americana[ -(which(Fraxinus.americana$collection=="USDA Plants")), ]
}

## Pulling together all GBIF data together into one data.frame
GBIF.Data <- rbind( Alnus.incana,
                    Alnus.rugosa,
                    Alnus.serrulata,
                    Fraxinus.americana,
                    Hamamelis.macrophylla,
                    Hamamelis.virginiana,
                    Rhamnus.alnifolia,
                    ## Also add Frangula data
                    Rhamnus.frangula,
                    Frangula.alnus
)

## Save a backup copy of the GBIF data
GBIF.Data.bkup <- GBIF.Data

```

As of 2013-05-15, there was a record in the GBIF dataset that had a 
inaccurate date, which has to be removed.

R code disabled
```
## Have to remove a point in the GBIF data in which the date information
## is incorrect - year is listed as 2803
GBIF.remove <- grep(pattern="*2803*",x=GBIF.Data$earliestDateCollected)
GBIF.Data <- GBIF.Data[-GBIF.remove,]
```

### Seperate out date information

R code disabled
```
## First remove records without data information
if ( length(which(is.na(GBIF.Data$earliestDateCollected))) ){
  GBIF.Data <- GBIF.Data[-(which(is.na(GBIF.Data$earliestDateCollected))), ]
}
## Next, get the date information
GBIF.date <- GBIF.Data$earliestDateCollected
GBIF.date <- t(sapply(GBIF.date,function(x) {unlist(strsplit(x=x,split="-"))}))
GBIF.date <- data.frame( CollectionYear=as.character(GBIF.date[,1]),
                         CollectionMonth=GBIF.date[,2],
                         CollectionDay=GBIF.date[,3])
## I use plyr later, which seems to have a problem working with
## factor data. Also, I don't want to treat these values as 
## factors anyway
GBIF.date$CollectionYear <- as.character(GBIF.date$CollectionYear)
GBIF.date$CollectionMonth <- as.character(GBIF.date$CollectionMonth)
GBIF.date$CollectionDay <- as.character(GBIF.date$CollectionDay)
GBIF.Data <- data.frame(GBIF.Data,GBIF.date)

## Get the Rhamnus frangula and Frangula alnus records back
R.frangula <- which(grepl(pattern="Rhamnus frangula*",x=GBIF.Data$species))
F.alnus <- which(grepl(pattern="Frangula alnus*",x=GBIF.Data$species))
GBIF.Data.FRAL <- GBIF.Data[ (c(R.frangula,F.alnus)), ]

## Now remove Fral Data from the GBIF records
GBIF.Data <- GBIF.Data[ -(c(R.frangula,F.alnus)), ] 
```

### Save these data

* Write the FRAL dataset to disk
* Later in this document, combine these Associated Species with the
other Associated Species data (from herbarium records) and save as one
file

```
write.csv( GBIF.Data.FRAL, file='data/GBIF.FRAL.csv',
            row.names=FALSE)

# Save as a *.shp file as well
coordinates(GBIF.Data.FRAL) <- c('lon','lat')
writeOGR(GBIF.Data.FRAL,dsn="data_gis/",layer="FRAL_GBIF","ESRI Shapefile",overwrite=TRUE)
```

### Plot these data and have a look at what GBIF has given us

R code disabled
```
## Get a simple background
data(wrld_simpl)
plot(wrld_simpl, xlim=c(xmin,xmax), ylim=c(ymin,ymax), axes=TRUE, col="light yellow")
map("state",boundary=FALSE, col="gray", add=TRUE)
## Plot other species
points(Alnus.incana$lon, Alnus.incana$lat, col="green", pch=20, cex=0.75)
points(Alnus.rugosa$lon, Alnus.rugosa$lat, col="green", pch=20, cex=0.75)
points(Alnus.serrulata$lon, Alnus.serrulata$lat, col="green", pch=20, cex=0.75)
points(Fraxinus.americana$lon, Fraxinus.americana$lat, col="green", pch=20, cex=0.75)
points(Hamamelis.virginiana$lon, Hamamelis.virginiana$lat, col="green", pch=20, cex=0.75)
points(Rhamnus.alnifolia$lon, Rhamnus.alnifolia$lat, col="green",pch=20,cex=0.75)
## Plot Frangula alnus - only those occurences in GBIF (in orange)
points(Frangula.alnus$lon, Frangula.alnus$lat, col="orange", pch=20, cex=0.5)
points(Rhamnus.frangula$lon,Rhamnus.frangula$lat,col="orange",pch=20,cex=0.5)
legend( -95, 55,
        c('FRAL Herb','FRAL GBIF','Associates GBIF'),
        pch=c(20,20,20),
        col=c('red','orange','green')
)
```

### Get County Names for GBIF Data

For the US locations (i.e. excluding Canada), I want to get accurate Admin2 (i.e. County)
level data.

R code disabled
```
## Seperate US and Canadian GBIF.Data
GBIF.Data.CA <- subset(GBIF.Data,subset=GBIF.Data$country=='Canada')
GBIF.Data.US <- subset(GBIF.Data,subset=GBIF.Data$country=='United States')

## Read in US county level shp file
County.shp <- readOGR(dsn='/Users/mlammens/Dropbox/gis_layers/countyp010.shp',
                      layer='countyp010')
## Define a spatialPoints object for GBIF data
GBIF.US.Pts <- SpatialPoints( cbind(GBIF.Data.US$lon,GBIF.Data.US$lat) )
## Give this object the same project as counties, not exactly correct, but a close
## enough approximation for my purposes
projection(GBIF.US.Pts) <- projection(County.shp)
## Get county information for each point
GBIF.US.Counties <- over(x=GBIF.US.Pts,y=County.shp)

## Add the county name information to GBIF.Data.US data.frame
GBIF.Data.US$Admin2 <- sub(pattern=' County',replacement='',GBIF.US.Counties$COUNTY)

## Do a little cleaning of the GBIF Counties, Check for mismatches,
## and assume that for cases of mismatches, GBIF is correct
# Remove the word County
GBIF.Data.US$adm2 <- sub(pattern=' County',replacement='',GBIF.Data.US$adm2)
# Remove Co.
GBIF.Data.US$adm2 <- sub(pattern=' Co.',replacement='',GBIF.Data.US$adm2)
# Clean trailing space
GBIF.Data.US$adm2 <- sub(pattern=' +$',replacement='',GBIF.Data.US$adm2)
# Change 'Prince Georges' to 'Prince George's'
GBIF.Data.US$adm2 <- sub(pattern="Prince Georges",replacement="Prince George's",GBIF.Data.US$adm2)

length(which(GBIF.Data.US$adm2!=GBIF.Data.US$Admin2)) # A total of 38 - not bad
  # and having a look at these, many of them are quirks with spelling or symbols
  # which leads to a little more cleaning, and gets it down to 33
GBIF.Data.US$adm2 <- sub(pattern='La Porte',replacement='LaPorte',GBIF.Data.US$adm2)
GBIF.Data.US$adm2 <- sub(pattern='District ofumbia',replacement='District of Columbia',GBIF.Data.US$adm2)
GBIF.Data.US$adm2 <- sub(pattern=' \\(ME\\)',replacement='',GBIF.Data.US$adm2)

# Really what I wanted is to fill in NA values in adm2 from the overlay
# So first find the records that are NA in adm2 AND NOT NA in Admin2
adm2.na.to.fill <- setdiff(which(is.na(GBIF.Data.US$adm2)),which(is.na(GBIF.Data.US$Admin2)))
# And fill in the NAs
GBIF.Data.US$adm2[adm2.na.to.fill] <-
  GBIF.Data.US$Admin2[adm2.na.to.fill]

# Make a clean GBIF data.frame that can be combined easily with 
# the herbarium data.frames
GBIF_Clean_US <- data.frame(
  SpeciesName=GBIF.Data.US$species,
  HerbariumCode=GBIF.Data.US$institution,
  Source='GBIF Search',
  Collector=GBIF.Data.US$collector,
  RecordNumber=GBIF.Data.US$catalogNumber,
  CollectionDay=as.numeric(GBIF.Data.US$CollectionDay),
  CollectionMonth=as.numeric(GBIF.Data.US$CollectionMonth),
  CollectionYear=as.numeric(GBIF.Data.US$CollectionYear),
  Country='USA',
  Admin1=GBIF.Data.US$adm1,
  Admin2=GBIF.Data.US$adm2,
  Admin3=NA,
  Locality=GBIF.Data.US$locality,
  Longitude=GBIF.Data.US$lon,
  Latitude=GBIF.Data.US$lat,
  CoordUncertainty=GBIF.Data.US$coordUncertaintyM,
  LocationNotes=NA,
  EcologyNotes=NA,
  AnalysisNotes=NA,
  Remove=NA,
  CountyLevelOnly=0 )
# Now Canadian Records
GBIF_Clean_CA <- data.frame(
  SpeciesName=GBIF.Data.CA$species,
  HerbariumCode=paste(GBIF.Data.CA$collection,GBIF.Data.CA$institution),
  Source='GBIF Search',
  Collector=GBIF.Data.CA$collector,
  RecordNumber=GBIF.Data.CA$catalogNumber,
  CollectionDay=as.numeric(GBIF.Data.CA$CollectionDay),
  CollectionMonth=as.numeric(GBIF.Data.CA$CollectionMonth),
  CollectionYear=as.numeric(GBIF.Data.CA$CollectionYear),
  Country='Canada',
  Admin1=GBIF.Data.CA$adm1,
  Admin2=GBIF.Data.CA$adm2,
  Admin3=NA,
  Locality=NA,
  Longitude=GBIF.Data.CA$lon,
  Latitude=GBIF.Data.CA$lat,
  CoordUncertainty=GBIF.Data.CA$coordUncertaintyM,
  LocationNotes=GBIF.Data.CA$locality,
  EcologyNotes=NA,
  AnalysisNotes=NA,
  Remove=NA,
  CountyLevelOnly=0 )

## Combine these two datasets
GBIF_Clean <- rbind(GBIF_Clean_CA,GBIF_Clean_US)

## Clean up a few entries (again)
# Remove any *leading* white space from Admin1 and Admin2
GBIF_Clean$Admin1 <- sub(pattern='^ +',replacement='',GBIF_Clean$Admin1)
GBIF_Clean$Admin2 <- sub(pattern='^ +',replacement='',GBIF_Clean$Admin2)

# Remove any *trailing* white space from Admin1 and Admin2
GBIF_Clean$Admin1 <- sub(pattern=' +$',replacement='',GBIF_Clean$Admin1)
GBIF_Clean$Admin2 <- sub(pattern=' +$',replacement='',GBIF_Clean$Admin2)

# Convert the state names to all UPPER CASE to make matching
# to USPS codes easier
GBIF_Clean$Admin1 <- toupper(GBIF_Clean$Admin1)
GBIF_Clean$Admin1 <- sub(pattern="QUÉBEC",replacement="QUEBEC",GBIF_Clean$Admin1)

# Mark records from iNaturalist as Remove=1
GBIF_iNat <- grep(pattern='*iNatural*',GBIF_Clean$HerbariumCode)
GBIF_Clean$Remove[GBIF_iNat] <- 1

```

***
## Univeristy of Wisconsin Herbarium (WIS)

### Steps taken to gather data from Wisconsin State Herbarium

This requires a script I wrote specifically to scrape data from
the Wisconsian State Herbarium. In order to use this script I 
first had to navigate the website
to get a http address to use in my rcurl call. I did this using
the standard WisFlora interface and search

**NOTE:** I am documenting this as generic code, rather than an R script,
to prevent it from being executed during knitting.

``` 
source('scripts/wisc_herb_scrape.R')

Alnus.incana.http <- Alnus.incana <- "http://www.botany.wisc.edu/cgi-bin/searchspecimen.cgi?SpCode=ALNINCsRUG&Genus=Alnus&Family=Betulaceae&Species=incana&Common=mountain%20alder%2C%20speckled%20alder%2C%20swamp%20alder&start=1&per_page=1000&sortop=ACCESSION"
Alnus.incana.df <- wisc_herb_scrape( Alnus.incana.http, "Alnus incana")

## Alnus rugosa is treated as a synonym of A.incana in this herbarium

Rhamnus.alnifolia.http <- "http://www.botany.wisc.edu/cgi-bin/searchspecimen.cgi?SpCode=RHAALN&Genus=Rhamnus&Family=Rhamnaceae&Species=alnifolia&Common=alder%20buckthorn%2C%20alder-leaf%20buckthorn&start=1&per_page=1000&sortop=ACCESSION"
Rhamnus.alnifolia.df <- wisc_herb_scrape( Rhamnus.alnifolia.http, "Rhamnus alnifolia" )

Fraxinus.americana.http <- "http://www.botany.wisc.edu/cgi-bin/searchspecimen.cgi?SpCode=FRAAME&Genus=Fraxinus&Family=Oleaceae&Species=americana&Common=white%20ash&start=1&per_page=1000&sortop=ACCESSION"
Fraxinus.americana.df <- wisc_herb_scrape( Fraxinus.americana.http, "Fraxinus americana" )

Hamamelis.virginiana.http <- "http://www.botany.wisc.edu/cgi-bin/searchspecimen.cgi?SpCode=HAMVIR&Genus=Hamamelis&Family=Hamamelidaceae&Species=virginiana&Common=American%20witch-hazel&start=1&per_page=1000&sortop=ACCESSION"
Hamamelis.virginiana.df <- wisc_herb_scrape( Hamamelis.virginiana.http, "Hamamelis virginiana" )

## Combine a full WIS data set
Wisc.df <- rbind(
  Alnus.incana.df,
  Rhamnus.alnifolia.df,
  Fraxinus.americana.df,
  Hamamelis.virginiana.df
)

## Write this data.frame to a csv file
write.csv(x=Wisc.df, file="data/wisc_herb_df.csv",
          row.names=FALSE)

## IF the above has already been done, just read in the csv file
Wisc.df <- read.csv('data/wisc_herb_df.csv')
```
Below I have included **depreciated** scripting I used to try to get 
lat/lon coordinates for counties using the `geocode` function in the
`dismo` package. I have since developed another way to do this, but leave
it here for reference and incase I find it helpful in the future.

```
# ## Automatically Georeference the counties in Wisc.df. This requires 
# ## a few steps.
# ## Step 1. Remove references without county (Admin 2) information
# if ( length(which(Wisc.df$Admin2=='')) ){
#   Wisc.df <- Wisc.df[-which(Wisc.df$Admin2==''),]
# }
# if ( length(which(Wisc.df$Admin1=='')) ){
#   Wisc.df <- Wisc.df[-which(Wisc.df$Admin1==''),]
# }
# ## Step 2. Make a character vector that consists of the County and State
# ## seperated by a comma, to be used in `dismo::geocode`
# CountyState <- paste( as.character(Wisc.df$Admin2),
#                       as.character(Wisc.df$Admin1),
#                       sep=', ' )
# ## Step 4. Only use the unique counties
# CountyState.unique <- unique( CountyState )
# ## Step 3. Used `geocode` to get the lat/lon data. Because of data
# ## use restrictions from Google, have to slow this process down a 
# ## little
# CountyLatLon <- c()
# for( county in CountyState.unique ){
#   Sys.sleep(0.2)
#   county.latlon <- geocode( county,oneRecord=TRUE)[3:4]
#   CountyLatLon <- rbind(CountyLatLon, county.latlon)
# }
# ## Combine the longitude and latitude values with the County name
# CountyState.split <- sapply(CountyState.unique, 
#                             function(x) {unlist(strsplit( x, split=','))} )
# CountyState.split <- t(CountyState.split)
# CountyLatLon.df <- data.frame( Admin2=CountyState.split[,1],
#                                Admin1=CountyState.split[,2],
#                                Longitude=CountyLatLon$longitude,
#                                Latitude=CountyLatLon$latitude)
# write.csv(CountyLatLon.df,file='data/Wisc_herb_CountyLatLon.csv',
#           row.names=FALSE)
```

***
## University of Minnesota Herbarium (MIN)

These data are accessible from an online search, but as downloaded in *.csv format
they are not increadibly useful. In particular, all of the spatial information is
grouped together in a single cell if you open the *.csv file in Excel.

I employ a sequence of regular expression search and replace operations to 
make these data more usefull. I carryout the search and replace operations in 
TextWrangler. Here are the exact steps:

### Step 1. Remove lines that are blank 

Find = \^\\r

Replace = [empty]

### Step 2. Merge the ID line with the 1st information line

Find = (.\*[species name].\*)\\r

Replace = \\1","

### Step 3. Merge this *new* first line with the start of the locality information

Find = (.\*[species name].\*)\\r

Replace = \\1

### Step 4. Remove lines that only have quotation marks (") on them

Find = \^"\\r

Replace = [empty]

### Step 5. Remove Coordinate Lines

Find = \^\\d+\\.\\d+"\*\\r

Replace = [empty]

### Step 6. Merge the Species line with the next line, usually the locality information

Find = (.\*[species name].\*)\\r

Replace = \\1",

### Step 7. Fix lines that have a "", occurence

Find = (.\*)"",(.\*)\\r

Replace = \\1"\\2",

### Step 8. Convert the dates from [Year]-[MO]-[DA] to [DA],[MO],[Year]

Find = (.\*)(\d\d\d\d)-(\d\d)-(\d\d)(.\*)

Replace = \1\4,\3,\2\5

### Final cleaning

The above search and replace steps get me most of the way to a clean text file
that I can read using Excel, but the file still requires a little bit of hand pruining, 
particularly for locations that occur in a park or forest for some reason (named place?).

### Combining with other records

I combined these data with the dataset constucted for the Wisconsin Flora 
dataset. To do this, I did simple "cut and paste" procedures in Excel, cutting
only the columns I was interested in from the 'Cleaned' data to the 'Combined' data.
In retrospect, I could have read the *.csv files into R and combined only the columns
I wanted, but I did not do that here. In the future, I will try this instead.

***
## Ohio State Univeristy Herbarium (OS)

General information for this herbarium can be found 
[here](http://herbarium.osu.edu/). 
Currently the OSU Herbarium has two datasets available for online search - 
the **vascular flora of Ohio** and their type specimens. I'm taking advantage of the former.  

1. I downloaded the files available after using the OSU search interface, which were all in *.xml format
2. The *.xml files were open in Excel and saved as *.xlsx files
3. I combined the Rhamnus frangula and Frangula alnus results into the Rhamnus\_frangula\_OC\_RAW.xlsx file
4. Deleted several columns from combined datasets here, but kept the records needed to match previously collected datasets and compiled datasets
5. I removed records without Collection Date information
6. I also removed records that had no collector information
7. I added the Rhamnus frangula data to the compiled Frangula alnus data set, adding a column indicating whether a record was CountyLevelOnly (0,1)
8. I added the rest of the data (i.e. non FRAL) to the data scraped from the Wisconsin herbarium, in a new *.csv named 'Associated\_Spec\_Compiled.csv'

***
## The Morton Arboretum Herbarium - Illinois (MOR)

General information about this herbarium can be found 
[here](http://www.mortonarb.org/plant-systematics/herbarium.html).
I used the search interface on this website and downloaded CSV files for
five of the six species names in my 'Group of Associated Species'.

### Process these data to add to the Associated_Spec data

R code disabled
```
# Get a list of the MOR data
mor.files <- list.files(path='~/Dropbox/F-Alnus-DB/Herbarium-Project/Collected-Data/',
                        pattern='MOR_RAW',full.names=TRUE)
# Read in all of the csv files
mor.raw <- lapply(mor.files,read.csv)

# Use plyr to merge into one data.frame
require(plyr)
mor.all <- ldply(mor.raw, data.frame)

# Clean a few county occurences
mor.all$hrb_subctry2 <- sub(pattern='DUPAGE',replacement='DuPage',mor.all$hrb_subctry2)
mor.all$hrb_subctry2 <- sub(pattern='KANKAKEE',replacement='Kankakee',mor.all$hrb_subctry2)

# Seperate the date information
mor.coll.date <- t(sapply(
  strsplit(as.character(mor.all$hrb_coll_date),split="-"),
  unlist))

Mor_Clean <- data.frame(
  SpeciesName=paste(mor.all$genus_name,mor.all$species_name),
  HerbariumCode='MOR',
  Source='http://quercus.mortonarb.org/',
  Collector=mor.all$hrb_collector_primary,
  RecordNumber=mor.all$hrb_herb_nbr,
  CollectionDay=as.numeric(mor.coll.date[,3]),
  CollectionMonth=as.numeric(mor.coll.date[,2]),
  CollectionYear=as.numeric(mor.coll.date[,1]),
  Country='USA',
  Admin1=sub(pattern="IL",replacement="Illinois",mor.all$hrb_subctry1),
  Admin2=mor.all$hrb_subctry2,
  Admin3=NA,
  Locality=NA,
  Longitude=NA,
  Latitude=NA,
  CoordUncertainty=NA,
  LocationNotes=mor.all$hrb_site,
  EcologyNotes=NA,
  AnalysisNotes=NA,
  Remove=NA,
  CountyLevelOnly=1 )

```

***
## Michigan State University Herbarium (MSC)

General information about this herbarium can be found
[here](http://www.herbarium.msu.edu/). The search interface for this
herbarium can be from this main page, or by going directly to the 
[search page](http://herbarium.lib.msu.edu:8080/VascBasicWebC/). To search
by genus/species name, I used the 
[advance search features](http://herbarium.lib.msu.edu:8080/VascBasicWebC/advanced.jsp).

### Process these data to add to the Associated_Spec data

R code disabled
```
# Get a list of the MSC data
msc.files <- list.files(path='~/Dropbox/F-Alnus-DB/Herbarium-Project/Collected-Data/',
                        pattern='MSC_RAW',full.names=TRUE)
# Read in all of the csv files
msc.raw <- lapply(msc.files,read.csv)

# Use plyr to merge into one data.frame
require(plyr)
msc.all <- ldply(msc.raw, data.frame)

# Use `lubridate` package to make dates look ok
msc.dates <- dmy(as.character(msc.all$Date))
# Remove the " UTC" part
msc.dates <- sapply(msc.dates,function(x){sub(pattern=' UTC',replacement='',x)})
# Identify the dates that didn't convert correctly
msc.dates.incomplete <- which(is.na(msc.dates))
# Split the dates, creating a list
msc.coll.date <- strsplit(as.character(msc.dates),split="-")
# Make the missing dates three NAs
for( IND in msc.dates.incomplete ){
  msc.coll.date[[IND]] <- rep(NA,3)
}
# Unlist the dates
msc.coll.date<- t(sapply(msc.coll.date,unlist))  
# Get just the years for the missing dates
msc.coll.date[msc.dates.incomplete,1] <- 
  sub(pattern='.*/',replacement='',msc.all$Date[msc.dates.incomplete])

MSC_Clean <- data.frame(
  SpeciesName=paste(msc.all$Genus.Taxon.Name,msc.all$Species.Taxon.Name),
  HerbariumCode='MSC',
  Source='http://www.herbarium.msu.edu/',
  Collector=msc.all$Last.Name,
  RecordNumber=msc.all$Bar.Code..,
  CollectionDay=as.numeric(msc.coll.date[,3]),
  CollectionMonth=as.numeric(msc.coll.date[,2]),
  CollectionYear=as.numeric(msc.coll.date[,1]),
  Country='USA',
  Admin1=msc.all$State,
  Admin2=sub(pattern="Saint",replacement="St.",msc.all$County),
  Admin3=NA,
  Locality=NA,
  Longitude=NA,
  Latitude=NA,
  CoordUncertainty=NA,
  LocationNotes=msc.all$Verbatim.Locality,
  EcologyNotes=msc.all$Verbatim.Habitat,
  AnalysisNotes=NA,
  Remove=NA,
  CountyLevelOnly=1 )

```

***
## Brooklyn Botanical Garden (BKL)

BBG is similar to Wisconsin that the data are readily avaialbe on the web,
but there is no clear way to 'bulk download' recrod informaiton. So, I used
the `wisc\_herb\_scrape.R` script as a template, and wrote a `bbg\_herb\_scrape.R`
script. 

R code disabled
```
## Source bbg_herb_scrape.R
source('scripts/bbg_herb_scrape.R')

Rhamnus.alnifolia.http <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=rhamnus+alnifolia&sort=unsorted&records=25&submit=Search"
R.alnifolia.bbg <- bbg_herb_scrape(http.link=Rhamnus.alnifolia.http,species.name="Rhamnus alnifolia")

Fraxinus.americana.http <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=fraxinus+americana&sort=unsorted&records=100&submit=Search"
F.americana.bbg <- bbg_herb_scrape(http.link=Fraxinus.americana.http,species.name="Fraxinus americana")

Alnus.incana.http <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=alnus+incana&sort=unsorted&records=100&submit=Search"
A.incana.bbg <- bbg_herb_scrape(http.link=Alnus.incana.http,species.name="Alnus incana")

Alnus.rugosa.http <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=alnus+rugosa&sort=unsorted&records=100&submit=Search"
A.rugosa.bbg <- bbg_herb_scrape(http.link=Alnus.rugosa.http,species.name="Alnus rugosa")

Alnus.serrulata.http <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=alnus+serrulata&sort=unsorted&records=100&submit=Search"
A.serrulata.bbg <- bbg_herb_scrape(http.link=Alnus.serrulata.http,species.name="Alnus serrulata")

Hamamelis.virginiana.http <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=hamamelis+virginiana&sort=unsorted&records=100&submit=Search"
H.virginiana.bbg <- bbg_herb_scrape(http.link=Hamamelis.virginiana.http,species.name="Hamamelis virginiana")

## Hamamelis.macrophylla is a synonymn for H. virginiana in this database

BBG.Herb.df <- rbind(
  A.incana.bbg,
  A.rugosa.bbg,
  A.serrulata.bbg,
  R.alnifolia.bbg,
  F.americana.bbg,
  H.virginiana.bbg )

## Now make a BBG_Clean dataset

BBG_Clean <- data.frame(
  SpeciesName=BBG.Herb.df$SpeciesName,
  HerbariumCode='BKL',
  Source=BBG.Herb.df$Source,
  Collector=BBG.Herb.df$Collector,
  RecordNumber=BBG.Herb.df$RecordNumber,
  CollectionDay=NA,
  CollectionMonth=BBG.Herb.df$CollectionMonth,
  CollectionYear=BBG.Herb.df$CollectionYear,
  Country='USA',
  Admin1=BBG.Herb.df$Admin1,
  Admin2=BBG.Herb.df$Admin2,
  Admin3=BBG.Herb.df$Admin3,
  Locality=BBG.Herb.df$Locality,
  Longitude=NA,
  Latitude=NA,
  CoordUncertainty=NA,
  LocationNotes=NA,
  EcologyNotes=NA,
  AnalysisNotes=NA,
  Remove=NA,
  CountyLevelOnly=1 )


```

***
## Carnegie Museum of Natural History (CM)

I received information from 1500 herbarium records from Bonnie Isaac, 
Collection Manager at the Carnegie Museum of Natural History. She has 
previously sent me similar information for *F. alnus*. Basic information
on the collection can be found [here](http://www.carnegiemnh.org/botany/collection.html).

### Lat/Long Coords

There were quite a large number of records with latitude and longitude coordinates
in this dataset (approx 313), so am going to use them. I did a small number of
cleaning steps in the Raw data, which included:

* Making a longitude column
* Spliting the Lat/Lon column for the 300+ records that I plan to use
* Replacing all symbols seperating degrees, minutes, and seconds by white space
* Removing N and W letters, as well as, NAD83 letters

R code disabled
```
# Read in CM Associates data
cm <- read.csv('~/Dropbox/F-Alnus-DB/Herbarium-Project/Collected-Data/Associates_CM_RAW.csv')

## Clean Lat/Long Columns
# First determine which records to use lat/long coords from
# - these will be the records that have non-zero LONG values
lat.lon.coords <- which(cm$LONG!='')
lon.dms <- as.character(cm$LONG[lat.lon.coords])
lat.dms <- as.character(cm$LAT[lat.lon.coords])

# Write a function that converst DMS to DD
DMS.to.DD <- function( dms ){
  # Clean leading and trailing white space
  dms <-  sub(pattern='^ +',replacement='',dms)
  dms <-  sub(pattern=' +$',replacement='',dms)
  # Split values
  dms.split <- strsplit(x=dms,split=' ')
  # Pad list elements with 0s
  zero.pad <- function( Vector ){
    while(length(Vector)<3) {
      Vector <- c(Vector,'0')
      }
    return(Vector)
    }
  dms.split <- lapply(X=dms.split,FUN=zero.pad)
  dms.mat <- do.call(rbind,dms.split)
  dms.df <- data.frame( deg=as.numeric(dms.mat[,1]), 
                        min=as.numeric(dms.mat[,2]),
                        sec=as.numeric(dms.mat[,3]) )
  dms.DD <- as.numeric(dms.df$deg) +
    (as.numeric(dms.df$min)/60) +
    (as.numeric(dms.df$sec)/60/60)
  return(dms.DD)
}
lat.dd <- DMS.to.DD(lat.dms)
lon.dd <- -(DMS.to.DD(lon.dms))

# Now add the LAT/LON values to the full LAT/LON vectors
LONG <- rep(NA,length(cm$LONG))
LONG[lat.lon.coords] <- lon.dd
LAT <- rep(NA,length(cm$LAT))
LAT[lat.lon.coords] <- lat.dd
# County Level Vector
CountyLevel <- rep(1,length(cm$LONG))
CountyLevel[lat.lon.coords] <- 0

# Sort collumns into unform 'Clean' format
CM_Clean <- data.frame(
  SpeciesName=paste(cm$GENUS,cm$SPECIES),
  HerbariumCode='CM',
  Source='CM Collection Manager',
  Collector=cm$COLLECTOR.S.,
  RecordNumber=cm$UNIQUE.,
  CollectionDay=cm$DAY,
  # Take advantage of Rs internal month.abb values to assing numbers to months with correct abbs,
  # NA otherwise
  CollectionMonth=match(as.character(cm$MONTH),month.abb), 
  CollectionYear=cm$YEAR,
  Country='USA',
  Admin1=cm$STATE,
  Admin2=cm$COUNTY,
  Admin3=NA,
  Locality=NA,
  Longitude=LONG,
  Latitude=LAT,
  CoordUncertainty=NA,
  LocationNotes=cm$LOCALITY,
  EcologyNotes=cm$HABITAT,
  AnalysisNotes=NA,
  Remove=NA,
  CountyLevelOnly=CountyLevel )

```

***
## Combining and Cleaning the Associated Species dataset

There are a few random cleaning tasks required, such as removing unnecessary white space,
checking on spelling and what not.

R code disabled
```
# Read in the *.csv file
Associated_Spec <- read.csv('/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/data/Associated_Spec_Compiled_ORIG.csv')
# Get the original columns names, since these will change with the georef of counties
Associated_Spec_colNames <- names(Associated_Spec)

# Combine these data with the MOR data
Associated_Spec <- rbind(Associated_Spec,Mor_Clean)
# And the MSC data
Associated_Spec <- rbind(Associated_Spec,MSC_Clean)
# And the BBG data
Associated_Spec <- rbind(Associated_Spec,BBG_Clean)
# And the CM data
Associated_Spec <- rbind(Associated_Spec,CM_Clean)

# What's the total number of records? 
nrow(Associated_Spec) # At this point = 4481 records

# What's the distribution among the three herbaria?
table(Associated_Spec$HerbariumCode)

# What about among species?
table(Associated_Spec$SpeciesName)
```

There are a fair number of sub-species included here, but overall it seems like
*Alnus incana*, Grey alder or Speckled alder, 
is the most common, which is kind of what I expected.

R code disabled
```
# Remove any *leading* white space from Admin1 and Admin2
Associated_Spec$Admin1 <- sub(pattern='^ +',replacement='',Associated_Spec$Admin1)
Associated_Spec$Admin2 <- sub(pattern='^ +',replacement='',Associated_Spec$Admin2)

# Remove any *trailing* white space from Admin1 and Admin2
Associated_Spec$Admin1 <- sub(pattern=' +$',replacement='',Associated_Spec$Admin1)
Associated_Spec$Admin2 <- sub(pattern=' +$',replacement='',Associated_Spec$Admin2)

# Convert the state names to all UPPER CASE to make matching
# to USPS codes easier
Associated_Spec$Admin1 <- toupper(Associated_Spec$Admin1)

# What does the distribution among states look like?
table(Associated_Spec$Admin1)

# What about counties?
table(Associated_Spec$Admin2)

# Make sure all St. Whereever have the period (.) after the St
Associated_Spec$Admin2 <- sub(pattern='St ',replacement='St. ',Associated_Spec$Admin2)

# Read in the State Abbreviations
State_Abb <- read.csv('~/Dropbox/gis_layers/Gaz_State_Abbrevations.csv')

# Add the state abbreviations to the Associated_Spec dataset
Associated_Spec <- merge(Associated_Spec,State_Abb,by.x='Admin1',by.y='STATE')

```

***
## Georeferencing of records at the County Level

I'm going to georeference each of these locations at the county level, using
data from the US Census Burea. Specifically I am using data from the 
**US Census Gazetteer**
aquired from this website: 
[http://www.census.gov/geo/maps-data/data/gazetteer2010.html](http://www.census.gov/geo/maps-data/data/gazetteer2010.html) 

I downloaded the 'Counties' dataset as a *.txt file. I opened it in Excel and saved
it as a *.csv file. I also copied the metadata information from this website and saved
it as a seperate *.txt file. All of the Gazatteer files are currently stored in my 
'gis_layers' direcotry in my Dropbox.

R code disabled
```
# Read in the counties *.csv file
Counties <- read.csv('~/Dropbox/gis_layers/Gaz_counties_national.csv')
# Remove the word 'County' in the 'NAME' column
Counties$NAME <- sub(pattern=' County',replacement='',Counties$NAME)

# First subset the Associated_Spec that have county AND lat/lon data already
Associated_Spec_LATLON <- Associated_Spec[which(Associated_Spec$CountyLevelOnly==0),]
# Then county level only
Associated_Spec_CNTY <- Associated_Spec[which(Associated_Spec$CountyLevelOnly==1),]

# Merge the county informaiton with the Associated_Spec data.frame. 
# **NOTE** this will remove any records that do not have county level
# information.
Associated_Spec_CNTY <- merge(Associated_Spec_CNTY,Counties,
                         by.x=c('USPS_CODE','Admin2'),by.y=c('USPS','NAME'))
# How many records remaining?
nrow(Associated_Spec_CNTY) # 4121 - only lost 40 records

# Calculate a coordinate uncertainty value for these records
# Base the uncertainty on the radius of a circle of the area
# of the count. This is a rough approximation.
Associated_Spec_CNTY$CoordUncertainty <- sqrt(Associated_Spec_CNTY$ALAND/pi)

# Set the nomral Longitude and Latidue columns as the interpreted lon/lat
Associated_Spec_CNTY$Longitude <- Associated_Spec_CNTY$INTPTLONG
Associated_Spec_CNTY$Latitude <- Associated_Spec_CNTY$INTPTLAT

# Get rid of all of the extra columns added to georef counties
Associated_Spec_CNTY <- Associated_Spec_CNTY[ Associated_Spec_colNames ]
# Similar for LATLON
Associated_Spec_LATLON <- Associated_Spec_LATLON[ Associated_Spec_colNames ]

# Merge the CNTY and LATLON data.frames back togther
Associated_Spec <- rbind( Associated_Spec_LATLON, Associated_Spec_CNTY )

```

***

## Combine Herbarium Associated Species and the GBIF Data

R code disabled
```
# `rbind` county level georefed data from above with GBIF data
Associated_Spec <- rbind(Associated_Spec,GBIF_Clean)
```

## Data exclusions 

As I did with the FRAL data, I'm excluding some data points. Here are a few of the 
general exclusion criteria.

### A specimen is noted as being cultivated, or suspected of being cultivated

R code disabled
```
Assoc.Cult <- grep(pattern='*cultiv*',Associated_Spec$EcologyNotes)
Associated_Spec <- Associated_Spec[-Assoc.Cult,]
Assoc.Cult <- grep(pattern='*Cultiv*',Associated_Spec$EcologyNotes)
Associated_Spec <- Associated_Spec[-Assoc.Cult,]
Assoc.Cult <- grep(pattern='*c*C*ultiv*',Associated_Spec$Locality)
Associated_Spec <- Associated_Spec[-Assoc.Cult,]

```

* A specimen is document outside of the area of interest for my study.
  * **Addendum** This is unneseccary,
  because every record is assigned a lat/long (either by County lat/long or georef. 
  lat/long) and then all records whose lat/long value does not fall into one of the 
  30 arc minute grids covering my study region are removed. Thus, the records are
  masked by my study region.

***
## Write new files

R code disabled
```
# Write this data.set to file
write.csv(Associated_Spec,
          file='/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/data/Associated_Spec_Compiled.csv',
          row.names=FALSE)

# Make this data set into a spatialPoints data frame
coordinates(Associated_Spec) <- c('Longitude','Latitude')
# Write this spatial data.frame to a *.shp file
writeOGR(Associated_Spec,dsn="data_gis/",layer="Associated_Spec","ESRI Shapefile",overwrite=TRUE)
# Make the data set into a normal data frame again
Associated_Spec <- as.data.frame(Associated_Spec)

```


*** 
## FRAL Data Cleaning and Spatial Layer construction

I have previously manually constructed a dataset of FRAL records, the process
of which is documented in Chapter 3 of my dissertation. Here I am reading in this layer,
cleaning the data entries a little, and making a GIS layer for these data.

R code disabled
```
## Read in the original dataset
Fral.Herb.Orig <- read.csv('data/Herb-F-alnus-Compiled_ORIG.csv')

## Clean up a few entries
FRAL_Clean <- Fral.Herb.Orig

# Remove any *leading* white space from Admin1 and Admin2
FRAL_Clean$Country <- sub(pattern='^ +',replacement='',FRAL_Clean$Country)
FRAL_Clean$Admin1 <- sub(pattern='^ +',replacement='',FRAL_Clean$Admin1)
FRAL_Clean$Admin2 <- sub(pattern='^ +',replacement='',FRAL_Clean$Admin2)

# Remove any *trailing* white space from Admin1 and Admin2
FRAL_Clean$Country <- sub(pattern=' +$',replacement='',FRAL_Clean$Country)
FRAL_Clean$Admin1 <- sub(pattern=' +$',replacement='',FRAL_Clean$Admin1)
FRAL_Clean$Admin2 <- sub(pattern=' +$',replacement='',FRAL_Clean$Admin2)

# Convert the state names to all UPPER CASE to make matching
# to USPS codes easier
FRAL_Clean$Admin1 <- toupper(FRAL_Clean$Admin1)

# If the county level has a 'St ' in it, convert to 'St. '
FRAL_Clean$Admin2 <- sub(pattern='St ',replacement='St. ',FRAL_Clean$Admin2)

# How many records?
nrow(FRAL_Clean) # 752
```

### Georeferencing counties

First let's georeference the CountyLevelOnly data. Note I'm assuming
that the section titled **Georeferencing of records at the County Level**
was previously run in this environment.

R code disabled
```
# Get indexs for county level only
FRAL.cnt.only <- which(FRAL_Clean$CountyLevelOnly==1)
# Get the State and County names for the 'CountyLevelOnly==1' data
FRAL.cnt.Names <- FRAL_Clean[FRAL.cnt.only,c("Admin1","Admin2")]
# Add a column that indexs the orginal order of these records
FRAL.cnt.Names$Orig.Order <- seq(from=1,to=nrow(FRAL.cnt.Names))

# First get the State Abbreviations
FRAL.cnt.Names <- merge( FRAL.cnt.Names, State_Abb,by.x='Admin1',by.y='STATE' )
# Now merge with the County information
FRAL.cnt.Names <- merge( FRAL.cnt.Names,Counties,
                         by.x=c('USPS_CODE','Admin2'),by.y=c('USPS','NAME'))

# Now re-order it back to the original order
FRAL.cnt.Names <- FRAL.cnt.Names[ order(FRAL.cnt.Names$Orig.Order), ]

# Assigne Long/Lat values in the original data.frame
FRAL_Clean$Longitude[FRAL.cnt.only] <- FRAL.cnt.Names$INTPTLONG
FRAL_Clean$Latitude[FRAL.cnt.only] <- FRAL.cnt.Names$INTPTLAT
# And uncertainty values
FRAL_Clean$CoordUncertainty[FRAL.cnt.only] <- sqrt(FRAL.cnt.Names$ALAND/pi)
  
```

Some of the records that are in the US are missing Admin2 (County) information.
The CA records I cannot easily georef to county.

TODO - Do this for Admin1 Level Data too. I had to hand fix several
records from the Brooklyn Botanical Garden. I manually assigned Admin1 (States)
to several records.

R code disabled
```
# Get the rows of FRAL_Clean that are missing Admin2 data and in the US
FRAL.missing.adm2 <- which(FRAL_Clean$Admin2=='' & FRAL_Clean$Country=='United States')

# Make a spatial points object for this records
FRAL.missing.adm2.pts <- SpatialPoints( FRAL_Clean[ FRAL.missing.adm2,c("Longitude","Latitude") ] )
# Assign county layer projection
projection(FRAL.missing.adm2.pts) <- projection(County.shp)
# Get county information
FRAL.missing.counties <- over(x=FRAL.missing.adm2.pts,y=County.shp)
# Assing the missing county values
FRAL_Clean[FRAL.missing.adm2,"Admin2"] <- sub(pattern=" County",replacement="",FRAL.missing.counties$COUNTY)
# If the county level has a 'Saint ' in it, convert to 'St. '
FRAL_Clean$Admin2 <- sub(pattern='Saint ',replacement='St. ',FRAL_Clean$Admin2)
```

### Save the `FRAL_Clean` dataset

R code disabled
```
# Write this data.set to file
write.csv(FRAL_Clean,
          file='/Users/mlammens/Dropbox/F-Alnus-DB/Herbarium-Project/Chapter-3-FRAL-Retrospective/data/FRAL_HERB_Compiled.csv',
          row.names=FALSE)

# Make this data set into a spatialPoints data frame
coordinates(FRAL_Clean) <- c('Longitude','Latitude')
# Write this spatial data.frame to a *.shp file
writeOGR(FRAL_Clean,dsn="data_gis/",layer="FRAL_Herb","ESRI Shapefile",overwrite=TRUE)
# Make the data set into a normal data frame again
FRAL_Clean <- as.data.frame(FRAL_Clean)
```