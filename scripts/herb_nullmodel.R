## ************************************************************************** ##
## herb_nullmodel.R
##
## Author: Matthew Aiello-Lammens
## Date Created: 2018-04-20
##
## Purpose:
## Run a null model for the herbarium research projec
##
## ************************************************************************** ##

library(dplyr)

## Source the herb_main.R script
source("scripts/herb_main.R")

## ******************************************************************** ##
## Use reduced datasets for FRAL.Herb and Associated.Spec based
## on the following two criteria:
## 1. Records are georeferenced at a spatial resolution **FINER than County**
## 2. Records are in a 30 arc minute grid cell that contains both FRAL and at
##    least one Associated Spec record over the study period - 1879 to present
##
## THESE DATA ARE USED FOR THE CUMULATIVE GRID CELLS THROUGH TIME
## ANALYSIS
## ******************************************************************** ##

## Merge the Fral and Assocaited species data
## These data sets are:
## * FRAL.Herb.Loc.Overlap
## * Associated.Spec.Loc.Overlap
FRAL.Herb.Loc.Overlap$dataset <- "FRAL"
Associated.Spec.Loc.Overlap$dataset <- "ASSOC"

Loc.Overlap.Combined <- rbind(FRAL.Herb.Loc.Overlap, Associated.Spec.Loc.Overlap)

## -------------------------------------------------------------------------- ##
## Null model construction
## ***
## Randomize the combined FRAL and Associated species datasets, then calculate
## the ratio values
## -------------------------------------------------------------------------- ##

## Set the number of randomizations
num_randoms <- 999

FRAL.Herb.Assoc.allYrs.Overlap_NULL <- vector()

for (iter in 1:num_randoms){
  
  ## Make a copy of the dataset
  LOC.temp <- Loc.Overlap.Combined
  
  ## Shuffle the dates for the observations
  LOC.temp$CollectionYear <- sample(LOC.temp$CollectionYear)
  
  ## Shuffle the grid cells
  LOC.temp$GridID <- sample(LOC.temp$GridID)

  ## Calculate the cumulative number of occupied grid cells through time for the temp dataset
  FRAL.Herb.Loc.Overlap_Cumm.Grid_TEMP <- 
    make.cummgrids.allYrs( make.cummgrids.dfYrs( dplyr::filter(LOC.temp, dataset == "FRAL") ))
  Associated.Spec.Loc.Overlap_Cumm.Grid_TEMP <-
    make.cummgrids.allYrs( make.cummgrids.dfYrs( dplyr::filter(LOC.temp, dataset == "ASSOC") ))


  ## Merge the datasets for Fral and ALL based on overlapping years
  # --this merge results in columns with names OccGrids.x and
  # --OccGrids.y, so I rename the columns
  FRAL.Herb.Assoc.allYrs.Overlap_TEMP <-
    merge( FRAL.Herb.Loc.Overlap_Cumm.Grid_TEMP, 
           Associated.Spec.Loc.Overlap_Cumm.Grid_TEMP, by="Years")
  names(FRAL.Herb.Assoc.allYrs.Overlap_TEMP) <- c('Years','FRAL.OccGrids','Assoc.OccGrids')
  ## Calcualte ratio of area (sensu Delisle et al 2003)
  FRAL.Herb.Assoc.allYrs.Overlap_TEMP$AOO.Ratio <-
    FRAL.Herb.Assoc.allYrs.Overlap_TEMP$FRAL.OccGrids / FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Assoc.OccGrids
  ## Calculate total grid counts
  FRAL.Herb.Assoc.allYrs.Overlap_TEMP$TotalGrids <-
    FRAL.Herb.Assoc.allYrs.Overlap_TEMP$FRAL.OccGrids + FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Assoc.OccGrids
  
  ## Now calculate annual 'growth rates' for growth in the number of 
  ## grid cells occupied
  # Get a matrix for number of grids at time point t+1
  t.plus.1_TEMP <- as.matrix(FRAL.Herb.Assoc.allYrs.Overlap_TEMP[-1,c('FRAL.OccGrids','Assoc.OccGrids')])
  # Get a matrix for number of grids at time point t
  t.pres_TEMP <- as.matrix(FRAL.Herb.Assoc.allYrs.Overlap_TEMP[-length(FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Years),
                                                     c('FRAL.OccGrids','Assoc.OccGrids')])
  ## Calculate annual R values
  Cumm.Grid.R_TEMP <- t.plus.1_TEMP/t.pres_TEMP
  # Add a first Row of NA values
  Cumm.Grid.R_TEMP <- rbind( rep(NA,2), Cumm.Grid.R_TEMP )
  # Add names to the columns
  colnames(Cumm.Grid.R_TEMP) <- c('Fral.Cumm.Grid.R','Assoc.Cumm.Grid.R')
  # Add these columns to teh Grid.Cumm.All data.frame
  FRAL.Herb.Assoc.allYrs.Overlap_TEMP <- 
    data.frame(FRAL.Herb.Assoc.allYrs.Overlap_TEMP,Cumm.Grid.R_TEMP)
  ## Clean up
  rm(Cumm.Grid.R_TEMP,t.plus.1_TEMP,t.pres_TEMP)
  
  ## Calculate the **difference** in growth rate
  # FRAL.Herb.Assoc.allYrs.Overlap$Cumm.Grid.R.Diff <-
  #   FRAL.Herb.Assoc.allYrs.Overlap$Fral.Cumm.Grid.R - FRAL.Herb.Assoc.allYrs.Overlap$Assoc.Cumm.Grid.R
  FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Cumm.Grid.R.Diff <-
    FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Fral.Cumm.Grid.R / FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Assoc.Cumm.Grid.R
  
  # ## Calculate the 10-year moving average window of R
  # # First make a reduced dataset that only has values when both
  # # FRAL and Assoc R is not an NA
  # Cum.Grid.R_TEMP <- 
  #   FRAL.Herb.Assoc.allYrs.Overlap_TEMP[ which(!is.na(FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Assoc.Cumm.Grid.R) & 
  #                                           !is.na(FRAL.Herb.Assoc.allYrs.Overlap_TEMP$Fral.Cumm.Grid.R)), ]
  # # For FRAL this will start in 1881
  # Cum.Grid.Fral.MA_TEMP <- rollapply(data=Cum.Grid.R_TEMP$Fral.Cumm.Grid.R,width=10,align='center',FUN=geometric.mean)
  # Cum.Grid.Assoc.MA_TEMP <- rollapply(data=Cum.Grid.R_TEMP$Assoc.Cumm.Grid.R,width=10,align='center',FUN=geometric.mean)
  # Cum.Grid.R.Diff_TEMP <- Cum.Grid.Fral.MA_TEMP/Cum.Grid.Assoc.MA_TEMP
  
  ## Add this dataset to the null model dataset
  FRAL.Herb.Assoc.allYrs.Overlap_TEMP$iter <- iter
  FRAL.Herb.Assoc.allYrs.Overlap_NULL <-
    rbind(FRAL.Herb.Assoc.allYrs.Overlap_NULL, FRAL.Herb.Assoc.allYrs.Overlap_TEMP)
  
}

