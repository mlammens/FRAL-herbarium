wisc_herb_scrape <- function( http.link, species.name ){
  ## ******************************************************************** ##
  ## wisc_herb_scrape.R
  ##
  ## Author: Matthew Aiello-Lammens
  ## Date Created: 17 APR 2013
  ##
  ## Purpose: Scrape the available data from Wisconsin State Herbarium
  ##
  ## Args:
  ##   http.link: http address to the list of herbarium records for a given
  ##   species. This needs to be determined via a search on Wisconsin State
  ##   Herbarium website
  ##
  ##   species.name: The genus species name, to be used in data.frame 
  ##   creation.
  ##
  ## ******************************************************************** ##
  
  ## Load required libraries
  require("RCurl")
  
  ## Get all Alnus incana accessions
  ##http.link <- ("http://www.botany.wisc.edu/cgi-bin/searchspecimen.cgi?SpCode=ALNINCsRUG&Genus=Alnus&Family=Betulaceae&Species=incana&Common=mountain%20alder%2C%20speckled%20alder%2C%20swamp%20alder&start=1&per_page=1000&sortop=ACCESSION")

  ##http.link <- "http://www.botany.wisc.edu/cgi-bin/searchspecimen.cgi?SpCode=RHAALN&Genus=Rhamnus&Family=Rhamnaceae&Species=alnifolia&Common=alder%20buckthorn%2C%20alder-leaf%20buckthorn&start=1&per_page=1000&sortop=ACCESSION"
  
  ## Get Accession records
  Species.Accessions <- readLines(http.link)
  
  ## Remove any special characters that interfer with Rs regexs
  Species.Accessions <- gsub(pattern="Hér",replacement="",Species.Accessions)
  Species.Accessions <- gsub(pattern="L&#39",replacement="",Species.Accessions)
  
  ## All of the data I want is in a sinlge line that starts with
  ## "<table bgcolor"
  ###DataTable <- grep( "<table bgcolor.*", Species.Accessions, value=TRUE )
  ## I had difficulty with the above grep command, so instead I
  ## am just hard coding that the data table is line 31 in the source
  DataTable <- Species.Accessions[31]
  ## Search and replace "<a href=" with a new line
  DataTable <- unlist(strsplit(x=DataTable,split="(<a href=)"))
  ## Remove the first 11 items, as these are headings and what not
  DataTable <- DataTable[-(1:11)]
  ## Now DataTable is a char vector that is twice as long as the number
  ## of specimens. The odd numbered lines are links to the individual 
  ## accessions.
  AccessionLinks <- DataTable[ seq(from=1,to=length(DataTable),by=2) ]
  ## Clean the links to make them usable
  cleanLink <- function( link ){ unlist(strsplit(link,split='"'))[2] }
  AccessionLinks <- sapply( AccessionLinks, FUN=cleanLink )
  AccessionLinks <- unname(AccessionLinks)
  ## Add the prefacing herbariam address
  AccessionLinks <- paste("http://www.botany.wisc.edu",AccessionLinks,sep="")
  
  ## Let's get all of the records at once
  AccessionData <- lapply(AccessionLinks,FUN=readLines)
  ## Remove empty Accession Data - these records are going to
  ## have 57 lines (only header information)
  AccessionLengths <- unlist(lapply(AccessionData,length))
  if ( any(AccessionLengths<=57) ){
    AccessionData <- AccessionData[ -(which(AccessionLengths<=57)) ]
  }
  
  ## Clean accession data for annoying symbols
  CleanSymbols <- function(AccData) {
    AccDataClean <- gsub(pattern="é",replacement="",x=AccData)
    AccDataClean <- gsub(pattern="&",replacement="",x=AccDataClean)
    AccDataClean <- gsub(pattern="#",replacement="",x=AccDataClean)
    return(AccDataClean)
  }    
  ## Clean off the top of the source code
  CleanHeaderInfo <- function(AccData) {
    HeaderStopLine <- grep(pattern="Specimen Detail Page",x=AccData)
    AccDataNoHead <- AccData[-(1:HeaderStopLine)]
    return(AccDataNoHead)
  }
  ## Remove Annotator Information (this is to make searching for a date easier)
  CleanAnnotatorInfo <- function(AccData) {
    AnnotatorLine <- grep(pattern="Annotator",x=AccData)
    AccDataNoAnnotator <- AccData[-(AnnotatorLine:length(AccData)) ]
    return(AccDataNoAnnotator)
  }
  
  ## Apply these cleaning functions to the AccessionData
  AccessionData <- lapply(AccessionData,FUN=CleanSymbols)
  AccessionData <- lapply(AccessionData,FUN=CleanHeaderInfo)
  AccessionData <- lapply(AccessionData,FUN=CleanAnnotatorInfo)
  
  ## Start Buidling a data.frame of Record Data
  ## ******************************************
  
  ## First start with the Accession Number (the last bit
  ## of the accession link)
  RecordNumber <- sapply(AccessionLinks,
                         function(x) {gsub(pattern=".*=",replacement="",x)})
  RecordNumber <- unname(RecordNumber)
  ## Remove the Accession Numbers that were empty
  if ( any(AccessionLengths<=57) ){
    RecordNumber <- RecordNumber[ -(which(AccessionLengths<=57)) ]
  }
  
  ## Get Collection Dates
  ## Using `grep` I find the line nubmer that contains the pattern "Date"
  ## from here, the actual data informaiton is 3 lines lower
  AccDateLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Date",x=x)}))
  ## Run a for loop here
  AccDatesRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccDatesRaw <- c(AccDatesRaw, AccessionData[[cnt]][(AccDateLines[cnt]+3)])
  }
  AccDatesRaw <- sapply(AccDatesRaw,
                        function(x) {gsub(pattern=" .*",replacement="",x)})
  AccDatesRaw <- unname(AccDatesRaw)
  ## Find the accessions with no date informaiton
  AccNoDates <- setdiff( 1:length(AccDatesRaw), grep(AccDatesRaw,pattern="^[1-9]") )
  AccDatesRaw[ AccNoDates ] <- "NA/NA/NA"
  ## Seperate Dates into Days Months Years
  AccDatesDays <- sapply(AccDatesRaw, 
                         function(x) { unlist(strsplit(x=x,split="/"))[2] })
  CollectionDay <- unname(AccDatesDays)
  AccDatesMonths <- sapply(AccDatesRaw, 
                           function(x) { unlist(strsplit(x=x,split="/"))[1] })
  CollectionMonth <- unname(AccDatesMonths)
  AccDatesYears <- sapply(AccDatesRaw, 
                          function(x) { unlist(strsplit(x=x,split="/"))[3] })
  CollectionYear <- unname(AccDatesYears)
  
  ## Get Collector Name
  AccCollectorLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Collector 1:",x=x)}))
  AccCollectorRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccCollectorRaw <- c(AccCollectorRaw, AccessionData[[cnt]][(AccCollectorLines[cnt]+3)])
  }
  AccCollectorRaw <- sapply(AccCollectorRaw,
                            function(x) {gsub(pattern="<.*",replacement="",x)})
  Collector <- unname(AccCollectorRaw)
  
  ## Get Country
  ## Using `grep` I find the line nubmer that contains the pattern "Country"
  ## from here, the actual data informaiton is 3 lines lower
  AccCntryLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Country",x=x)}))
  AccCntryRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccCntryRaw <- c(AccCntryRaw, AccessionData[[cnt]][(AccCntryLines[cnt]+3)])
  }
  AccCntryRaw <- sapply(AccCntryRaw,
                        function(x) {gsub(pattern="<.*",replacement="",x)})
  Country <- unname(AccCntryRaw)
  
  ## Get Admin1 (State)
  ## Using `grep` I find the line nubmer that contains the pattern "State:"
  ## from here, the actual data informaiton is 3 lines lower
  AccAdmin1Lines <- unlist(lapply(AccessionData,function(x) {grep(pattern="State:",x=x)}))
  AccAdmin1Raw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccAdmin1Raw <- c(AccAdmin1Raw, AccessionData[[cnt]][(AccAdmin1Lines[cnt]+3)])
  }
  AccAdmin1Raw <- sapply(AccAdmin1Raw,
                         function(x) {gsub(pattern="\\t.*",replacement="",x)})
  Admin1 <- unname(AccAdmin1Raw)
  
  ## Get Admin2 (County)
  ## Using `grep` I find the line nubmer that contains the pattern "County"
  ## from here, the actual data informaiton is 3 lines lower
  AccAdmin2Lines <- unlist(lapply(AccessionData,function(x) {grep(pattern="County:",x=x)}))
  AccAdmin2Raw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccAdmin2Raw <- c(AccAdmin2Raw, AccessionData[[cnt]][(AccAdmin2Lines[cnt]+3)])
  }
  AccAdmin2Raw <- sapply(AccAdmin2Raw,
                         function(x) {gsub(pattern="<.*",replacement="",x)})
  Admin2 <- unname(AccAdmin2Raw)
  
  ## Get Admin3 (Town)
  ## Using `grep` I find the line nubmer that contains the pattern "Pop. Area:"
  ## from here, the actual data informaiton is 3 lines lower
  AccAdmin3Lines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Pop. Area:",x=x)}))
  AccAdmin3Raw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccAdmin3Raw <- c(AccAdmin3Raw, AccessionData[[cnt]][(AccAdmin3Lines[cnt]+4)])
  }
  AccAdmin3Raw <- sapply(AccAdmin3Raw,
                         function(x) {gsub(pattern="<.*",replacement="",x)})
  Admin3 <- unname(AccAdmin3Raw)
  
  ## Get Locality information
  AccPlaceLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="Place:",x=x)}))
  AccPlaceRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccPlaceRaw <- c(AccPlaceRaw, AccessionData[[cnt]][(AccPlaceLines[cnt]+3)])
  }
  AccPlaceRaw <- sapply(AccPlaceRaw,
                        function(x) {gsub(pattern="<.*",replacement="",x)})
  Locality <- unname(AccPlaceRaw)
  
  ## Get Latitude 
  AccLatDecLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="LatDec:",x=x)}))
  AccLatDecRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccLatDecRaw <- c(AccLatDecRaw, AccessionData[[cnt]][(AccLatDecLines[cnt]+3)])
  }
  AccLatDecRaw <- sapply(AccLatDecRaw,
                         function(x) {gsub(pattern="<.*",replacement="",x)})
  Latitude <- unname(AccLatDecRaw)
  # Get Longitude
  AccLongDecLines <- unlist(lapply(AccessionData,function(x) {grep(pattern="LongDec:",x=x)}))
  AccLongDecRaw <- c()
  for (cnt in 1:length(AccessionData) ){
    AccLongDecRaw <- c(AccLongDecRaw, AccessionData[[cnt]][(AccLongDecLines[cnt]+2)])
  }
  AccLongDecRaw <- sapply(AccLongDecRaw,
                          function(x) {gsub(pattern="<.*",replacement="",x)})
  Longitude <- unname(AccLongDecRaw)
  
  ## Get Habitat information
  AccHabLines <- lapply(AccessionData,function(x) {grep(pattern="Habitat:",x=x)})
  ## Figure out which Accessions have no Habitat information
  NoLocalityInfo <- which(unlist(lapply(AccHabLines,length))==0)
  HasLocalityInfo <- setdiff(1:length(AccHabLines),NoLocalityInfo)
  AccHabRaw <- vector(length=length(AccHabLines))
  for (ind in HasLocalityInfo ){
    AccHabRaw[ind] <- AccessionData[[ind]][(AccHabLines[[ind]]+3)]
  }
  AccHabRaw <- sapply(AccHabRaw,
                      function(x) {gsub(pattern="&quot;",replacement="",x)})
  Habitat <- unname(AccHabRaw)
  Habitat[NoLocalityInfo] <- ""
  
  ## Get Text information
  AccTextLines <- lapply(AccessionData,function(x) {grep(pattern="Text:",x=x)})
  ## Figure out which Accessions have no Habitat information
  NoTextInfo <- which(unlist(lapply(AccTextLines,length))==0)
  HasTextInfo <- setdiff(1:length(AccTextLines),NoTextInfo)
  AccTextRaw <- vector(length=length(AccTextLines))
  for (ind in HasTextInfo ){
    AccTextRaw[ind] <- AccessionData[[ind]][(AccTextLines[[ind]]+3)]
  }
  AccTextRaw <- sapply(AccTextRaw,
                       function(x) {gsub(pattern="&quot;",replacement="",x)})
  Text <- unname(AccTextRaw)
  Text[NoLocalityInfo] <- ""
  
  ## Compile the new data.frame
  compiled.df <- data.frame( SpeciesName = rep(species.name,times=length(AccessionData)),
                             HerbariumCode = rep("WIS",times=length(AccessionData)),
                             Source = rep("wisc_herb_scrape.R",times=length(AccessionData)),
                             Collector, RecordNumber, 
                             CollectionDay, CollectionMonth, CollectionYear,
                             Country, Admin1, Admin2, Admin3,
                             Locality, 
                             Longitude, Latitude,
                             EcologyNotes=Text )
  ## Return the compiled data set
  return( compiled.df )
}