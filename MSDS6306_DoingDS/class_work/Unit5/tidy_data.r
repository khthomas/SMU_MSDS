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

#Recording Variables
fertoutliers$country[fertoutliers$country == "Korea, Rep"] = "South Korea"
  #rename Korea Rep to South Korea

#make a loggeg varable of fert
fertoutliers$logGertConsumption = log(fertoutliers$Fert)

#tip if there is any data that is zero and you need to log it change the value to a very small number
GatherData$Fert[GatherData$Fert == 0] = 0.001

#Creat Factor Variables
#this allows us to acces the data columns without calling the data frame $
attach(GatherData)
#make some groups and some labels
GatherData$FertGroup[Fert <= 18] = 1
GatherData$FertGroup[Fert > 18 & Fert <= 81] = 2
GatherData$FertGroup[Fert > 81 & Fert <= 158] = 3
GatherData$FertGroup[Fert > 158] = 4
FertLabels = c("low", "medium low", "medium high", "high")
str(GatherData)
#make the FertGroup a factor, this applies the labels to the numbers
GatherData$FertGroup = factor(GatherData$FertGroup, labels = FertLabels)
#another method is to know where you want the data broken down, then apply labels
#the breaks are important, 0-18, 18-81, 81-158, >159, use decimlas so R will cut off at correct place
FertFactor = cut(GatherData$Fert, breaks = c(-0.01, 17.99, 80.99, 157.99, 999.99), labels = c("low", "medium low", "medium high", "high"))
GatherData$FertFactor = FertFactor


#Time to merge some data frames
#download more datasets
fileURL = "https://www.dropbox.com/s/130c5ol3o2jjmgk/public.fin.msm.model.csv?raw=1"
FinRegData = source_data(fileURL, sep=",", header = TRUE)
fileURL2 = "https://raw.githubusercontent.com/christophergandrud/Disproportionality_Data/master/Disproportionality.csv"
DataURL = getURL(fileURL2)
#put the messy data into something nice, this textConnection function is the bomb
DispropData = read.table(textConnection(DataURL), sep=",", header = TRUE)

#Now lets merge the data files
#merge 2, clean them, then merge the third
dim(DispropData)
dim(FinRegData)
dim(GatherData)

#apply a country code, this comes from the library countrycode
FinRegData$iso2c = countrycode(FinRegData$country, origin="country.name", destination = "iso2c")

#going to merge on iso2c, this will create new variables for year and country as well
#columns with same names get duplicated and renamed by merge id
MergeData1 = merge(x=FinRegData, y=DispropData, by="iso2c", all = TRUE)
#now with a union argument (merging by both)
MergeData2 = merge(FinRegData, DispropData, union("iso2c", "year"), all = TRUE)
#third merge, you could just merge MergeData2 with itself and the third data frame
MergeData3 = merge(MergeData2, GatherData, union("iso2c","year"), all = TRUE)
#clean it up
#find duplicates
DataDuplicates = MergeData3[duplicated(MergeData3[,1:2]),]
nrow(DataDuplicates)
#remove the duplicates
DataNotDuplicated = MergeData3[!duplicated(MergeData3[,1:2]),]
#make the final clean dataset
#dplytr select the DataNotDuplicated and do not grab these rows
FinalCleanData = dplyr::select(DataNotDuplicated, -country.y, -country.x, -idn)

#Still have NA data from merges, need to determine how to handle that.  


#Importing Compressed Data
URL = "http://bit.ly/1jXJgDh"
temp = tempfile()
download.file(URL, temp)

UDSData = read.csv(gzfile(temp, "uds_summary.csv"))
unlink(temp)











