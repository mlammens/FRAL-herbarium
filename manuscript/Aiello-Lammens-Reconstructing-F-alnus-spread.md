**Author:** Matthew E. Aiello-Lammens

**Title:** Analysis of information from multiple herbarium calls into question existence of lag-phase in spread of *Frangula alnus* in North America

<!---
Maybe this paper is better described as "taking advantage of data with low spatial resolution to account for sampling effort in studies using herbaria records".
-->

**Affiliation:**

**Email of corresponding author:** matt.lammens@gmail.com; 631-327-2371

<!---
Check Notebook entry for 2016-02-01
-->

**\
**

# Abstract

Analysis of herbaria records allows for an examination of patterns of spatial spread of non-native plants in novel ranges, aiding in understanding the processes that govern non-native species invasions. 
**Additional transitional statement.**
I used herbaria records to investigate the rate of spread and pattern of establishment for the invasive plant Frangula alnus (Glossy Buckthorn) in northeastern and middle North America.  
F. alnus is a perennial woody shrub of concern to land managers throughout the invaded range.  
I collected accession records from online databases and requests to curators of herbaria throughout North America, resulting in >700 records of F. alnus covering a temporal range from ca. 1880 - Present and a spatial range broadly covering the entire invaded area in northeast North America.  
I addressed unequal sampling effort by comparing temporal and spatial patterns of F. alnus accessions to patterns in a group of ecologically similar native species. 
I found evidence for the potential of multiple initial introductions into North America, that were greatly separated geographically, ranging from southern Ontario to coastal New York and New Jersey. 
Trends in record collection in time and space show the rate of spread of F. alnus was initially slow, then increased rapidly during the early 20th century, and reached a relatively constant rate of spread in the later 20th century. 
Examining the spread of this species at the continental scale, there is little evidence that it experienced an extended lag phase between phases of establishment and rapid spatial spread, in contradiction to previous reports. 
Rather, it appears that F. alnus has steadily increased in area of occupancy since ca. 1920 to the present. 

**\
**

# Introduction

The population dynamics of a non-native species that transitions from establishing in a novel region to one that shows rapid growth in abundance and occupied area often go unobserved. 
We are left to piece together ‘what happened’ by examining emerging patterns taken from snapshots in time. 

~~Despite decades of research on invasive species, we still lack a full understanding of population dynamics during the transition from establishment of self-sustaining populations in a novel region to the rapid growth in abundance and expansion of area of occupancy.~~
From field observations and patterns in historical data, it is generally noted that the time from establishment to rapid spread is longer than a generation time for many invasive species.
This period is thought to be one in which population growth, both in numbers and area, is relatively small, and is commonly referred to as the lag phase [@Kowarik1995; @Crooks1999; @Sakai2001; @Crooks2005; @Pysek2005; @Theoharides2007].
Because the lag phase is associated with a period early in the invasion process, management actions taken during this time have the potential to be most affective at mitigating the negative impacts of a species invasion.

To understand processes governing population dynamics during a lag phase, it is first necessary to identify this period.
Quantifying the lag phase for a species has many challenges.
Assuming a non-native species establishes in an environment suitable for growth and reproduction, and ignoring potential positive density dependence effects (i.e.
Allee effects), population size should initially increase exponentially (Figure 1A).
Exponential growth is described as *N(t) = N(0) R^t^*, where *t =* time-step, *N(t)* = the population size at time-step *t*, and *R* is the population growth rate.
Looking at a plot of population size through time for an exponentially growing population suggests that early on the population size is relatively similar to *N(0)* (Figure 1A; *R* = 1.2 for the black dots), which is followed by a transition to a period of rapid population increase.
Crooks and Soulé [@Crooks1999] describe this as “the shallow portion early in the growth curve when the population is growing relatively slowly in absolute number” and define it as the **inherent lag**.
This pattern is common to all exponential growth curves, and thus all growing populations should appear to have at least an inherent lag phase.
However, because a mathematical definition of inherent lag is lacking, it is challenging to apply this concept.
In the case of exponential population growth, a plot of the *log* of population size versus time shows a linear relationship (Figure 1B; *R* = 1.2 for black dots).
The population growth rate is constant through time and there is no distinct transition point that can define the shift from the inherent lag phase to the rapid population growth phase.

While an inherent lag is not explicitly defined mathematically, it serves as a contrast to the pattern of population growth showing an **extended lag**.
In this case, the population growth rate changes in time, with a lower rate earlier in time, followed by a higher rate later.
The grey dots in Figures 1A and B are growth curves for a population whose initial growth rate is *R = 1* and increases to *R = 1.2* during the first 20 time steps.
As with population growth with constant *R*, the curve of population size versus time is non-linear (Figure 1A).
However, in this case the curve of the log of population size versus time is also non-linear when *R* is increasing.
The non-linear portion of the curve, where the slope is shallow and the curve is concave up, is considered evidence for an extended lag [@Crooks1999].
Patterns of population growth for many invasive species match that expected for an extended lag phase.
The potential factors causing this are not well understood; several ecological and evolutionary processes may be involved [@Mack2000; @Sakai2001; @Pysek2005; @Gurevitch2011]
An extended lag may be explained by time constraints intrinsic to population growth and establishment, such as generation time and time to first reproduction (i.e., the time required for a population to achieve a stable age distribution).
However, many observed extended lag phases are longer than can be explained by these processes.

In a recent study of weedy species in New Zealand, Aikio et al. [-@aAikio2010a] point out that while there are several proposed mechanisms that may explain extended lags, relatively little empirical work has been done to examine their validity.
Among the most well studied mechanisms in a theoretical context are the role of evolutionary adaptation of the invader during the lag phase, waiting time until a disturbance event avails resources to the invader, and the role of complex dispersal mechanisms (for a general review see [@Crooks2005]).
Historical biodiversity data from herbaria and museums could be applied to address this lack of empirical support and further our understanding of the population dynamics of the lag phase.
Additionally, retrospective spatial analyses can yield insights into the ecological processes involved in the spread non-native invasive species in novel regions.
For plant species, the specimen holdings of herbaria offer a rich source of data for these types of analyses.
Information from herbarium records are used in several studies to estimate species rates of spread through time and space [e.g., @Delisle2003; @Salo2005; @Miller2009; @Crawford2009; @Aikio2010a; @Lavoie2012], as well as to investigate native species range expansions beyond historical limits due to changing ecological conditions [e.g., @Feeley2011; @Feeley2012].

