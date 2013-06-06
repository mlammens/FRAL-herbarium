bbg_herb_scrape <- function( http.link, species.name ){
  ## ******************************************************************** ##
  ## bbg_herb_scrape.R
  ##
  ## Author: Matthew Aiello-Lammens
  ## Date Created: 25 MAY 2013
  ##
  ## Purpose: Scrape the available data from Brooklyn Botanical Gardens Herbarium
  ##
  ## Args:
  ##   http.link: http address to the list of herbarium records for a given
  ##   species. This needs to be determined via a search on Brooklyn Botanical
  ##   Gardens website
  ##
  ##   species.name: The genus species name, to be used in data.frame 
  ##   creation.
  ##
  ## ******************************************************************** ##
  
  ## Load required libraries
  require("RCurl")
  
  ## Get all Rhamnus alnifolia accessions
  ##http.link <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=rhamnus+alnifolia&sort=unsorted&records=25&submit=Search"
  ##http.link <- "http://www.bbg.org/the-herbarium/ailanthus/search.php?search_num=1&family=&state=&locality=&county=&collector=&from_date_year=&scientific_name=fraxinus+americana&sort=unsorted&records=100&submit=Search"
  
  ## Get Accession records
  Species.Accessions <- readLines(http.link)
  
  ## Get the "specimen_id" lines from this websource
  Specimen_ids <- grep(pattern='specimen_id',Species.Accessions)
  ## Take only these lines from the source
  Species.Accessions <- Species.Accessions[ Specimen_ids ]
  ## Clean this list up so I only have the Accession Links
  Species.Accessions <- sub(pattern='.*href=\"',replacement='',Species.Accessions)
  Species.Accessions <- sub(pattern='\">.*',replacement='',Species.Accessions)
  
  ## Each species accesson can be accessed by prefacing it with this web address
  Species.Accession.Prefix <- "http://www.bbg.org/the-herbarium/ailanthus/"
  Species.Accessions <- paste(Species.Accession.Prefix,Species.Accessions,sep="")
  
  ## Now get all of the individual records at once
  AccessionData <- lapply(Species.Accessions,FUN=readLines)
  ## Determine the number of lines for of each accession record
  AccessionLengths <- unlist(lapply(AccessionData,length))
  
  ## Functions to clean the source code of each assession record
  ## ***
  ## Clean off the top of the source code
  CleanHeaderInfo <- function(AccData) {
    HeaderStopLine <- grep(pattern="<h2>Plant Information</h2>",x=AccData)
    AccDataNoHead <- AccData[-(1:HeaderStopLine)]
    return(AccDataNoHead)
  }
  ## Clean accession data for annoying symbols
  CleanSymbols <- function(AccData) {
    AccDataClean <- gsub(pattern="é",replacement="",x=AccData)
    AccDataClean <- gsub(pattern="&",replacement="",x=AccDataClean)
    AccDataClean <- gsub(pattern="#",replacement="",x=AccDataClean)
    return(AccDataClean)
  }    
  ## Remove footer information
  CleanFooterInfo <- function(AccData) {
    AnnotatorLine <- grep(pattern="Back to Results",x=AccData)
    AccDataNoAnnotator <- AccData[-(AnnotatorLine:length(AccData)) ]
    return(AccDataNoAnnotator)
  }  
  ## Apply these cleaning functions to the AccessionData
  AccessionData <- lapply(AccessionData,FUN=CleanSymbols)
  AccessionData <- lapply(AccessionData,FUN=CleanHeaderInfo)
  AccessionData <- lapply(AccessionData,FUN=CleanFooterInfo)
  
  ## Start Buidling a data.frame of Record Data
  ## ******************************************
  
  ## Record/ Accession Number 
  ## This is the last part of the Specimen.Accessons string
  RecordNumber <- sapply(Species.Accessions,
                         function(x) {gsub(pattern=".*=",replacement="",x)})
  RecordNumber <- unname(RecordNumber)
  
  ## Collection Dates
  ## Using `grep` I find the line nubmer that contains the pattern "Collection Date"
  ## from here, the actual data informaiton is 1lines lower
  AccDateLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Collection Date",x=x)}))
  ## Run a for loop here
  AccDatesRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccDatesRaw <- c(AccDatesRaw, AccessionData[[cnt]][(AccDateLines[cnt]+1)])
  }
  AccDatesRaw <- sapply(AccDatesRaw,
                        function(x) {gsub(pattern="<td>",replacement="",x)})
  AccDatesRaw <- sapply(AccDatesRaw,
                        function(x) {gsub(pattern="</td>",replacement="",x)})
  AccDatesRaw <- unname(AccDatesRaw)
  ## BBG only includes month and year in their date infromation
  ## Find the accessions with no date informaiton
  AccNoDates <- setdiff( 1:length(AccDatesRaw), grep(AccDatesRaw,pattern="^[1-9]") )
  AccDatesRaw[ AccNoDates ] <- "NA/NA"
  ## Seperate Dates into Months Years
  CollectionDay <- NA
  AccDatesMonths <- sapply(AccDatesRaw, 
                           function(x) { unlist(strsplit(x=x,split="/"))[1] })
  CollectionMonth <- unname(AccDatesMonths)
  AccDatesYears <- sapply(AccDatesRaw, 
                          function(x) { unlist(strsplit(x=x,split="/"))[2] })
  CollectionYear <- unname(AccDatesYears)
  
  ## Collector Name
  AccCollectorLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Collector",x=x)}))
  AccCollectorRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccCollectorRaw <- c(AccCollectorRaw, AccessionData[[cnt]][(AccCollectorLines[cnt]+1)])
  }
  AccCollectorRaw <- sapply(AccCollectorRaw,
                            function(x) {gsub(pattern="<td>",replacement="",x)})
  AccCollectorRaw <- sapply(AccCollectorRaw,
                            function(x) {gsub(pattern="</td>",replacement="",x)})
  Collector <- unname(AccCollectorRaw)
  
  ## BBG does not include Country information
