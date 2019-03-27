## ************************************************************************** ##
## herb_figures.R
##
## Author: Matthew Aiello-Lammens
## Date Created: 2018-04-12
##
## Purpose:
## Create all figures for Fral Herbarium project
##
## ************************************************************************** ##

## ************************************************************************** ##
## Execute the herb_main.R script to make all data available for plotting
## ************************************************************************** ##
source(herb_main.R)

## ******************************************************************** ##
## Plot these data on a map
## ******************************************************************** ##
## Get a simple background
data(wrld_simpl)
## Make and Save Plot
#pdf(file='figures/Specimen_Locales.pdf',width=9, height=6, )
graphics.off()
#pdf(file='figures/Diss_Fig_3_2.pdf',width=9, height=5.5, family="Times" )
par( mar=c( 2, 2, 0, 0) )
plot(wrld_simpl, xlim=c(xmin,xmax), ylim=c(ymin,ymax), axes=TRUE, col="lightgoldenrodyellow")
#plot(can1,add=TRUE)
map("state",boundary=FALSE, col="gray", add=TRUE)
## Plot group of associated species
points(Associated.Spec$Longitude,Associated.Spec$Latitude, col="grey50",pch=3,cex=0.6)
## Plot Frangula alnus
## First the complete FRAL data set I've compiled
points(FRAL.Herb$Longitude,FRAL.Herb$Latitude, col="black", bg="black", pch=24, cex=0.8)
# ## And second only those occurences in GBIF (in orange)
# points(FRAL.GBIF$lon,FRAL.GBIF$lat,col="orange",pch=20,cex=0.4)
legend( -71, 41.0,
        expression(italic('F. alnus'),'Associated Species'), #'FRAL GBIF','Associates GBIF'),
        pch=c(17,3), #,20),
        col=c('black','grey50') )

plot(falnus.extent,add=TRUE,col='red')
#dev.off()

graphics.off()


## ******************************************************************** ##
## Make Figure for journal manuscript (b/w only)
## Updated on 2019-03-27 to use ggplot2 instead
## ******************************************************************** ##

# ## Get a simple background
# data(wrld_simpl)
# ## Make and Save Plot
# #pdf(file='figures/Specimen_Locales.pdf',width=9, height=6, )
# graphics.off()
# pdf(file='~/Dropbox/Projects/FRAL-herbarium/manuscript/Figure_1.pdf', width=5.5, height=3.5, family="Times" )
# par( mar=c( 2, 2, 0, 0) )
# plot(wrld_simpl, xlim=c(xmin,xmax), ylim=c(ymin,ymax), axes=TRUE)
# #plot(can1,add=TRUE)
# map("state",boundary=FALSE, col="black", add=TRUE)
# ## Plot group of associated species
# points(Associated.Spec$Longitude,Associated.Spec$Latitude, col="black",pch=3,cex=0.4)
# ## Plot Frangula alnus
# ## First the complete FRAL data set I've compiled
# points(FRAL.Herb$Longitude,FRAL.Herb$Latitude, col="black", bg="black", pch=24, cex=0.8) #  
# # ## And second only those occurences in GBIF (in orange)
# # points(FRAL.GBIF$lon,FRAL.GBIF$lat,col="orange",pch=20,cex=0.4)
# legend( -73.5, 38.45,
#         expression(italic('F. alnus'),'Associated Species'), #'FRAL GBIF','Associates GBIF'),
#         pch=c(17,3), #,20),
#         col=c('black','black') )
# 
# plot(falnus.extent,add=TRUE,col='black', lty = 5)
# dev.off()
# 
# graphics.off()

library(ggmap)
library(maps)
library(mapdata)

temp_data <- select(Associated.Spec, SpeciesName, Longitude, Latitude)
temp_data$SpeciesName <- "Associated Species"
temp_fral <- select(FRAL.Herb, SpeciesName, Longitude, Latitude)
temp_fral$SpeciesName <- "F. alnus"
temp_data <- rbind(temp_data, temp_fral)

#pdf(file='~/Dropbox/Projects/FRAL-herbarium/manuscript/Figure_1.pdf', width=5.5, height=3.5, family="Times" )
## Get USA map data
states <- map_data("state")
world <- map_data("world")
ggplot() + 
  geom_polygon(data = world, aes(x=long, y=lat, group=group), color = "black", fill = "white")+
  geom_polygon(data = states, aes(x=long, y = lat, group = group), color = "black", fill = "white") + 
  coord_fixed(1.45, xlim = c(xmin,xmax), ylim = c(ymin,ymax)) + # 1.3,
  guides(fill = FALSE) +
  geom_point(data = temp_data, aes(x = Longitude, y = Latitude, shape = SpeciesName),  alpha = 0.3) +
  scale_shape_manual(values=c(3, 2)) +
  geom_point(data = FRAL.Herb, aes(x = Longitude, y = Latitude), pch = 2,  alpha = 0.3) +
  xlab("Longitude") +
  ylab("Latitude") +
  theme_bw() +
  theme(legend.position = c(1,0), legend.justification = c(1,0), 
        legend.title = element_blank(), 
        legend.text = element_text(size = 9, family = "Times"),
        legend.background = element_rect(fill = "transparent"),
        axis.title = element_text(size = 12, family = "Times"),
        axis.text = element_text(family = "Times"))
ggsave(filename='~/Dropbox/Projects/FRAL-herbarium/manuscript/Figure_1_new.pdf', device = "pdf",
       width=5.5, height=3.5, units = "in")
#dev.off()


## ******************************************************************** ##
## Examine records through time BEFORE any spatial filtering
## ******************************************************************** ##

## FIGURE XX - Record_Counts_by_Decade.pdf 

## Make a combined data.frame with two columns: 
## 1. Dataset ID (either Herbarium, GBIF FRAL, or GBIF ALL)
## 2. Collection year
rec.years <- c( FRAL.Herb$CollectionYear,
                #FRAL.GBIF$CollectionYear,
                Associated.Spec$CollectionYear )
rec.years <- as.numeric(rec.years)
rec.decade <- round.up( rec.years, 10)
rec.cat <- c( rep('FRAL_Herb',times=length(FRAL.Herb$CollectionYear)),
              #rep('FRAL_GBIF',times=length(FRAL.GBIF$CollectionYear)),
              rep('Associates',times=length(Associated.Spec$CollectionYear)) )
rec.years.df <- data.frame( Record.Cat=rec.cat, Record.Year=rec.years,
                            Record.Decade=rec.decade)
## Get record counts for decades
Rec.Cnt.Decade <- ddply( .data=rec.years.df,
                         .variables=c('Record.Cat','Record.Decade'),
                         Decade.Cnt=length(Record.Year),
                         summarize)
## Add NAs for any Record.Cat that is missing a decade
dec.all <- seq(from=min(Rec.Cnt.Decade$Record.Decade),
               to=max(Rec.Cnt.Decade$Record.Decade),
               by=10)
Rec.Cnt.Decade.all <- ddply( .data=Rec.Cnt.Decade,
                             .variable='Record.Cat',
                             Match=match(dec.all,Record.Decade),
                             summarize)