Despite their utility, analyzing these data present a number of challenges; and determining whether a species had an extended lag phase is not a trivial task.
One substantial challenge is that herbarium records may have been collected with unequal sampling effort in time and/ or space, resulting in biases.
For example, periods of high and low specimen collection for herbaria in general are well documented [@Prather2004].
There may also be herbarium specific trends, such as a peak in collection activity following the opening of a herbarium or an emphasis on regional specimen collection.
Other biases may emerge because of issues of convenience.
A noted pattern in natural history collections is the large number of specimens collected near museums, herbaria, botanical gardens, and academic centers, as well as urban areas in general, where there is a higher concentration of naturalists [@Hijmans2000; @Reddy2003; @Kadmon2004].
For plants collection, this is sometimes referred to as the “botanist effect”.
These potential biases make it difficult to determine if observed trends in herbarium collections (e.g., increased number of records through time) are indicative of changes in the population or range size of the species of interest, or rather, representative of trends in specimen collection.
For example, Catling and Porebski [-@Catling1994] found that observations of the plant *Frangula alnus* were generally concentrated around urban areas from the time this species was first observed in southern Ontario in the late 1800s up to the 1970s.
This pattern may be the result of the fact that botanists were located near these areas, and thus their collections tended to come from these areas, or it may be that *F. alnus* grows well in ecological conditions near urban areas (e.g., disturbed environments).
It is important to distinguish these patterns to use these data for understanding ecological processes of species invasions.

Analysis of herbarium records is generally more conducive to studying spatial spread, rather than population increase.
Though related, rates of spatial spread are not necessarily equivalent to rates of population growth.
This presents a challenge because whereas exponential growth is widely accepted as a null model for local population growth, there are multiple plausible null models for areal growth (i.e., spatial spread) for range expanding species.
One commonly used null model is the reaction-diffusion model, which results in a description of spatial growth as a function of the radius of the population.
The area of occupancy for a species spreading randomly on a landscape from a central point should increase geometrically, with an exponent of 2.
With this assumption, the square root of the area of occupancy through time for a spreading plant should have a linear relationship with respect to time, analogous to linearity after log transform for exponential growth.
While other null models have been proposed, the square root transformation is appropriate in most cases and used to examine historical data on spatial spread [@Crooks1999].

Given the promise of the utility of natural history collections in general [@Graham2004; @Anderson2012a], and herbaria in particular [@Lavoie2012], it is not surprising that the effects of unequal sampling effort have been discussed in recent studies using herbarium records.
Most methods used to address these effects compare the trends in the distribution of records for a species of interest to other species that have similar habitat requirements – i.e. associated species [Miller2009].
For example, Catling and Porebski [-@Catling1994] compared the pattern of collection records of *F. alnus* to that of *Rhamnus alnifolia* and showed that botanists were collecting specimens well outside of urban areas during the time frame of the introduction and early spread of *F. alnus*.
They thus concluded that *F. alnus* was in fact primarily located near urban areas during this time.
More recent developments in analysis methods make it possible to account for potential biases in a more robust manner than a simple visual comparison [e.g. @Delisle2003, @Aikio2010a].
These methods have been used to reconstruct patterns of range expansion for both non-native and native plants [e.g., @Miller2009; @Larkin2011].
At least one of these methods [i.e., @Aikio2010a] was specifically developed and applied to identify the existence, and estimate the duration, of lag phases for invasive plants.
Adopting and modifying these methods, I address some of the unanswered questions regarding the introduction and spread of the non-native invasive plant *F. alnus*. 


*Frangula alnus* is purported to have had an extended lag phase [@Catling1994; @Frappier2003b; @Larkin2011], and various mechanisms have been proposed to explain this observation.
Howell and Blackwell [-@Howell1977] suggested that the rapid expansion of *F. alnus* into Ohio, following an extended period of presence in the eastern United States, may be associated with the expansion of the non-native European starling.
Lending support to this idea, European starlings have recently been linked to the spread the non-native invasive plant *Celastrus orbiculatus* (Oriental bittersweet) [@Merow2011a], another woody fruit-bearing plant.
However, Catling and Porebski (-@Catling1994) pointed out that the spread of *F. alnus* in southern Ontario preceded the presence of European starlings, suggesting other mechanisms must be at play.
While Howell and Blackwell’s speculation concerns the spread of *F. alnus* throughout the state of Ohio (\>110,000 km^2^), Frappier and colleagues [-@Frappier2003b] speculate on a mechanism causing an observed extended lag phase in the invasion of a 250 m^2^ forest plot, suggesting that the lag may be due to “early selection and adaptation” to the local ecological conditions.
Despite these speculations, it remains unclear as to whether *F. alnus* did in fact have an extended lag phase.

In this study, I examined the range expansion of *F. alnus* throughout its novel range of northeastern North American.
I compiled a dataset of historical occurrence observations of *F. alnus* consisting primarily of herbarium records, but also including observations noted in the scientific literature.
Using these data I calculated metrics related to the rate of spatial expansion of *F. alnus* throughout northeast North America employing modified methods of [@Delisle2003] and [@Aikio2010a] to account for unequal sampling effort of herbarium records.
I hypothesized that my findings would support previous claims that *F. alnus* experienced an extended lag lasting from the time of its introduction (ca.
1860) to the early 1970s.
Many previous studies have used herbarium records to estimate rates of spread and examine spatial patterns of spread, but they have largely been limited to a regional focus.
In this study I investigated the range expansion of *F. alnus* throughout the entire novel range.
I expanded upon the methods of [@Delisle2003] to allow for incorporation of data from multiple herbaria, while still accounting for unequal effort in sampling.
Access to herbaria records and other historical biodiversity is increasing as more collections are digitized and made available to the public.
Having techniques to combine information from desperate sources, as I present here, will help maximize the use of historical biodiversity data.

**\
**

# Methods

## Presence records