#   ## Get Country
#   ## Using `grep` I find the line nubmer that contains the pattern "Country"
#   ## from here, the actual data informaiton is 3 lines lower
#   AccCntryLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Country",x=x)}))
#   AccCntryRaw <- c()
#   for (cnt in 1:length(AccessionData) ){
#     AccCntryRaw <- c(AccCntryRaw, AccessionData[[cnt]][(AccCntryLines[cnt]+3)])
#   }
#   AccCntryRaw <- sapply(AccCntryRaw,
#                         function(x) {gsub(pattern="<.*",replacement="",x)})
#   Country <- unname(AccCntryRaw)
  
  ## Get Admin1 (State)
  ## Using `grep` I find the line nubmer that contains the pattern "State:"
  ## from here, the actual data informaiton is 3 lines lower
  AccAdmin1Lines <- unlist(lapply(AccessionData,function(x) {grep(pattern=">State<",x=x)}))
  AccAdmin1Raw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccAdmin1Raw <- c(AccAdmin1Raw, AccessionData[[cnt]][(AccAdmin1Lines[cnt]+1)])
  }
#   AccAdmin1Raw <- sapply(AccAdmin1Raw,
#                          function(x) {gsub(pattern="<td>",replacement="",x)})
  AccAdmin1Raw <- sapply(AccAdmin1Raw,
                         function(x) {gsub(pattern="</*td>",replacement="",x)})
  Admin1 <- unname(AccAdmin1Raw)
  
  ## Get Admin2 (County)
  ## Using `grep` I find the line nubmer that contains the pattern "County"
  ## from here, the actual data informaiton is 3 lines lower
  AccAdmin2Lines <- unlist(lapply(AccessionData,function(x) {grep(pattern=">County<",x=x)}))
  AccAdmin2Raw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccAdmin2Raw <- c(AccAdmin2Raw, AccessionData[[cnt]][(AccAdmin2Lines[cnt]+1)])
  }
#   AccAdmin2Raw <- sapply(AccAdmin2Raw,
#                          function(x) {gsub(pattern="<td>",replacement="",x)})
  AccAdmin2Raw <- sapply(AccAdmin2Raw,
                         function(x) {gsub(pattern="</*td>",replacement="",x)})
  Admin2 <- unname(AccAdmin2Raw)
  
  ## Get Admin3 (Town/City)
  AccAdmin3Lines <- unlist(lapply(AccessionData,function(x) {grep(pattern="City",x=x)}))
  AccAdmin3Raw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccAdmin3Raw <- c(AccAdmin3Raw, AccessionData[[cnt]][(AccAdmin3Lines[cnt]+1)])
  }
  AccAdmin3Raw <- sapply(AccAdmin3Raw,
                         function(x) {gsub(pattern="<td>",replacement="",x)})
  AccAdmin3Raw <- sapply(AccAdmin3Raw,
                         function(x) {gsub(pattern="</td>",replacement="",x)})
  AccAdmin3Raw <- sapply(AccAdmin3Raw,
                         function(x) {gsub(pattern="nbsp;",replacement="",x)})
  Admin3 <- unname(AccAdmin3Raw)
  
  ## Get Locality information
  AccPlaceLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Location",x=x)}))
  AccPlaceRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccPlaceRaw <- c(AccPlaceRaw, AccessionData[[cnt]][(AccPlaceLines[cnt]+1)])
  }
  AccPlaceRaw <- sapply(AccPlaceRaw,
                        function(x) {gsub(pattern="</*td>",replacement="",x)})
  AccPlaceRaw <- sapply(AccPlaceRaw,
                        function(x) {gsub(pattern="nbsp;",replacement="",x)})
  Locality <- unname(AccPlaceRaw)
  
  ## Latitude and Longitude
  ## I am not collecting these data from the accession for a few reasons:
  ## * BBG has lat/lon in degrees minutes; this is not very precise and I don't
  ##   want to convert them here
  ## * I am using these data in the county level analysis
  ## I might change this in the future, or it could easily be changed by others
 
  ## Ecological Notes
  ## I am not collecting these data from the accession records. Most of these
  ## data are non-standard characters, and I am not using these data in any anlaysis
  ## at the current time.
#   AccHabLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Ecological Characteristics",x=x)}))
#   AccHabRaw <- c()
#   for (cnt in 1:length(AccessionData) ){
#     AccHabRaw <- c(AccHabRaw, AccessionData[[cnt]][(AccHabLines[cnt]+1)])
#   }
#   AccHabRaw <- sapply(AccHabRaw,
#                         function(x) {gsub(pattern="</*td>",replacement="",x)})
#   EcologicalNotes <- unname(AccHabRaw)
  
  ## Get Description information
  ## Not collecting - mostly empty or non-standard char; also not currently using
#  AccTextLines <- lapply(AccessionData,function(x) {grep(pattern="Description",x=x)})
  
  ## Compile the new data.frame
  compiled.df <- data.frame( SpeciesName = rep(species.name,times=length(AccessionData)),
                             HerbariumCode = rep("BBG",times=length(AccessionData)), # Should have been BKL
                             Source = rep("bbg_herb_scrape.R",times=length(AccessionData)),
                             Collector, RecordNumber, 
                             CollectionMonth, CollectionYear,
                             Admin1, Admin2, Admin3,
                             Locality )
  ## Return the compiled data set
  return( compiled.df )
}