#libraries
library(repmis)
library(RCurl)
library(WDI)
library(plyr)
library(dplyr)
library(tidyr)
library(countrycode)
library(ggplot2)



#get the data
WDIsearch("fertilizer consumption")
FertCon = WDI(indicator = "AG.CON.FERT.ZS")
dim(FertCon)
str(FertCon)

#Spread the data (make wide format data)
spreadData = spread(FertCon, year, "AG.CON.FERT.ZS")
  #spread year into columns from row observations
  #this generated missing values which should be expected

SpreadData2 = arrange(FertCon, country)
  #this arranged data in alphabetical order (by country)

GatherData = gather(spreadData, Year, Fert, 3:9)
  #this brings data back to orginal shape, but year is a factor
  #aka its not a number anymore

#Order() will allow you to order the data


#Subsetting data
fertoutliers = subset(x = GatherData, Fert > 1000)