Rec.Cnt.Decade.all$Record.Decade <- rep( dec.all,times=2)
## Get the Decades with is.na(Match) = true
Missing.Rec.Decade <- Rec.Cnt.Decade.all[which(is.na(Rec.Cnt.Decade.all$Match)),]
Missing.Rec.Decade <- data.frame(Record.Cat=Missing.Rec.Decade$Record.Cat,
                                 Record.Decade=Missing.Rec.Decade$Record.Decade,
                                 Decade.Cnt=Missing.Rec.Decade$Match )
Rec.Cnt.Decade <- rbind( Rec.Cnt.Decade, Missing.Rec.Decade )

## Calculate the proportion of total records colleted in each year
## -------------------------------------------------------------------------- ##
## Calculate the total number of records for Fral and Associated species
rec_cnt_totals <- 
  Rec.Cnt.Decade %>%
  group_by(Record.Cat) %>%
  dplyr::summarise(total = sum(Decade.Cnt, na.rm = TRUE))
## Make proportion columns
Rec.Cnt.Decade$Decade.Prop <-
  ifelse(Rec.Cnt.Decade$Record.Cat == "Associates", 
         yes = Rec.Cnt.Decade$Decade.Cnt / as.numeric(rec_cnt_totals[1,2]),
         no = Rec.Cnt.Decade$Decade.Cnt / as.numeric(rec_cnt_totals[2,2]))

## Clean up
rm(Missing.Rec.Decade,Rec.Cnt.Decade.all,dec.all,rec.years.df,
   rec.decade,rec.years,rec.cat)

## Make bar plot
# # Make my theme
# my.theme <- theme_set(theme_bw()) +
#   theme_update(axis.text.x=element_text(size=12,angle=90,colour="black")) +
#   theme_update(axis.title.x=element_text(size=14,colour="black",face="bold")) +
#   theme_update(axis.text.y=element_text(size=12,colour="black")) +
#   theme_update(axis.title.y=element_text(size=14,angle=90,colour="black",face="bold"))

rec.years.plot <- 
  ggplot(Rec.Cnt.Decade, aes(x=Record.Decade, y=Decade.Cnt, fill=Record.Cat)) +
  geom_bar(position="dodge",stat="identity") +
  xlab("Decade") +
  ylab("Record Count") +
  scale_fill_manual( values= c("grey50", "black"),
                     name="Record Type",
                     labels=c('Assoc. Spec.','F. alnus') ) +
  theme_bw() +
  theme( text=element_text( size=12, family="Times") )

# ggsave( filename="figures/Diss_Fig_3_3.pdf", width=6.5, height=6.5, units="in" )
#ggsave(plot = rec.years.plot, filename="manuscript/Figure_2.pdf", width=5.5, height=5.5, units="in" )

# pdf('figures/Record_Counts_by_Decade.pdf')
# print(rec.years.plot)
# dev.off()

rec.years.prop.plot <- 
  ggplot(Rec.Cnt.Decade, aes(x=Record.Decade, y=Decade.Prop, fill=Record.Cat)) +
  geom_bar(position="dodge",stat="identity") +
  xlab("Decade") +
  ylab("Proportion of total records") +
  scale_fill_manual( values= c("grey50", "black"),
                     name="Record Type",
                     labels=c('Assoc. Spec.','F. alnus') ) +
  theme_bw() +
  theme( text=element_text( size=12, family="Times") )
print(rec.years.prop.plot)

#ggsave(plot = rec.years.prop.plot, filename="manuscript/Figure_2_New.pdf", width=5.5, height=5.5, units="in" )

## ************************************************************************** ##
## Plot raw Cumulative Occupied Grid Cell numbers
## ******************************************************************** ##
## FIGURE XX - Cumulative_Occupied_Grid_Cells.pdf
## ***
#pdf('figures/Cumulative_Occupied_Grid_Cells.pdf',width=10)
plot( Associated.Spec.Loc.Overlap_Cumm.Grid$Years,
      Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids,
      xlab='Year',
      ylab='Cumulative Occupied Grid Cells',
      pch=19)
points( FRAL.Herb.Loc.Overlap_Cumm.Grid$Years, 
        FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids, 
        col='red',pch=19)