## Plot the cummulative grid cells through time
nullmod_cum_AOO <-
  ggplot() +
  geom_line(data = FRAL.Herb.Assoc.allYrs.Overlap_NULL, 
            aes(x = Years, y = sqrt(Assoc.OccGrids), group = iter), 
            color = "grey50", alpha = 0.1) +
  geom_line(data = FRAL.Herb.Assoc.allYrs.Overlap_NULL, 
            aes(x = Years, y = sqrt(FRAL.OccGrids), group = iter), alpha = 0.1) +
  geom_line(data = FRAL.Herb.Assoc.allYrs.Overlap,
            aes(x = Years, y = sqrt(Assoc.OccGrids)), 
            color = "grey50", size = 1, linetype = "dashed") +
  geom_line(data = FRAL.Herb.Assoc.allYrs.Overlap,
            aes(x = Years, y = sqrt(FRAL.OccGrids)), 
            color = "black", size = 1, linetype = "dashed") +
  theme_bw() + 
  theme( text=element_text( size=11, family="Times") ) +
  labs(y = "Sqrt-Cumulative Occupied Grid Cells", 
       x = "Year")
print(nullmod_cum_AOO)

## Calculate the mean AOO ratio through time for the Null model
FRAL.Herb.Assoc.allYrs.Overlap_NULL_Summary <-
  FRAL.Herb.Assoc.allYrs.Overlap_NULL %>%
  group_by(Years) %>%
  dplyr::summarise(AOO.Ratio.Mean = mean(AOO.Ratio))

## Plot the Ratio through time
nullmod_ratio_AOO <-
  ggplot() +
  geom_line(data=FRAL.Herb.Assoc.allYrs.Overlap_NULL,
            aes(x = Years, y = AOO.Ratio, group = iter), 
            alpha = 0.1, color = "grey50") +
  geom_point(data=FRAL.Herb.Assoc.allYrs.Overlap_NULL_Summary, 
             aes(x = Years, y = AOO.Ratio.Mean), 
             color = "black", shape = 1) +
  geom_point(data=FRAL.Herb.Assoc.allYrs.Overlap,
             aes(x = Years, y = AOO.Ratio), color = "black") +
  ylim( c(0, 1.5) ) +
  theme_bw() +
  theme( text=element_text( size=11, family="Times") ) +
  labs(y = "Ratio of Cumulative Occupied Grid Cells",
       x = "Year")
print(nullmod_ratio_AOO)

library(cowplot)
plot_grid(nullmod_cum_AOO, nullmod_ratio_AOO, 
          labels = c("A", "B"), label_fontfamily = "Times")
ggsave(filename='~/Dropbox/Projects/FRAL-herbarium/manuscript/Figure_6.pdf', device = "pdf",
       width=5.5, height=3.5, units = "in")