I collected *F. alnus* presence records by 1) searching publicly available on-line databases of multiple herbaria, 2) requesting record information from curators and collection managers of various herbaria, 3) searching the Global Biodiversity Information Facility (GBIF), Canadian Biodiversity Information Facility (CBIF) and the Invasive Plant Atlas of New England (IPANE) databases, and 4) carrying out a literature search for all North American localities.
I used the keyword search terms “Frangula alnus” or “Rhammus frangula” in ISI Web of Science database in the literature search.
Only presence records that included information on the year and location (county level or finer) of observation were included in the final dataset.
I verified that each record was independent, as some sources included records from multiple institutions (e.g., IPANE). 
The final dataset included 752 presence records from 32 herbaria and 3 published papers (Table 1).


## Georeferencing of presence records

For all records that did not include latitude and logitude values, I used the geolocation information included to georeference where the specimen was collected. 
I primarily used the GoogleEarth software (Google Inc.) to georeference records (*sensu* Garcia-Milagros & Funk 2010), however some cases required additional searches on named locations, such as unique building names or geographic features.
The descriptive location information allowed for varying degrees of precision in the final latitude and longitude value assigned to a record.
At a minimum, all records of specimens collected in the United States included enough information to be assigned to the county in which the specimen was collected.
For records with only county level information, I assigned the US Census Bureau designated latitude and longitude values to the record.
For records of specimens collected in Canada, I relied on the information included with the specimen to assign county equivalent values.
For all records, I assigned the most precise location possible with the information available, and assigned location uncertainty values using guidelines from the Biogeomancer Consortium [-@BioGeomancerConsortium2006].
I used different subsets of the compiled dataset based on the spatial resolution of the presence record for subsequent analyses.

## Number of records through time

I examined the log-cumulative number of *F. alnus* presences through time as one way to determine if this species experienced an extended lag phase [*sensu* @Pysek1993; @Aikio2010a].
I fit linear, quadratic, and cubic regression lines to these data, and used a likelihood ratio test to determine the best-fit model.
I calculated an annual rate of growth for the cumulative number of presence records by dividing the cumulative number of records at year $t + 1$ by the cumulative number of records at year $t$.
The mean rate of growth was calculated as the geometric mean of the annual growth rates.
Additionally, I calculated 10-year moving window geometric mean growth rates, which minimizes the influence of extreme inter-annual fluctuations in growth rates.
This yielded more consistent rates of growth for the earliest period of the invasion, during which time calculations are based on a relatively small number of records.

## Area of occupancy through time

I examined the spatial pattern and rate of range expansion of *F. alnus* throughout North America in a multistep process.


**This section needs to be amended both here and in the code**
First I created a map of equal sized grid cells for the area of interest (Longitude: -97.0 – -62.0 degrees; Latitude: 38.0 – 48.0 degrees) using the Quantum GIS software [@QGIS_software].
Each grid cell was 5 x 5 arc minutes, which is generally reported as 10 x 10 km.
Because a unit of longitude is smaller at higher latitudes than at lower latitudes, the area of each grid cell decreases towards the poles.
The area for each grid cell ranges from ca. 67 km^2^ to ca. 57 km^2^.
**End amendment**


I used the R statistical programming environment [@RCoreTeam2012] with functions from the “raster”, “rgdal”, and “dismo” packages 
[@Hijmans2011a; @Hijmans2012b; @Keitt2012].
Each record was assigned membership to a grid cell based on its latitude and longitude value.
Grid cells were considered occupied if they contained at least one occurrence of *F. alnus*.
From these data I calculated total area occupied per decade and the cumulative area occupied from time of first introduction to the present.
For the latter, I assumed that once a grid cell was occupied, it would not later be unoccupied.
Similar assumptions were used in [@Pysek1995; @Weber1998; @Delisle2003].
Further, given the difficulty of removing *F. alnus* and the lack of reported successful eradications, I believe this is a reasonable assumption.
I calculated the rate of growth for the area of occurrence analogously to how I calculated the rate of growth of the number of records (see *Number of records through time*).
I substituted the cumulative number of records with the cumulative number of occupied grid cells and plotted the square-root of the cumulative number of grid cells versus time (years).
Assuming areal growth is a random diffusion process, this relationship should be linear [@Crooks1999].
A deviation from linearity that is concave up indicates a period of time when spatial spread is slower than random diffusion.
Alternatively, a concave down curve indicates a period when spatial spread is more rapid than random diffusion.
**These last two statements aren’t necessarily right – concave up should imply slower growth early, followed by acceleration, and vice-versa for concave down.**

## Occupied counties through time

Many records contained spatial information to identify only the county in which it was collected.
Additionally, georeferencing records to county requires substantially less time and effort than higher levels of precision.
Thus, analyzing spatial patterns of herbarium records at the county level makes the compilation and use of large datasets more achievable given limited time and resources, while still providing insights into the patterns and processes of species invasions [e.g., @Barney2006].
Similar to the calculations of *Area of occupancy through time*, I calculated the cumulative number of counties occupied through time for the compiled dataset.
Again, I assumed that once *F. alnus* was found in a county, the county was henceforth considered occupied.
I calculated the growth rate for the cumulative number of counties occupied in similar manner to how I calculated the rate of growth of the number of records (see *Number of records through time*).

## Accounting for unequal sampling effort in time and space

The potential effects of unequal sampling effort complicates the interpretation of patterns of historical presence locations.
These effects can be addressed by comparing trends for a species of interest to those for another species, or group of species, whose range and population size should be in equilibrium with their environment [e.g., native species, *sensu* @Delisle2003].
I examined trends in presence records for a group of native species with similar habitat requirements as *F. alnus*: Speckled Alder (*Alnus incana*), Smooth Alder (*Alnus serrulata*), Alderleaf Buckthorn (*Rhamnus alnifolia*), Meadow Willow (*Salix peiolarisi*)*,* Witch Hazel (*Hamamelis virginica* (syn. *macrophylla*)), and White Ash (*Fraxinus Americana*).
These species are woody plants likely to be observed in places with similar ecological conditions as where *F. alnus* is observed.
For example, Catling and Porebski [-@Catlin1994] compared the distribution of record collections for *R. alnifolia* and *F. alnus*.
Similarly, *Salix peiolaris* was used in a paired comparison with *F. alnus* in a study on the effects of invasive and native species on wetland species diversity [@Houlahan2004].
The other species in this group are found in ecological conditions conducive to the growth of *F. alnus* [personal observations; @Little1980; @Sibley2009].
To construct the associated species dataset, I searched GBIF for all records that were located within the area of interest described in *Area of occupancy through time*.
Additionally, I collected all records for these species reported in the University of Wisconsin, Ohio State University, University of Minnesota, Morton Arboretum, Michigan State University, and Brooklyn Botanic Gardens herbaria.
In total, I compiled 5548 associated species records.
These records were georeferenced to the county level.
Grouping these records, I calculated the number of records through time, the area of occupancy through time, and the number of counties occupied through time, as described above.