legend( 1980, 50,
        expression('Associated Spec',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
#dev.off()

ggplot() +
  #   geom_point( data=NULL, aes( x = Associated.Spec.Loc.Overlap_Cumm.Grid$Years,
  #                               y = Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrids ),
  #               col="black" ) +
  geom_point( data=NULL, aes( x = FRAL.Herb.Loc.Overlap_Cumm.Grid$Years,
                              y = FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids ),
              col="red", size=3 ) +
  xlim( c(1865, 2010 ) ) +
  ylim( c( 0, 350 ) ) +
  xlab( "Year" ) +
  ylab( "Cumulaitve occupied grid cells" ) +
  theme_bw() +
  theme( text=element_text( size=18, face="bold" ),
         axis.title.y=element_text(vjust=0.3) ) # size=20 # use 20 for most figures, 18 for small
#ggsave( "figures/Pres_Fig_Fral_CumGrid.pdf", width=9.5, height=6, units="in" )
#ggsave( "figures/Pres_Fig_Fral_CumGrid_Small.pdf", width=4.5, height=4.1, units="in" )


## ************************************************************************** ##
## Plot the log-linear Cumulative Occupied Grid Cells with lm fits
## ******************************************************************** ##

## Plot the **log** Cumulative Occupied Grid Cell numbers
#pdf('figures/Log_Cumm_GridCells_with_Fits.pdf',width=10)
plot( Associated.Spec.Loc.Overlap_Cumm.Grid$Years,
      log(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrid),
      xlab='Year',
      ylab='Log-Cumulative Occupied Grid Cells',
      pch=19)
points( FRAL.Herb.Loc.Overlap_Cumm.Grid$Years, 
        log(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids), 
        col='red',pch=19)
abline(fral.lm, col="red", lwd=2.5)
abline(assoc.lm, lwd=2.5)
lines(x.fh,predict(fral.lm2,data.frame(Years=x.fh)),
      lwd=2.5,col='red',lty=2)
lines(x,predict(assoc.lm2,data.frame(Years=x)),
      lwd=2.5,lty=2)
lines(x.fh,predict(fral.lm3,data.frame(Years=x.fh)),
      lty=4,lwd=2.5,col='red')
lines(x,predict(assoc.lm3,data.frame(Years=x)),
      lty=4,lwd=2.5)
legend( 1980, 2,
        c('Linear','Quadratic','Cubic'),
        lwd=c(2.5,2.5,2.5),
        lty=c(1,2,4)
)
legend( 1980, 3,
        c('Associated Spec','FRAL'),
        pch=c(19,19),
        col=c('black','red')
)
#dev.off()

## Plot the Square Root Cumulative Occupied Grid Cells with lm fits
## ******************************************************************** ##
## Plot the **sqrt** Cumulative Occupied Grid Cell numbers
#pdf('figures/Sqrt_Cumm_GridCells_with_Fits.pdf',width=10)
plot( Associated.Spec.Loc.Overlap_Cumm.Grid$Years,
      sqrt(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrid),
      xlab='Year',
      ylab='Sqrt-Cumulative Occupied Grid Cells',
      pch=19)
points( FRAL.Herb.Loc.Overlap_Cumm.Grid$Years, 
        sqrt(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids), 
        col='red',pch=19)
abline(fral.lm.sqrt, col="red", lwd=2.5)
abline(assoc.lm.sqrt, lwd=2.5)
lines(x.fh,predict(fral.lm2.sqrt,data.frame(Years=x.fh)),
      lwd=2.5,col='red',lty=2)
# lines(x,predict(assoc.lm2.sqrt,data.frame(Years=x)),
#       lwd=2.5,lty=2)
# lines(x.fh,predict(fral.lm3.sqrt,data.frame(Years=x.fh)),
#       lty=4,lwd=2.5,col='red')
lines(x,predict(assoc.lm3.sqrt,data.frame(Years=x)),
      lty=4,lwd=2.5)
legend( 1980, 4.5,
        c('Linear','Quadratic','Cubic'),
        lwd=c(2.5,2.5,2.5),
        lty=c(1,2,4)
)
legend( 1980, 7,
        expression('Associated Spec',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
#dev.off()

## -------------------------------------------------------------------- ##
## Make figures for defense talk

ggplot() +
  geom_point( data=FRAL.Herb.Loc.Overlap_Cumm.Grid, 
              aes( x = Years, y = sqrt( OccGrids ) ),
              col="red", size=3 ) +
  #   geom_line( data=NULL, aes( x = 1879:2010, 
  #                              y = fral.lm.sqrt$fitted.values ),
  #              col="red", size=1.5) +
  #   geom_line( data=NULL, aes( x = 1879:2010, 
  #                              y = fral.lm2.sqrt$fitted.values ),
  #              size = 1.5) +
  xlim( c(1865, 2010 ) ) +
  ylim( c( 0, 20 ) ) +
  xlab( "Year" ) +
  ylab(  "Sqrt( cumulaitve occupied grid cells )" ) +
  theme_bw() +
  theme( text=element_text( size=20, face="bold" ),
         axis.title.y=element_text(vjust=0.3) )
#ggsave( "figures/Pres_Fig_Fral_SqrtCumGrid.pdf", width=9.5, height=6, units="in" )
#ggsave( "figures/Pres_Fig_Fral_SqrtCumGrid_Small.pdf", width=4.5, height=4, units="in" )

ggplot() +
  geom_point( data=FRAL.Herb.Loc.Overlap_Cumm.Grid, 
              aes( x = Years, y = sqrt( OccGrids ) ),
              col="red", size=3 ) +
  #   geom_line( data=NULL, aes( x = 1879:2010, 
  #                              y = fral.lm.sqrt$fitted.values ),
  #              col="red", size=1.5) +
  geom_line( data=NULL, aes( x = 1879:2010, 
                             y = fral.lm2.sqrt$fitted.values ),
             size = 1.5) +
  xlim( c(1865, 2010 ) ) +
  ylim( c( 0, 20 ) ) +
  xlab( "Year" ) +
  ylab(  "Sqrt( cumulaitve occupied grid cells )" ) +
  theme_bw() +
  theme( text=element_text( size=20, face="bold" ),
         axis.title.y=element_text(vjust=0.3) )
#ggsave( "figures/Pres_Fig_Fral_SqrtCumGrid_wFit.pdf", width=9.5, height=6, units="in" )

# Fral AND Associated species
ggplot() +
  geom_point( data=FRAL.Herb.Loc.Overlap_Cumm.Grid, 
              aes( x = Years, y = sqrt( OccGrids ) ),
              col="red", size=3 ) +
  #   geom_line( data=NULL, aes( x = 1879:2010, 
  #                              y = fral.lm.sqrt$fitted.values ),
  #              col="red", size=1.5) +
  geom_line( data=NULL, aes( x = 1879:2010, 
                             y = fral.lm2.sqrt$fitted.values ),
             size = 1.5) +
  geom_point( data=Associated.Spec.Loc.Overlap_Cumm.Grid, 
              aes( x = Years, y = sqrt( OccGrids ) ),
              col="black", size=3 ) +
  geom_line( data=NULL, aes( x = 1869:2012, 
                             y = assoc.lm3.sqrt$fitted.values ),
             size = 1.5) +  
  xlim( c(1865, 2010 ) ) +
  ylim( c( 0, 20 ) ) +
  xlab( "Year" ) +
  ylab(  "Sqrt( cumulaitve occupied grid cells )" ) +
  theme_bw() +
  theme( text=element_text( size=20, face="bold" ),
         axis.title.y=element_text(vjust=0.3) )
#ggsave( "figures/Pres_Fig_Fral_Assoc_SqrtCumGrid_wFit.pdf", width=9.5, height=6, units="in" )

# Ratio plot
ggplot() +
  geom_point( data=FRAL.Herb.Assoc.allYrs.Overlap,
              aes( x = Years, y = AOO.Ratio ),
              size = 3 ) +
  xlim( c(1865, 2010 ) ) +
  #ylim( c( 0, 20 ) ) +
  xlab( "Year" ) +
  ylab( "Ratio of cumulative occurence of\nF. alnus to associated species" ) +
  theme_bw() +
  theme( text=element_text( size=20, face="bold" ),
         axis.title.y=element_text(vjust=0.4) )
#ggsave( "figures/Pres_Fig_Fral_Assoc_Ratio.pdf", width=9.5, height=6, units="in" )

# Growth Rate Ratio plot
ggplot() +
  geom_point( data=FRAL.Herb.Assoc.allYrs.Overlap,
              aes( x = Years, y = Cumm.Grid.R.Diff ),
              size = 3 ) +
  geom_point( data=NULL,
              aes( x = 1884:2005, y = Cum.Grid.R.Diff ),
              size = 3, col = "red" ) +
  xlim( c(1865, 2010 ) ) +
  geom_hline( yintercept=1, size = 1.5 ) +
  ylim( c( 0.8, 1.2 ) ) +
  xlab( "Year" ) +
  ylab( "Ratio of growth rates of\nF. alnus to associated species" ) +
  theme_bw() +
  theme( text=element_text( size=20, face="bold" ),
         axis.title.y=element_text(vjust=0.3) )
#ggsave( "figures/Pres_Fig_Fral_Assoc_GrowthRate.pdf", width=9.5, height=6, units="in" )



## Plot Growth Rates based on regression fits
## ******************************************************************** ##
## -- Calcualted based on the slope of the cubic regression line
#pdf('figures/Cumulative_Grid_Cells_Growth_Rate_from_Fits.pdf')
plot(FRAL.Herb.Assoc.allYrs.Overlap$Years,Assoc.growth.fit,
     type='l',lwd=2.5,
     xlab='Year',
     ylab='Slope of Regression Line (Growth Rate)')
lines(FRAL.Herb.Assoc.allYrs.Overlap$Years,FRAL.growth.fit,
      lwd=2.5,col='red')
## Add the approximate intercept (point of smallest difference)
points(1910,FRAL.growth.fit[which(FRAL.Herb.Assoc.allYrs.Overlap$Years==1910)],
       pch=20,cex=2.5)
text(1915,1.06,"Intercept at approx. 1910",pos=4)
legend( 1940, 1.1,
        c('Associated Spec','FRAL'),
        lwd=c(2.5,2.5),
        col=c('black','red')
)
#dev.off()

## Plot Ratio Results
## ******************************************************************** ##
## FIGURE XX - Herb_Fral_to_Associates_ratio_OVERLAP.pdf
## ***
#pdf('figures/Herb_Fral_to_Associates_ratio_OVERLAP.pdf',width=10)
fral.gbif.ratio.overlap <- ggplot( FRAL.Herb.Assoc.allYrs.Overlap, 
                                   aes(x=Years,y=sqrt(AOO.Ratio),size=TotalGrids) ) + #,color=OccGrids.x) ) +
  geom_point() +
  xlab("Year") +
  ylab("Ratio of Sqrt-Occ. Grids of F. alnus to Assoc. Spec") +
  labs(size="Occ. Grids - All") +
  xlim(1879,2012)
#labs(colour="Occ. Grids - FRAL")
print(fral.gbif.ratio.overlap)
#dev.off()

## Plot Annual Growth Rate Results
## ******************************************************************** ##
## FIGURE - Cumulative_Grid_Cells_Growth_Rate.pdf
## ***
## Melt this data.frame to plot the R vals nicely
FRAL.Herb.Assoc.allYrs.Overlap.melt <- melt(FRAL.Herb.Assoc.allYrs.Overlap, id=c(1:5,8))
# Plot the R vals
#pdf('figures/Cumulative_Grid_Cells_Growth_Rate.pdf')
R.val.plot <- ggplot(FRAL.Herb.Assoc.allYrs.Overlap.melt, 
                     aes(x=Years,y=value,colour=variable)) +
  geom_point(size=2.5,shape=16) +
  xlim(1879,2013) +
  ylim(0.9,1.5) +
  ylab('Cumulative Occupied Grid Cells Growth Rate')
print(R.val.plot)
#dev.off()
## Clean up
rm(FRAL.Herb.Assoc.allYrs.Overlap.melt)

## Plot the ** Difference** in Growth Rate Results
## ******************************************************************** ##
## FIGURE - Cumulative_Grid_Cells_Growth_Rate_Difference.pdf
## ***
#pdf('figures/Cumulative_Grid_Cells_Growth_Rate_Difference.pdf')
plot( FRAL.Herb.Assoc.allYrs.Overlap$Years,
      FRAL.Herb.Assoc.allYrs.Overlap$Cumm.Grid.R.Diff,
      #ylim=c(-.5,.5), # This cuts off one extreme point at > 1.5
      ylim=c(.8,1.2), # This cuts off one extreme point at > 1.5
      xlab='Year',
      ylab='Ratio of Growth Rate of Cumulative Occ. Grids' )
#abline(h=0,lwd=2.5,col='red',lty=5)
abline(h=1,lwd=2.5,col='red',lty=5)
# Add difference in fitted values
#points(FRAL.Herb.Assoc.allYrs.Overlap$Years,
#       Cumm.Grid.growth.Diff.fit,
#       pch=19,cex=0.5,col='darkred')
points(1884:2005,Cum.Grid.R.Diff,
       pch=19,cex=0.5,col='darkred')
legend( 1950, .9,
        c('Ratio - Annual R','Ratio - Mov.Win. R Ratio'),
        pch=c(1,19),
        col=c('black','darkred')
)
#dev.off()

## ************************************************************************** ##
## Histogram of the number of years between the first assocaited species
## occurence in a county and the first FRAL occurence in a county
## ******************************************************************** ##
## Figure: 
## ***
#pdf('figures/County_Assoc_to_FRAL_Delay.pdf')
hist(FRAL.Delay,breaks=20,
     main='',
     xlab='First Year Rec_FRAL - First Year Rec_Assoc.')
#dev.off()

ggplot() +
  geom_histogram( data=NULL, aes( x=FRAL.Delay ), binwidth=10 ) +
  ylab( "Frequency" ) +
  xlab( "Difference between year of first occurence of\nF. alnus versus associated species" ) +
  theme_bw() +
  theme( text=element_text( size=12, family="Times") )

#ggsave( filename="figures/Diss_Fig_3_7.pdf", width=6.5, height=6.5, units="in" )


## ************************************************************************** ##
## Plot the raw cumulative county results
## ******************************************************************** ##
## Figure: Cumulative_Counties.pdf
## ***
#pdf('figures/Cumulative_Counties.pdf')
plot(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years,
     Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties,
     xlab="Year",
     ylab="Cumulative Occupied Counties",
     pch=19)
points(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years,
       FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties,
       col='red',
       pch=19)
legend( 1950,20,
        expression('Associated Spec',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
#dev.off()


## Plot the square root of the cumulative county results
## ******************************************************************** ##
## Figure: Sqrt_Cumulative_Counties.pdf
## ***

# Make two data sets of x-coords
x.cnty.assoc <- seq(min(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years),
                    max(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years),
                    l=length(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years) )
x.cnty.fral <- seq(min(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years),
                   max(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years),
                   l=length(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years) )

#pdf('figures/Sqrt_Cumulative_Counties.pdf')
plot(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years,
     sqrt(Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties),
     xlab="Year",
     ylab="Sqrt-Cumulative Occupied Counties",
     pch=19)
points(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years,
       sqrt(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties),
       col='red',
       pch=19)
lines(x.cnty.assoc,predict(assoc.cnt.lm,data.frame(Years=x.cnty.assoc)),
      lwd=2.5)
lines(x.cnty.assoc,predict(assoc.cnt.lm3,data.frame(Years=x.cnty.assoc)),
      lwd=2.5,lty=2)
lines(x.cnty.fral,predict(fral.cnt.lm,data.frame(Years=x.cnty.fral)),
      lwd=2.5,col='red')
lines(x.cnty.fral,predict(fral.cnt.lm3,data.frame(Years=x.cnty.fral)),
      lwd=2.5,col='red',lty=2)
legend( 1950,2.25,
        expression('Associated Spec',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
#dev.off()


## Plot Ratio Results
## ******************************************************************** ##
## FIGURE XX - Herb_Fral_to_Associates_ratio_COUNTIES.pdf
## ***
fral.gbif.ratio.cnty <- ggplot( Cumm.Cnty.Combined.df, 
                                aes(x=Years,y=sqrt(AOO.Ratio),size=TotalCnty) ) + #,color=FRAL.OccCnty) ) +
  geom_point() +
  xlab("Year") +
  ylab("Sqrt-Ratio of Occ. Counties for FRAL to Assoc. Spec") +
  labs(size="Occ. Counties - All") +
  xlim(1879,2012)
#labs(colour="Occ. Cntys - FRAL")
#pdf('figures/Herb_Fral_to_Associates_ratio_COUNTIES.pdf',width=10)
print(fral.gbif.ratio.cnty)
#dev.off()

## Plot Growth Rate Results
## ******************************************************************** ##
## FIGURE - Cumulative_Cnty_Cells_Growth_Rate.pdf
## ***
## Melt this data.frame to plot the R vals nicely
Cumm.Cnty.Combined.df.melt <- melt(Cumm.Cnty.Combined.df, id=c(1:5,8))
# Plot the R vals
R.val.cnty.plot <- ggplot(Cumm.Cnty.Combined.df.melt, 
                          aes(x=Years,y=value,colour=variable)) +
  geom_point(size=2.5,shape=16) +
  xlim(1879,2013) +
  ylim(0.9,1.5) +
  ylab('Cumulative Occupied Cnty Cells Growth Rate')
#pdf('figures/Cumulative_Cnty_Cells_Growth_Rate.pdf')
print(R.val.cnty.plot)
#dev.off()
## Clean up
rm(Cumm.Cnty.Combined.df.melt)

## Plot the ** Difference** in Growth Rate Results
## ******************************************************************** ##
## FIGURE - TBD
## ***
#pdf('figures/Cumulative_Cnty_Cells_Growth_Rate_Difference.pdf')
plot( Cumm.Cnty.Combined.df$Years,
      Cumm.Cnty.Combined.df$Cumm.Cnty.R.Diff,
      #ylim=c(-.5,.5), # This cuts off one extreme point at > 1.5
      ylim=c(0.8,1.2),
      xlab='Year',
      ylab='Diff. Growth Rate of Cumulative Occ. Counties' )
abline(h=1,lwd=2.5,col='red',lty=5)
points(1884:2000,Cum.Cnty.R.Diff,
       pch=19,cex=0.5,col='darkred')
legend( 1950, 0.9,
        c('Ratio - Annual R','Ratio - Mov.Win. R Ratio'),
        pch=c(1,19),
        col=c('black','darkred')
)
#dev.off()



## ************************************************************************** ##
## Plot the log Cumulative Number of Records through time with lm fits
## ******************************************************************** ##
#pdf('figures/Cumulative_Records_with_Fits.pdf')
plot( Records.Cumm.All$Years,
      log(Records.Cumm.All$CummRec.Assoc),
      xlab='Year',
      ylab='Log-Cumulative Records',
      pch=19)
points( Records.Cumm.All$Years,
        log(Records.Cumm.All$CummRec.Fral.Herb),
        pch=19,col='red')
abline(fral.rec.lm,col='red',lwd=2.5)
abline(assoc.rec.lm,lwd=2.5)
lines(x,predict(assoc.rec.lm2,data.frame(Years=x)),
      lwd=2.5,lty=4)
lines(x,predict(fral.rec.lm3,data.frame(Years=x)),
      lwd=2.5,lty=4,col='red')
legend( 1940, 3,
        expression('Assoc. Spec.',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
#dev.off()

## Melt this data.frame to easily plot it
Records.Cumm.All.melt <- melt(Records.Cumm.All, id=1)
# Plot the cumulative records curve
cumm.recs.plot <- ggplot(Records.Cumm.All.melt, aes(x=Years,y=value,colour=variable)) +
  geom_line()
print(cumm.recs.plot)
## Clean up
rm( Records.Cumm.All.melt)

## Calcualte growth rates for these data
t.plus.1 <- as.matrix(Records.Cumm.All[-1,2:3])
# Get a matrix for number of grids at time point t
t.pres <- as.matrix(Records.Cumm.All[-length(Records.Cumm.All$Years),2:3])
# Calculate annual R values
Records.Cumm.All.R <- t.plus.1/t.pres
# Add a first Row of NA values
Records.Cumm.All.R <- rbind( rep(NA,2), Records.Cumm.All.R )
# Add names to the columns
colnames(Records.Cumm.All.R) <- c('Assoc.Rec.R','FRAL.Rec.R')
# Add these columns to the Records.Cumm.All data.frame
Records.Cumm.All <- data.frame(Records.Cumm.All,Records.Cumm.All.R)
# Calculate difference in Growth Rates
Records.Cumm.All$Cumm.Rec.R.Diff <-
  #Records.Cumm.All$FRAL.Rec.R-Records.Cumm.All$Assoc.Rec.R
  Records.Cumm.All$FRAL.Rec.R/Records.Cumm.All$Assoc.Rec.R
## Clean up
rm(t.plus.1,t.pres)

## Calculate the 10-year moving average window of R
# First make a reduced dataset that only has values when both
# FRAL and Assoc R is not an NA
Cumm.Rec.R <-
  Records.Cumm.All[ which(!is.na(Records.Cumm.All$Assoc.Rec.R) & !is.na(Records.Cumm.All$FRAL.Rec.R)), ]
# For FRAL this will start in 1881
Cumm.Rec.Fral.MA <- rollapply(data=Cumm.Rec.R$FRAL.Rec.R,width=10,align='center',FUN=geometric.mean)
Cumm.Rec.Assoc.MA <- rollapply(data=Cumm.Rec.R$Assoc.Rec.R,width=10,align='center',FUN=geometric.mean)
Cumm.Rec.R.Diff <- Cumm.Rec.Fral.MA/Cumm.Rec.Assoc.MA

## Plot the growth differences
## ******************************************************************** ##
## FIGURE - Cumulative_Records_Growth_Rate_Difference.pdf
## ***
#pdf('figures/Cumulative_Records_Growth_Rate_Difference.pdf')
plot(Records.Cumm.All$Years,Records.Cumm.All$Cumm.Rec.R.Diff,
     #ylim=c(-0.5,0.5),
     ylim=c(0.8,1.2),
     xlim=c(1879,2010),
     xlab="Year",
     ylab='Diff. Growth Rate of Cumulative Total Records')
abline(h=1,lwd=2.5,col='red',lty=5)
#points(1888:2010,Cumm.Rec.R.Diff,
points(1890:2007,Cumm.Rec.R.Diff,
       pch=19,col='darkred')
#dev.off()

## Find the year of F.alnus first record
which(Records.Cumm.All$Years==Fral.Herb.FirstYr)
## Calcualte Cumulative Records growth rates
Growth.Rts.Cumm.Records <- apply(X=Records.Cumm.All[16:length(Records.Cumm.All$Years),4:5],
                                 MARGIN=2,FUN=geometric.mean)

## Melt this data.frame to plot the R vals nicely
Records.Cumm.All.R.melt <- melt(Records.Cumm.All, id=c(1:3,6))
# Plot the R vals
## ******************************************************************** ##
## FIGURE - Cumulative_Records_Growth_Rate.pdf
## ***
Cumm.Rec.R.val.plot <- ggplot(Records.Cumm.All.R.melt, aes(x=Years,y=value,colour=variable)) +
  geom_point(size=2.5,shape=16) +
  #geom_line() +
  xlim(1879,2013) +
  ylim(0.9,1.5) +
  ylab('Cumulative Records Growth Rate')
#pdf('figures/Cumulative_Records_Growth_Rate.pdf')
print(Cumm.Rec.R.val.plot)
#dev.off()
## Clean up
rm(Records.Cumm.All.R.melt)

## Calculate and plot proportional increase in records for the
## Associated species and FRAL
Records.Cumm.All$CummRec.Assoc.Prop.Increase <-
  Records.Cumm.All$CummRec.Assoc / max(Records.Cumm.All$CummRec.Assoc)
Records.Cumm.All$CummRec.Fral.Herb.Prop.Increase <-
  Records.Cumm.All$CummRec.Fral.Herb / max(Records.Cumm.All$CummRec.Fral.Herb,na.rm=TRUE)
## Melt this data.frame to easily plot it
Records.Cumm.All.Prop.melt <- melt(Records.Cumm.All, id=1:6)
## ******************************************************************** ##
## FIGURE - Cumulative_Records_Proportional_Increase.pdf
## ***
Cumm.Rec.Prop.Inc.plot <- ggplot(Records.Cumm.All.Prop.melt, aes(x=Years,y=value,colour=variable)) +
  geom_point(size=2.5,shape=16) +
  xlim(1879,2013) +
  ylab('Proportional Cummulative Increase in Records') +
  scale_colour_discrete(labels=c("Assoc. Spec.","FRAL"))
#pdf('figures/Cumulative_Records_Proportional_Increase.pdf')
print(Cumm.Rec.Prop.Inc.plot)
#dev.off()

## KS Test
## ***
## Now I'm going to apply a ks.test to the proportional increase
## in herbarium records through time. I'm restricting the data
## set to only the years that overlap for non-zero values
Recs.Match.Temp <- intersect(which(!is.na(Records.Cumm.All$CummRec.Assoc.Prop.Increase)),
                             which(!is.na(Records.Cumm.All$CummRec.Fral.Herb.Prop.Increase)))
Records.Prop.Increase.KS.test <-
  ks.test(Records.Cumm.All$CummRec.Assoc.Prop.Increase[Recs.Match.Temp],
          Records.Cumm.All$CummRec.Fral.Herb.Prop.Increase[Recs.Match.Temp])
print(Records.Prop.Increase.KS.test)

## Calculate and plot the ratio in the proportional increase
## ******************************************************************** ##
## FIGURE - Cumulative_Records_Ratio_Prop_Increase.pdf
## ***
#pdf('figures/Cumulative_Records_Ratio_Prop_Increase.pdf')
plot( Records.Cumm.All$Years[Recs.Match.Temp],
      log( Records.Cumm.All$CummRec.Fral.Herb.Prop.Increase[Recs.Match.Temp] /
             Records.Cumm.All$CummRec.Assoc.Prop.Increase[Recs.Match.Temp]),
      pch=19,
      xlab='Year',
      ylab='Log-Ratio of Prop. Increase of Cumulative Records')
#dev.off()


## ************************************************************************** ##
## ******************************************************************** ##
## Make multi-panel figures to include in the paper
## ******************************************************************** ##

## Cumulative Number of Records through time 
## ******************************************************************** ##
#pdf('figures/Cumulative_Records_Figure.pdf')
#pdf( "figures/Diss_Fig_3_4.pdf", width=6.5, height=6.5, family="Times" )
par( mfrow=c(2,2), mar=c(4,4,0.5,1), ps=12 )
## Log Cumulative Records vs Time
x <- seq( min(Records.Cumm.All$Years),
          max(Records.Cumm.All$Years),
          l=length(Records.Cumm.All$Years) )
plot( Records.Cumm.All$Years,
      log(Records.Cumm.All$CummRec.Assoc),
      xlab='',
      ylab='Log-Cumulative Records',
      xlim=c(1836,2012),
      pch=19,
      cex=0.5)
points( Records.Cumm.All$Years,
        log(Records.Cumm.All$CummRec.Fral.Herb),
        pch=19,
        cex=0.5,
        col='red')
abline(fral.rec.lm,col='red',lwd=2.5)
abline(assoc.rec.lm,lwd=2.5)
lines(x,predict(assoc.rec.lm2,data.frame(Years=x)),
      lwd=2.5,lty=4)
lines(x,predict(fral.rec.lm3,data.frame(Years=x)),
      lwd=2.5,lty=4,col='red')
legend( 1930, 2.5,
        expression('Assoc. Spec.',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
# Growth Rate Difference
plot(Records.Cumm.All$Years,Records.Cumm.All$Cumm.Rec.R.Diff,
     pch=19,
     #ylim=c(-0.5,0.5),
     ylim=c(0.8,1.2),
     xlim=c(1879,2010),
     xlab="",
     ylab='Ratio of growth rate of cumulative total records')
abline(h=1,lwd=2.5,col='red',lty=5)
#points(1888:2010,Cumm.Rec.R.Diff,
points(1890:2007,Cumm.Rec.R.Diff,
       pch=19,
       col='red',
       cex=0.75)
# Ratio vs time
plot( Records.Cumm.All$Years[Recs.Match.Temp],
      #(log(Records.Cumm.All$CummRec.Fral.Herb[Recs.Match.Temp] /
      #      Records.Cumm.All$CummRec.Assoc[Recs.Match.Temp])),
      #(log(Records.Cumm.All$CummRec.Fral.Herb[Recs.Match.Temp]) /
      #       log(Records.Cumm.All$CummRec.Assoc[Recs.Match.Temp])),
      (Records.Cumm.All$CummRec.Fral.Herb[Recs.Match.Temp] /
         Records.Cumm.All$CummRec.Assoc[Recs.Match.Temp]),
      pch=19,
      cex=0.5,
      xlab='Year',
      ylab='Ratio of Cumulative Records',
      xlim=c(1836,2012))
#dev.off()

## Cumulative Number of Grid Cells through time 
## ******************************************************************** ##
#pdf('figures/Cumulative_GridCells_Figure.pdf')
#pdf( "figures/Diss_Fig_3_5.pdf", width=6.5, height=6.5, family="Times" )
par( mfrow=c(2,2), mar=c(4,4,0.5,1), ps=12 )
## Plot the **sqrt** Cumulative Occupied Grid Cell numbers
x.fh <- seq(min(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
            max(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
            l=length(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years) )
x <- seq(min(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
         max(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
         l=length(Associated.Spec.Loc.Overlap_Cumm.Grid$Years) )
plot( Associated.Spec.Loc.Overlap_Cumm.Grid$Years,
      sqrt(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrid),
      xlab='',
      ylab='Sqrt-Cumulative Occupied Grid Cells',
      pch=19,
      cex=0.5)
points( FRAL.Herb.Loc.Overlap_Cumm.Grid$Years, 
        sqrt(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids), 
        col='red',pch=19,cex=0.5)
abline(fral.lm.sqrt, col="red", lwd=2.5)
abline(assoc.lm.sqrt, lwd=2.5)
lines(x.fh,predict(fral.lm2.sqrt,data.frame(Years=x.fh)),
      lwd=2,col='red',lty=2)
# lines(x,predict(assoc.lm2.sqrt,data.frame(Years=x)),
#       lwd=2.5,lty=2)
# lines(x.fh,predict(fral.lm3.sqrt,data.frame(Years=x.fh)),
#       lty=4,lwd=2.5,col='red')
lines(x,predict(assoc.lm3.sqrt,data.frame(Years=x)),
      lty=4,lwd=2)
# legend( 1980, 4.5,
#         c('Linear','Quadratic','Cubic'),
#         lwd=c(2.5,2.5,2.5),
#         lty=c(1,2,4)
#)
legend( 1950, 4.5,
        expression('Assoc. Spec',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
## Growth Rate Difference
plot( FRAL.Herb.Assoc.allYrs.Overlap$Years,
      FRAL.Herb.Assoc.allYrs.Overlap$Cumm.Grid.R.Diff,
      pch=19,
      #ylim=c(-.5,.5), # This cuts off one extreme point at > 1.5
      ylim=c(.8,1.2), # This cuts off one extreme point at > 1.5
      xlab='',
      ylab='Ratio of growth rate of cumulative occ. grids' )
abline(h=1,lwd=2.5,col='red',lty=5)
points(1884:2005,Cum.Grid.R.Diff,
       pch=19,
       cex=0.75,
       col='red')
# legend( 1950, .9,
#         c('Ratio - Annual R','Ratio - Mov.Win. R Ratio'),
#         pch=c(1,19),
#         col=c('black','darkred')
# )
## Ratio vs time
plot( FRAL.Herb.Assoc.allYrs.Overlap$Years,
      FRAL.Herb.Assoc.allYrs.Overlap$AOO.Ratio,
      pch=19,
      cex=0.5,
      xlab='Year',
      ylab='Ratio of Cumulative Occupied Grid Cells',
      xlim=c(1869,2012)
)
#dev.off()

## Cumulative Number of Counties through time 
## ******************************************************************** ##
#pdf('figures/Cumulative_Counties_Figure.pdf')
#pdf( "figures/Diss_Fig_3_6.pdf", width=6.5, height=6.5, family="Times" )
par( mfrow=c(2,2), mar=c(4,4,0.5,1), ps=12 )
## Plot the **sqrt** of the cumulative number of counties through time
plot(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years,
     sqrt(Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties),
     xlab="Year",
     ylab="Sqrt-Cumulative Occupied Counties",
     pch=19,
     cex=0.5)
points(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years,
       sqrt(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties),
       col='red',
       pch=19,
       cex=0.5)
lines(x.cnty.assoc,predict(assoc.cnt.lm,data.frame(Years=x.cnty.assoc)),
      lwd=2.5)
lines(x.cnty.assoc,predict(assoc.cnt.lm3,data.frame(Years=x.cnty.assoc)),
      lwd=2.5,lty=2)
lines(x.cnty.fral,predict(fral.cnt.lm,data.frame(Years=x.cnty.fral)),
      lwd=2.5,col='red')
lines(x.cnty.fral,predict(fral.cnt.lm3,data.frame(Years=x.cnty.fral)),
      lwd=2.5,col='red',lty=2)
legend( 1930,3.2,
        expression('Assoc. Spec',italic('F. alnus')),
        pch=c(19,19),
        col=c('black','red')
)
## Plot the ** Difference** in Growth Rate Results
plot( Cumm.Cnty.Combined.df$Years,
      Cumm.Cnty.Combined.df$Cumm.Cnty.R.Diff,
      pch=19,
      #ylim=c(-.5,.5), # This cuts off one extreme point at > 1.5
      ylim=c(0.8,1.2),
      xlab='Year',
      ylab='Ratio of growth rate of cumulative occ. counties' )
abline(h=1,lwd=2.5,col='red',lty=5)
points(1884:2000,Cum.Cnty.R.Diff,
       pch=19,cex=0.75,col='red')
## Plot Ratio Results
plot( Cumm.Cnty.Combined.df$Years,
      Cumm.Cnty.Combined.df$AOO.Ratio,
      pch=19,
      cex=0.5,
      xlab='Year',
      ylab='Ratio of Cumulative Occupied Counties',
      xlim=c(1836,2005)
)
#dev.off()

## ******************************************************************** ##
## Make multi-panel figures to include in J. Torr. Bot. submission (5.5 in)
## ******************************************************************** ##

## Cumulative Number of Records through time 
## ******************************************************************** ##
pdf( "manuscript/Figure_3.pdf", width=5.5, height=5.5, family="Times" )
#par( mfrow=c(2,2), mar=c(2,4,2,1), ps=12 )
m <- rbind(c(5,6),c(1,2),c(1,2),c(1,2),c(1,2),c(3,4),c(3,4),c(3,4),c(3,4))
layout(m)
par(mar=c(4,4,1,2))
## Log Cumulative Records vs Time
x <- seq( min(Records.Cumm.All$Years),
          max(Records.Cumm.All$Years),
          l=length(Records.Cumm.All$Years) )
plot( Records.Cumm.All$Years,
      log(Records.Cumm.All$CummRec.Assoc),
      xlab='',
      ylab='Log-Cumulative Records',
      xlim=c(1836,2012),
      pch=3,
      cex=.8)
points( Records.Cumm.All$Years,
        log(Records.Cumm.All$CummRec.Fral.Herb),
        pch=17,
        cex=1,
        col='black')
abline(fral.rec.lm,lwd=2.5)
abline(assoc.rec.lm,lwd=2.5)
lines(x,predict(assoc.rec.lm2,data.frame(Years=x)),
      lwd=2.5,lty=4)
lines(x,predict(fral.rec.lm3,data.frame(Years=x)),
      lwd=2.5,lty=4)
legend( 1938, 2.25,
        expression('Assoc. spp.',italic('F. alnus')),
        pch=c(3,17),
        col=c('black','black')
)
mtext(expression(bold("A")), adj = 0, line = 1)
# Growth Rate Difference
plot(Records.Cumm.All$Years,Records.Cumm.All$Cumm.Rec.R.Diff,
     pch=3,
     #ylim=c(-0.5,0.5),
     ylim=c(0.8,1.2),
     xlim=c(1879,2010),
     xlab="",
     ylab='Cumulative record growth-rate ratio')
abline(h=1,lwd=2.5,col='black',lty=5)
#points(1888:2010,Cumm.Rec.R.Diff,
points(1890:2007,Cumm.Rec.R.Diff,
       pch=17,
       col='black',
       cex=1)
mtext(expression(bold("B")), adj = 0, line = 1)
# Ratio vs time
plot( Records.Cumm.All$Years[Recs.Match.Temp],
      #(log(Records.Cumm.All$CummRec.Fral.Herb[Recs.Match.Temp] /
      #      Records.Cumm.All$CummRec.Assoc[Recs.Match.Temp])),
      #(log(Records.Cumm.All$CummRec.Fral.Herb[Recs.Match.Temp]) /
      #       log(Records.Cumm.All$CummRec.Assoc[Recs.Match.Temp])),
      (Records.Cumm.All$CummRec.Fral.Herb[Recs.Match.Temp] /
         Records.Cumm.All$CummRec.Assoc[Recs.Match.Temp]),
      pch=19,
      cex=0.5,
      xlab='Year',
      ylab='Ratio of Cumulative Records',
      xlim=c(1836,2012))
mtext(expression(bold("C")), adj = 0, line = 1)
dev.off()

## Cumulative Number of Grid Cells through time 
## ******************************************************************** ##
pdf( "~/Dropbox/Projects/FRAL-herbarium/manuscript/Figure_4.pdf", width=5.5, height=5.5, family="Times" )
#par( mfrow=c(2,2), mar=c(2,4,2,1), ps=12 )
m <- rbind(c(5,6),c(1,2),c(1,2),c(1,2),c(1,2),c(3,4),c(3,4),c(3,4),c(3,4))
layout(m)
par(mar=c(4,4,1,2))
## Plot the **sqrt** Cumulative Occupied Grid Cell numbers
x.fh <- seq(min(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
            max(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years),
            l=length(FRAL.Herb.Loc.Overlap_Cumm.Grid$Years) )
x <- seq(min(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
         max(Associated.Spec.Loc.Overlap_Cumm.Grid$Years),
         l=length(Associated.Spec.Loc.Overlap_Cumm.Grid$Years) )
plot( Associated.Spec.Loc.Overlap_Cumm.Grid$Years,
      sqrt(Associated.Spec.Loc.Overlap_Cumm.Grid$OccGrid),
      xlab='',
      ylab='Sqrt-Cumulative Occupied Grid Cells',
      pch=3,
      cex=0.8)
points( FRAL.Herb.Loc.Overlap_Cumm.Grid$Years, 
        sqrt(FRAL.Herb.Loc.Overlap_Cumm.Grid$OccGrids), 
        col='black',pch=17,cex=1)
abline(fral.lm.sqrt, lwd=2.5)
abline(assoc.lm.sqrt, lwd=2.5)
lines(x.fh,predict(fral.lm2.sqrt,data.frame(Years=x.fh)),
      lwd=2.5,lty=4)
# lines(x,predict(assoc.lm2.sqrt,data.frame(Years=x)),
#       lwd=2.5,lty=2)
# lines(x.fh,predict(fral.lm3.sqrt,data.frame(Years=x.fh)),
#       lty=4,lwd=2.5,col='red')
lines(x,predict(assoc.lm3.sqrt,data.frame(Years=x)),
      lty=4,lwd=2.5)
# legend( 1980, 4.5,
#         c('Linear','Quadratic','Cubic'),
#         lwd=c(2.5,2.5,2.5),
#         lty=c(1,2,4)
#)
legend( 1950, 5.5,
        expression('Assoc. Spec',italic('F. alnus')),
        pch=c(3,17),
        col=c('black','black')
)
mtext(expression(bold("A")), adj = 0, line = 1)
## Growth Rate Difference
plot( FRAL.Herb.Assoc.allYrs.Overlap$Years,
      FRAL.Herb.Assoc.allYrs.Overlap$Cumm.Grid.R.Diff,
      pch=3,
      #ylim=c(-.5,.5), # This cuts off one extreme point at > 1.5
      ylim=c(.8,1.2), # This cuts off one extreme point at > 1.5
      xlab='',
      ylab='Cumulative occ. grid growth-rate ratio' )
abline(h=1,lwd=2.5,col='black',lty=5)
points(1884:2005,Cum.Grid.R.Diff,
       pch=17,
       cex=1,
       col='black')
mtext(expression(bold("B")), adj = 0, line = 1)
## Ratio vs time
plot( FRAL.Herb.Assoc.allYrs.Overlap$Years,
      FRAL.Herb.Assoc.allYrs.Overlap$AOO.Ratio,
      pch=19,
      cex=0.5,
      xlab='Year',
      ylab='Ratio of Cumulative Occupied Grid Cells',
      xlim=c(1869,2012)
)
mtext(expression(bold("C")), adj = 0, line = 1)
dev.off()

## Cumulative Number of Counties through time 
## ******************************************************************** ##
pdf( "~/Dropbox/Projects/FRAL-herbarium/manuscript/Figure_5.pdf", width=5.5, height=5.5, family="Times" )
m <- rbind(c(5,6),c(1,2),c(1,2),c(1,2),c(1,2),c(3,4),c(3,4),c(3,4),c(3,4))
layout(m)
par(mar=c(4,4,1,2))
## Plot the **sqrt** of the cumulative number of counties through time
plot(Associated.Spec.Cnty.Overlap_Cumm.Cnty$Years,
     sqrt(Associated.Spec.Cnty.Overlap_Cumm.Cnty$OccCounties),
     xlab="Year",
     ylab="Sqrt-Cumulative Occupied Counties",
     pch=3,
     cex=0.8)
points(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$Years,
       sqrt(FRAL.Herb.Cnty.Overlap_Cumm.Cnty$OccCounties),
       col='black',
       pch=17,
       cex=1)
lines(x.cnty.assoc,predict(assoc.cnt.lm,data.frame(Years=x.cnty.assoc)),
      lwd=2.5)
lines(x.cnty.assoc,predict(assoc.cnt.lm3,data.frame(Years=x.cnty.assoc)),
      lwd=2.5,lty=2)
lines(x.cnty.fral,predict(fral.cnt.lm,data.frame(Years=x.cnty.fral)),
      lwd=2.5,lty=4)
lines(x.cnty.fral,predict(fral.cnt.lm3,data.frame(Years=x.cnty.fral)),
      lwd=2.5,lty=4)
legend( 1933,3.7,
        expression('Assoc. Spec',italic('F. alnus')),
        pch=c(3,17),
        col=c('black','black')
)
mtext(expression(bold("A")), adj = 0, line = 1)
## Plot the ** Difference** in Growth Rate Results
plot( Cumm.Cnty.Combined.df$Years,
      Cumm.Cnty.Combined.df$Cumm.Cnty.R.Diff,
      pch=3,
      #ylim=c(-.5,.5), # This cuts off one extreme point at > 1.5
      ylim=c(0.8,1.2),
      xlab='Year',
      ylab='Cumulative occ. county growth-rate ratio')
abline(h=1,lwd=2.5,col='black',lty=5)
points(1884:2000,Cum.Cnty.R.Diff,
       pch=17,cex=1,col='black')
mtext(expression(bold("B")), adj = 0, line = 1)
## Plot Ratio Results
plot( Cumm.Cnty.Combined.df$Years,
      Cumm.Cnty.Combined.df$AOO.Ratio,
      pch=19,
      cex=0.5,
      xlab='Year',
      ylab='Ratio of Cumulative Occupied Counties',
      xlim=c(1836,2005)
)
mtext(expression(bold("C")), adj = 0, line = 1)
dev.off()
