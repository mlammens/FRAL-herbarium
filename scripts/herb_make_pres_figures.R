## ******************************************************************** ##
## herb_make_pres_figures.R
##
## Author: Matthew Aiello-Lammens
## Date Created: 2014-03-23
##
## Purpose:
##
## ******************************************************************** ##

## This script requires running lines 1 to 366 ("Plot these data on a map" 
## section) 

## Get a simple background
data(wrld_simpl)

years <- seq( 1880, 2010, by=10 )
file_name <- paste( "figures/Pres_Fig_HistOccur_", years, ".pdf", sep="" )

for ( y in 1:length( years ) ){

  year <- years[ y ]
  
  ## Make and Save Plot
  pdf( file=file_name[ y ],
       width=9.5, height=6 )
  par( mar=c( 2, 2, 0, 0) )
  plot( wrld_simpl, xlim=c(xmin,xmax), ylim=c(ymin,ymax), axes=TRUE, col="lightgoldenrodyellow")
  map("state",boundary=FALSE, col="gray", add=TRUE)
  # ## Plot group of associated species
  # points( Associated.Spec$Longitude,
  #         Associated.Spec$Latitude, 
  #         col="grey50", pch=3, cex=0.6 )
  ## Plot Frangula alnus
  ## First the complete FRAL data set I've compiled
  points( FRAL.Herb$Longitude[ FRAL.Herb$CollectionYear <= year ],
          FRAL.Herb$Latitude[ FRAL.Herb$CollectionYear <= year ], 
          col="darkred", bg="darkred", pch=24, cex=1.0 )
  text( x=(-96), y=36.5, years[ y ], cex=2, font=2 )

  dev.off()
  
}