I compared patterns of change in area of occupancy and counties occupied through time for *F. alnus* versus the associated species following a similar approach as Delisle et al. [-@Delisle2003]. 
I divided the occupied area (number of counties) of *F. alnus* by that for the associated species separately for annual time steps spanning 1879 to 201X, which yielded a proportion of non-native to native occupied area for each year of the study period.
Assuming the increases in area of occupancy of native plants through time represents an increase in spatial coverage of herbaria records in general, rather then the spread for those plants *per se*, then we can using changes in this proportion as a measure of the rate of spread of *F. alnus*.
Specifically, if the proportion increases through time, this then represents periods during which the spatial coverage of records for the non-native plant outpaces the background increase in spatial coverage [@Delisle2003], which can be interpreted as the result of rapid spatial spread.

In this study, I was interested in examining the spread of *F. alnus* across a larger region than this method has been applied to previously [e.g., @Delisle2003].
A corresponding complication was my dataset consisted of records from multiple herbaria across the naturalized range. 
<!---
Delisle also used records from multiple herbaria (5 in Quebec and 2 country wide), so what's different about what I did? Here are a few thoughts:
* The herbaria used in my study a quite a bit more geographically disperate than those in Delisle.
* Background are considered only at the county level. 
* I'm not sure what the patterns would look like if I only used points with lat/lon values. That is, if I don't use the county level approach for the background. This is really the key difference between Delisle and my study.
-->

### Key addition to previously reported methods

