#Apples and Oranges Case Study (BLT Unit 5 Part 9)

#Questions to Answer
# Q1: Do the 10 most stable countries grow more apples or more orages (in total volume)
# Q2: What is the average amount of railroad in countires that grow more apples than oranges, and vice versa

#Set up and libraries
install.packages("downloader")
library(downloader)
library(reshape2)
setwd("~/SMU/MSDS6306 - Doing Data Science/Unit 5")
download("https://raw.githubusercontent.com/thoughtfulbloke/faoexample/master/stability.csv",
         destfile = "stability.csv")

download("https://raw.githubusercontent.com/thoughtfulbloke/faoexample/master/appleorange.csv","appleorange.csv")

#Read in the data files
stability = read.csv("stability.csv")
appleOrange = read.csv("appleorange.csv", stringsAsFactors = FALSE, header = FALSE)
names(appleOrange) = c("country", "countryNumber", "products", "productNumber", "tonnes", "year")

#convert country number from char to int
appleOrange$countryNumber = as.integer(appleOrange$countryNumber)

#fix the country by finding which lines has this variable
fslines = which(appleOrange$country == "Food supply quantity (tonnes) (tonnes)")
#then we cleverly apply -1 to fslines to drop them
appleOrange = appleOrange[(-1 * fslines),]

#clean the tonnes variable
appleOrange$tonnes = gsub("\xca","",appleOrange$tonnes)
appleOrange$tonnes = gsub(", tonnes \\(\\)","",appleOrange$tonnes)

#clean year data
appleOrange$year = 2009

#make an apples data set, select only columns 1,2 and 5
apples = appleOrange[appleOrange$productNumber == 2617, c(1,2,5)]
oranges = appleOrange[appleOrange$productNumber == 2611, c(1,2,5)]

names(apples)[3] = "apples"
names(oranges)[3] = "oranges"

#merge
CleanAO = merge(apples, oranges, by="countryNumber", all=TRUE)

CleanAO2 = dcast(appleOrange[,c(1:3,5)], formula = country + countryNumber ~ products, value.var="tonnes")
names(CleanAO2)[3:4] = c("apple","orange")

CleanAO2[!(complete.cases(CleanAO2)),]