As such, several presence records for the group of associated species being located in areas where *F. alnus* has not been observed; likely the result of larger niche breadths for some of the associated species (e.g., *Fraxinus americana* (White Ash)
*Add citation into final draft: Kartesz, J.T., The Biota of North America Program (BONAP).
2013. *North American Plant Atlas.* (http://www.bonap.org/napa.html). Chapel Hill, N.C. [maps generated from Kartesz, J.T. 2013. Floristic Synthesis of North America, Version 1.0. Biota of North America Program (BONAP). (in press).* 
Including these records increased the area of occupancy measures for the group of associated species compared to the possible area of occupancy for *F. alnus*.
Similarly, associated species records were not collected from all of the herbaria from which *F. alnus* records were collected.
Thus some *F. alnus* occurrence locations were not were not represented well in the group of associated species dataset.
This could falsely increase the area of occupancy of *F. alnus* compared to the possible area of occupancy for the group of associated species.
To account for both of these issues, I examined the ratio of cumulative area of occupancy of *F. alnus* to the cumulative area of occupancy of the associated group of species, limiting the records used to an area of coarse spatial overlap for both datasets.
I defined the spatial overlap by creating a map of equal sized grid cells, again for the area of interest defined above, where each grid cell was 30 x 30 arc minutes (i.e., 0.5° or approximately 50 x 50 km).
As described in *Area of occupancy through time*, each record was assigned membership to one 30’ grid cell based on its latitude and longitude value.
I then constructed restricted *F. alnus* and associated species occurrence datasets, in which only records that occurred in a 30’ grid cell occupied by at least one record from *both* datasets during the study period.
Using these restricted datasets, I calculated the ratio of the increase in the cumulative area of occupancy of *F. alnus* to the group of associated species.
In a separate analysis I compared the cumulative number of counties occupied through time, while accounting for similar concerns regarding falsely sampling regions in space that are unsuitable to *F. alnus*.
I only included records from counties that were occupied at some time by both *F. alnus* and one of the associated plants.
In this case, the ratio of the cumulative number of counties occupied at the end of the study period is equal 1.0.
The growth rates for the cumulative number of grid cells occupied and the cumulative number of counties occupied were compared between *F. alnus* and the group of associated species.
To compare the growth rates I divided the annual growth rate of *F. alnus* records by the annual growth rate of the entire group of associated species.


**\
**

# Results


*Frangula alnus* specimens have been collected in much of northeast and middle North America (Figure 2), and collection locations for the group of associated species was largely inclusive of where *F. alnus* was collected.
The earliest dated occurrence record for *F. alnus* was 1879 in Hudson County, New Jersey (accessed from CHRB).
The earliest dated occurrence record for one of the associated species was 1836 for *H. virginiana* in Richland County, Ohio (accessed from CM).
Thirty-six associated species records pre-dated the first *F. alnus* record, representing less than 1% of the associated records.
A total of 14 *F. alnus* specimens were deposited in 4 separate herbaria prior to 1900; 12 were collected in the greater New York City region and 2 were collected in southern Ontario [as reported in @Catling1994].
The number of herbarium specimens collected for both *F. alnus* and the group of associated species increased through time (Figure 3).
For the group of associated species, there was a substantial increase at the beginning of the 20^th^ century, followed by another increase after 1950.
For *F. alnus*, there was a steady increase in the number of records per decade from the time of the first recorded presence to the end of the 20^th^ century.
Both groups showed a dramatic decline in the number of records at the start of 21^st^ century, which fits general patterns these types of data [@Prather2004].


The cumulative number of occupied 5 arc min grid cells for *F. alnus* and the associated species, constrained to overlap within 30 arc min grid cells, increased through time for both datasets (Figure 5).
A plot of the square root of cumulative occupied grid cells versus time showed a departure from a simple diffusion model of spatial spread (Figure 5A).
Based on likelihood ratio tests, the best-fit regression models were a quadratic polynomial regression for *F. alnus* (R^2^ = 0.996, df = 129, P \<\< 0.05) and a cubic polynomial regression for the associated species (R^2^ = 0.990, df = 140, P \<\< 0.05), indicating a departure from linearity for both.
The rate of increase in occurrence records was low for both *F. alnus* and the associated species until 1890, after which occupancy rapidly increased for the associated species.
In contrast, occupancy increased slowly for *F. alnus* until approximately 1920, as  demonstrated by the ratio between the two growth rates (Figure 5B).
Prior to 1915, with the exception of the earliest years of the invasion, the rate at which new grid cells were considered occupied by *F. alnus* was lower than the corresponding rate for the group of associated species.
From 1915 to the present, this rate was consistently higher for *F. alnus* than the associated species.
The ratio of the cumulative number of occupied grid cells of *F. alnus* to the associated species shows that after approximately 1910 the rate at which *F. alnus* increased in area of occurrence was greater than that of the group of associated species (Figure 5C).

Trends in the cumulative number of counties occupied were similar to the results for cumulative number of occupied grid cells.
In this analysis, I subset the compiled records dataset for both *F. alnus* and the associated species to include records from counties that were occupied by both during the study period.
The number of counties where herbarium samples were collected increased very rapidly during the late 19^th^ to early 20^th^ century.
However, the number of counties where *F. alnus* was found increased very slowly during the early part of the 20^th^ century, but rapidly after 1940 (Figure 6A).
A cubic polynomial regression model was the best fit model for both the associated species (R^2^ = 0.967, df = 166, P \< 0.001) and *F. alnus* (R^2^ = 0.997, df = 130, P \< 0.001), when compared to linear and quadratic models using likelihood ratio tests.
The difference in the rate of growth of cumulative occupied counties between *F. alnus* and the associated species shows a similar pattern to that reported for cumulative occupied grid cells (Figure 6B).
The rate at which counties are considered occupied is slower for *F. alnus* than the associated species early in the invasion history (prior to 1900) and faster during most of the 20^th^ century (Figure 6B).
The ratio of occupied counties of *F. alnus* to those occupied by the associated species indicates that early in the invasion history, *F. alnus* was less frequently collected in newly sampled counties, but that for most of the 20^th^ century the number of counties occupied by *F. alnus* has increased more rapidly than the number of counties occupied by associated species (Figure 6C).


# Discussion

## Early observations and likely region of first introduction

The precise ways in which *F. alnus* was introduced to North America remain unclear.
Based on its long history of use as a medicinal plant (United States Pharmacopeial Convention 1910) and evidence that it was planted as an ornamental shrub [@Sherff1912; 
**Add reference to Sudworth and Fernow: (Sudworth, G.B. and B.E. Fernow.  1891.  *Trees of Washington, D.C.*, compliments of the Forestry Division. Geo. B. Sudworth, botanist ; B. E. Fernow, chief.  Washington, D.C.: Bell Lithographing Co.  [18] pp.; 2 folding plans; 14 x 22 cm.)**], it is likely *F. alnus* was intentionally planted in many locations.
In fact, low fertility cultivars of *F. alnus* are still available for purchase [@Jacquart2010].
A thorough investigation of seed catalogs and nursery records from the late 19^th^ century may shed more light on when and where it was planted, but was beyond the scope of this project.
As is the case with many non-native species, there is little documented evidence of the time(s) or place(s) that *F. alnus* was introduced.
My findings suggest that a potential location of first introduction was the metropolitan New York City area and areas of New Jersey along New York Harbor.
This corresponds to previous reports of the first introduction being in "the eastern states" [@Howell1977].
Specimens for 12 of 14 records dating from before 1900 were collected in this region.
However, locations in southern Ontario account for the remaining 2 of 14 records dating before 1900, indicating that introduction into that region was also early in its spread.
It is interesting to note that the region the first recorded observations come from was a large shipping and port area, raising the possibility that shipping played a role in an accidental introduction.
Many non-native plants have been introduced to port areas by the unloading of solid ballast, with seeds mixed in with rocks and other materials used as ballast [@Sorrie2005; @Barney2006).
However, the historically high population density of this region also increases the chances that individuals may have purposely planted *F. alnus*.


## Accounting for unequal sampling effort in historical biodiversity collections

Using historical biodiversity collections to reconstruct patterns of species presence presents many challenges.
One of the most common is the presence of unequal sampling effort [@Reddy2003; @Kadmon2004; @Boakes2010].
For herbaria in particular, there are many reasons for unequal sampling effort in specimen collection, some of which have been discussed above (i.e. the ‘botanist effect’).
Another potential cause is herbaria specific emphasis on regional collections.
For example, the Oberlin Herbarium collection (housed in the Ohio State Herbarium) includes several thousand records primarily collected from within the state of Ohio.
Thus, confronted with numerous records of *F. alnus* in Ohio in the compiled dataset, it is hard to discern if conditions in Ohio are favorable for establishment and spread of buckthorn, or if this region is simply better sampled than others.
There may also be unequal sampling effort associated with taxonomic grouping.
There are numerous examples of collections of orchids, bryophytes, mosses, and ferns, which are all groups of particular interest to plant collectors.
In this case, woody plants are likely to be underrepresented.

Calculating the ratio of the cumulative number of records in space and time of non-native to native plants offers a way to account for unequal sampling effort, making it possible to distinguish periods of relatively slow versus rapid spread [@Delisle2003].
The primary assumption of this correction method is that native species are in equilibrium with their environment prior to the collection of any records.
That is, these plants inhabit all of the ecological conditions within the study range where they can survive and reproduce, and have a stable range distribution.
There are some caveats to this assumption, perhaps the most important being that the ecological conditions in northeast North America have not been stable over the last 130 years.
There have been substantial changes in land use, resulting in changes to plant communities [@Wright2010], as well as affecting plant invasion dynamics [@Mosher2009].
However, given that here the species I chose for the group of associated species have similar ecological requirements as *F. alnus*, I expect that any such changes would affect trends in these species and *F. alnus* equally.

**THIS SECTION SEEMS REPETATIVE**

Provided the equilibrium assumption is true for the group of associated species in this study, then the rate of the cumulative number grid cells or counties occupied is not representative of the spread of these plants *per se*, but rather of the effort of specimen collectors.
As such, if the ratio of cumulative records of *F. alnus* to the associated species is increasing in time, this indicates a period during which *F. alnus* is increasing more rapidly than background sampling, and thus experiencing positive growth rates.
If the ratio is constant, *F. alnus* may be increasing, however it is not distinguishable from sampling effort.
If the ratio is decreasing, *F. alnus* may still be increasing, but more slowly than the rate of sampling effort.
Because the *cumulative* number of records was used in all three temporal trends calculated in this study, the absolute rate of change in samples cannot show a decline.
Time periods that have either decreasing or stable ratio values, which precede periods of increasing ratio values, may be considered lags.

*Cumulative records through time*

All three of the calculated ratio values suggest that *F. alnus*
increased since ca. 1920 even when increased sampling effort was taken
into account (Figures 4C, 5C, and 6C). The ratio of sample growth rates
also supports this claim. For all three trends, the ratio of ten-year
average growth rates was greater than 1.0 after 1920, indicating that
the number of *F. alnus* samples increased more rapidly than those of
the group of associated species (Figures 4B, 5B, and 6B). Prior to 1920,
both the ratio values of cumulative number of records and growth rates
fluctuated greatly. This may be the result of the relatively small
number of cumulative records for both *F. alnus* and the associated
species during this time. The addition of a small number of records to
either dataset could drastically change the ratio between them. The
accumulation of *F. alnus* occurrences had a particularly large effect
early in its invasion history, as is indicated by the ratio of growth
rates, in which generally *F. alnus* records increased more slowly than
the associated species from 1879 to the 1920s, but there are anomalous
years in which the growth rate of *F. alnus* was much larger than that
of the associated species (Figures 4B, 5B, and 6B). For example, when
the cumulative number of records for *F. alnus* increased from 4 to 10
from 1893 to 1894, the resulting growth rate was R = 2.5. Comparatively,
during this time the number of records for the associated species
increased from 171 to 191, resulting in a growth rate of R = 1.12. Thus,
it is difficult to determine if *F. alnus* did in fact start its
invasion with a very high growth rate, then immediately slowed, or
rather this result is an artifact of calculating growth rates with small
sample sizes. Based on the relative consistency of the total number of
records collected in each decade, there is more support for the latter
interpretation (Figure 3).

*Spatial spread and area of occupancy through time*

Given the equilibrium assumption of native species, if the cumulative
number of grid cells (and counties) occupied by the associated species
were appropriately represented by a random diffusion process (i.e.,
linear when regressing square root of the cumulative number of grid
cells onto time), this would imply that specimen collectors moved
randomly outward from a central point, e.g. an herbarium, collecting new
records as they went. Neither the cumulative number of grid cells nor
counties occupied fit such a relationship (Figures 5A and 6A). In both
cases, the trend can be described as concave up initially, followed by a
linear trend with a steep slope, followed by a concave down curve,
followed by another period of linearity. This suggests that the rate of
collections increased rapidly in the mid 19^th^ century, was high
throughout the second half of the 19^th^ century, and then decelerated
during the 20^th^ century. The cubic regression fits do not necessarily
support the presumption of an early concave up portion of the curve, but
do support the interpretation of a rapid rate of increase early in the
collection history, followed by a deceleration in collection rate.
However, more complex curve fitting such as GAM or piecewise linear
regression may more closely fit these data. Regardless, it is clear that
specimen collection rapidly spread across the landscape during the
19^th^ century. Combined with the increase in the cumulative number of
records during earlier part of the study period (Figures 3 and 4A),
these patterns suggest that this was a period of high sampling effort,
coinciding with the beginning of an intense effort to collect specimens
for herbaria (Prather et al. 2004).

The earliest occurrence records of *F. alnus* were collected during this
period of high sampling effort. However, it was uncommon across the
study region at this time, and appears to have remained uncommon until
at least the 1920s. Assuming that cumulative occurrence curves for the
associated species represent the spatial spread of collection effort,
and that a collector would collect *F. alnus* if it were present during
a survey, it appears that the rate of spatial spread during the early
19^th^ century of *F. alnus* was slow. This is most clearly exemplified
by the trends in cumulative number of counties occupied through time. On
average *F. alnus* was first observed 48 years after at least one of the
associated species was observed in a county occupied by both by the end
of the study period. By 1900, records for at least one of the associated
species was collected in 42% (73 of 172) of counties, where as *F.
alnus* was collected in 2% (4 of 172) of counties. This strongly
suggests that *F. alnus* was not common at this time. However, the ratio
of occurrence records shows a consistent rate of spread throughout the
novel range during the following 100 years.

*Evidence for an extended lag phase*

Compared to most previous studies, here I examined the spread of an
invasive species over a spatial area incorporating nearly all of the
known naturalized range. Examining the relative rates of increase in
occupied grid cells and occupied counties at this spatial scale, there
is no compelling evidence for an extended lag phase persisting beyond
the early 20^th^ century. All three analyses suggest that *F. alnus*
increased at a rate greater than sampling effort from at least 1920 on.
Given that the rate of increase in record number and spatial occurrence
for *F. alnus* was less than that of the associated species from 1880 to
1920, it is plausible that this period of time represents an extended
lag phase. However, trends calculated for this period are based on a
small number of *F. alnus* records, as is evident in the high
variability in both the ratio of growth rates and the ratio of records
or occupied area.

Three previous studies examined aspects of the range expansion of
*Frangula alnus* using herbarium records (Howell and Blackwell 1977,
Catling and Porebski 1994, Larkin 2011). Each focused on only part of
the invaded range. Howell & Blackwell (1977) examined the spread of *F.
alnus* (using the synonym *Rhamnus frangula*) into, and throughout,
Ohio. They found evidence that it likely entered Ohio in the 1920’s,
being observed first in Lake County (northeastern Ohio). The authors
speculate that the spread of *F. alnus* westward throughout Ohio was
facilitated by the range-expansion of the non-native European Starling.
Many bird species are noted to eat the fruit of *F. alnus* and defecate
undigested seeds, and European Starlings in particular have been known
to eat these fruit (Howell & Blackwell 1977). The authors did not
account for potential unequal sampling effort in herbarium records, but
rather simply reported when and where *F. alnus* first appeared in Ohio.
Catling & Porebski (1994) examined the historical spread of *F. alnus*
in southern Ontario, Canada (also using the synonym *R. frangula*) and
found that it was first recorded in London, Ontario in 1898 and Ottawa
in 1899. Their data suggested that *F. alnus* spread to other urban
centers, but primarily remained confined to these areas until the
1970’s. From the 1970’s to the early 1990’s *F. alnus* spread into
natural areas outside of urban areas at an increased rate compared to
the previous 70 years. The authors suggest that this observation is
indicative of a lag phase in the spread of *F. alnus*, though no
quantitative analysis was carried out. To address potential biases
resulting from unequal sampling efforts, specifically for records
collected prior to 1930, the authors visually compared the spatial
distribution of the *F. alnus* records with that of native *Rhamnus
alnifolia*, a species with similar habitat requirements. More recently,
Larkin (2011) examined the lengths of lag phases for multiple (\>200)
species of non-native invasive species in the Wisconsin and the southern
Lake Michigan region, applying the methods of (Aikio et al. 2010a). The
earliest record of *F. alnus* was collected in 1908 in the southern Lake
Michigan region, and based on quantitative analysis had a 31-year lag
phase. Comparatively, it was found in southern and northern Wisconsin in
1927 and 1941, and had 36- and 15-year lag phases, respectively. These
years of first regional introduction suggest that *F. alnus* spread
north from the southern Lake Michigan region into more northern parts of
Wisconsin. The length of the lag phase calculated for southern Lake
Michigan and southern Wisconsin generally agrees with my observations
for the whole range.

*Caveats and potential sources of bias*

I made several assumptions in carrying out the analyses presented here.
One assumption of note is that I treated the cumulative number of
occupied grid cells, and counties, as representative of the area of
extent. This may not be valid if *F. alnus* invades an area, but later
goes locally extinct. This is an unlikely occurrence. With one notable
exception (Cunard and Lee 2008), there are no documented examples of the
local extinction of *F. alnus*, either by natural processes or
management actions. This supports the notion that once a location is
occupied, it remains so. However, I am confident that some locations of
historical *F. alnus* occurrences no longer have the species present
because of changes in land use (e.g., development of once-woodland
plots). This is the case for several of the records observed in the
metropolitan New York region, the site of many of the earliest records.
Disturbances, or removal of population from the landscape, due to
anthropogenic influences may have a substantial effect on the spread of
*F. alnus* throughout its novel region. Nevertheless, it can be
successful in very small, isolated, and disturbed plots within a urban
or suburban land-use matrix (personal observation; (Del Tredici 2010).
Ultimately, the finest spatial resolution used in this study was 5 x 5
arc minutes (approximately 10 x 10 km) for the occupied grid cells
through time. The spatial resolution for the number of counties through
time varies, but the mean county area for all counties in the study
region is approximately 1500 km^2^, making it more course than the
occupied grid cells through time. For both resolutions, a complete local
extinction of *F. alnus* is unlikely.

A challenge in using historical biodiversity collections is that most
herbaria do not have electronic databases of their holdings that are
easily accessed by the public (i.e., a web-base search interface) and
many do not have a complete electronic database of records within the
institution (Lavoie 2012). Therefore, I know there are several herbaria
records that were not included in my compiled dataset because I did not
acquire them. Nevertheless, given the extent of the data compilation in
space and across institutions, I am confident that the patterns and
trends reported are generally representative of the spread of *F.
alnus*. I was able to collect records from some herbaria by directly
contacting curators and collection managers. Many collection managers
were happy to provide me with record information for *F. alnus*, in part
because there were generally a small number of records, and some were
able to provide me with information from records of the group of
associated species. However, because of the large request entailed in
collecting records for the associated species, I was not able to collect
these records from some herbaria. This is particularly problematic
because I focused my direct contact efforts on herbaria that I either
knew contained *F. alnus* (e.g. Miami University Herbarium) or herbaria
in regions that I thought were lacking in records collected by other
means. These collection issues result in underestimates of the amount of
area occupied by *F. alnus*, and further collections could potentially
increase the accuracy of my results.

**\
**

**Conclusions**

Despite concerns regarding the extent to which the compiled dataset
approximates a complete representation of the area occupied by *F.
alnus* through time, my results clearly support a rapid rate of spread
for this species throughout its invasion history. Calculating the ratio
of the cumulative number of grid cells and counties occupied by *F.
alnus* to those occupied by the group of associated species, I was able
identify time-periods associated with the expansion of *F. alnus* while
accounting for potential unequal spatial and temporal sampling bias in
occurrence record collection. Based on these calculations, *F. alnus*
has expanded rapidly throughout its invaded range since the mid to late
1920s. Patterns of spatial spread and estimates of lag phase duration
likely vary between regions. However, a quantitative analysis from one
region yielded a length for an extended lag phase consistent with what
was observed throughout the entire invaded range (Larkin 2011). The
patterns and processes of range expansion, particularly of lag phase
dynamics, likely vary depending on scale and local ecological conditions
(Theoharides and Dukes 2007). Further analysis could entail using the
datasets I have compiled, but restricting the calculations carried out
here to regional levels. I examine these patterns from a different
perspective in *Chapter 4*, where I use integrated species distribution
and demographic models to investigate the local and regional population
processes that result in the patterns I found in this chapter. This
integration allows for an examination of how local population processes,
such as individual plant survival, fruit production, and seed dispersal,
propagate to regional patterns such as those discussed here.

**Table 1.** Historical presence record sources and counts.
Abbreviations for “Accession Method” column: CBIF = Canadian
Biodiversity Information Facility, GBIF = Global Biodiversity
Information Facility, IPANE = Invasive Plant Atlas of New England, and
vPlants = Virtual Herbarium of the Chicago Region.

  **Source**                                                **Herbarium Code**   **Record Count**   **Accession Method**
  --------------------------------------------------------- -------------------- ------------------ --------------------------------
  Harvard University Arnold Arboretum                       A                    2                  IPANE
  Acadia University Herbarium                               ACAD                 8                  GBIF
  Botanischer Garten und Botanisches Museum Berlin-Dahlem   B                    1                  GBIF
  Brooklyn Botanical Garden                                 BKL                  35                 Institute website
  Chicago Botanic Garden                                    CHIC                 3                  Institute website / vPlants
  Rutgers University Chrysler Herbarium                     CHRB                 10                 Provided by curator
  Carnegie Museum of Natural History                        CM                   68                 Provided by curator
  University of Connecticut Torrey Herbarium                CONN                 85                 IPANE / GBIF
  Field Museum of Natural History                           F                    28                 Institute website / vPlants
  Harvard University Herbaria                               GH                   5                  IPANE
  Royal Botanical Gardens                                   HAM                  7                  CBIF
  University of Kansas                                      KANU                 3                  GBIF
  Forest Products Laboratory                                MAD                  1                  Institute website (U. of Wis.)
  University of Massachusetts                               MASS                 22                 IPANE
  University of Minnesota                                   MIN                  48                 Institute website
  Missouri Botanical Garden                                 MO                   2                  Institute website
  Morton Arboretum                                          MOR                  43                 Institute website
  Michigan State University                                 MSC                  25                 Institute website
  Université de Montréal                                    MT                   22                 GBIF
  Miami University                                          MU                   57                 Provided by curator
  Yale University Connecticut Botanical Society             NCBS                 3                  IPANE
  New England Botanical Club                                NEBC                 63                 IPANE
  New York Botanical Garden                                 NY                   5                  Institute website
  Ohio State University                                     OS                   81                 Institute website
  Queen’s University                                        QK                   2                  Institute website
  University of Wyoming Rocky Mountain Herbarium            RM                   2                  Institute website
  Smithsonian Institution                                   US                   3                  Institute website
  University of Wisconsin – Green Bay                       UWGB                 16                 Institute website (U. of Wis.)
  University of Wisconsin – Stevens Point                   UWSP                 6                  Institute website (U. of Wis.)
  Naturhistorisches Museum Wien                             W                    2                  
  University of Wisconsin – Madison                         WIS                  85                 Institute website (U. of Wis.)
  Yale University Peabody Museum of Natural History         YU                   4                  IPANE / GBIF
  Literature Search                                                              5                  ISI Web of Science

Figure 1. Population size versus time relationship for an exponentially
growing population. Black dots represent constant population growth rate
*R* = 1.2. Grey dots represent an increasing growth rate for the first
20 time steps from *R* = 1.0 to *R* = 1.2, then constant *R* = 1.2 from
time points 20 to 40. (A) Population size versus time. Inset plot is
Population size versus time for *R* = 1.2 for the first 20 time steps.
(B) Log (Population size) versus time. For constant *R*, note the
non-linear relationship in (A) versus the linear relationship in (B).
This relationship is non-linear in both (A) and (B) for a population
with an increasing growth rate (grey dots).

![](media/image1.emf)

Figure 2. Geographic locations of collected records for *F. alnus* and a
group of associated species. Red points represent records from the
compiled historical presence records for *F. alnus* and green points
represent records from the compiled historical presence records for the
group of associated species. Some locations were assigned geographic
locations based on the latitude and longitude values of counties as
defined by the US Census Bureau. Red outlined box delineates the study
region.

![](media/image2.emf)

Figure 3. Total number of records collected in each decade for *F.
alnus* (black bars) and the combined group of associated species (grey
bars).

![](media/image3.emf)

Figure 4. (A) Log cumulative number of records through time. Linear
(solid) and cubic polynomial (dot-dash) regression predictions are
plotted over the cumulative increase curves. (B) Ratio of growth rates
of cumulative number of records of *F. alnus* versus associated species
calculated annually (black circles) and by10 year moving window average
(geometric mean) (red dots). Note that some extreme data points are not
shown (those \>1.2 or \<0.8, but contribute to the moving window average
values. (C) Ratio of the cumulative number of records of *F. alnus* to
those of associated species.

![](media/image4.emf)

Figure 5. (A) Square root of the cumulative number of grid cells through
time. Shown here are the linear and polynomial regression lines for a
models using year as a predictor variable and the square root of the
cumulative number of grid cells occupied as the response variable.
Linear regression predictions are shown for both *F. alnus* and the
group of associated species. The best-fit polynomial regression fit is
shown for each set (quadratic for *F. alnus* and cubic for the group of
associated species) (B) Ratio of growth rates of cumulative occupied
grid cells calculated annually (black points) and by 10 year moving
window average (geometric mean) (red points). Outlier data not shown
(\>1.2 or \<0.8), but do contribute to the moving window average values.
(C) Ratio of square root of the 5 arc min grid cells occupied by *F.
alnus* and associated species at a given time step. Occupied 5 arc min
grid cells were constrained to be within 30 arc min grid cells occupied
by both *F. alnus* and associated species at least once during the study
period.

![](media/image5.emf)**\
**

Figure 6. (A) Square root of the cumulative number of counties occupied
through time. Shown here are the linear and polynomial regression lines
for a models using year as a predictor variable and the square root of
the cumulative number of counties occupied as the response variable.
Linear regression predictions are shown for both *F. alnus* and the
group of associated species (solid red and black lines respectively).
The best-fit polynomial regression fit is shown for each set (cubic for
both *F. alnus* and the group of associated species) (B) Ratio of the
rate of growth for cumulative occupied counties calculated annually
(black points) and by 10 year moving window average (geometric mean)
(red points). Outlier data not shown (those \>1.2 or \<0.8, but
contribute to the moving window average values. (C) Square root of the
ratio of the cumulative number of counties occupied by *F. alnus* to
those occupied by the group of associated species.

![](media/image6.emf)**\
**

**\*\*\*\***Remove this figure.\*\*\*\*

**Figure 7.** Frequency of the differences in the number of years
between an observation of an associated species in a county and the
observation of *F. alnus* in that county.

![](media/image7.emf)



## Notes and extras

Howell and Blackwell (1977) investigated the history of the spread of *F. alnus* into and throughout Ohio, and reported that the first recorded observation was from Lake County, Ohio in 1927 (confirmed via search of Ohio State University Herbarium).

Taft and Solecki (1990) reported that *F. alnus* was first recorded in the state of Illinois in 1912 (Sherff 1912, as cited by Taft and Solecki 1990) in Cook County (confirmed via search of Field Museum Herbarium).

Catling and Porebski (1994) investigated the spread of *F. alnus* into and throughout southern Ontario.

I used data reported in this paper to identify time and location of the three earliest records of *F. alnus* presence in this region.
