---
title: "Homework4_KThomas"
author: "Kyle Thomas"
date: "September 22, 2017"
output: html_document
---

```{r setup, include=FALSE}
#install fivethirtyeight package
install.packages("fivethirtyeight")
```
# Question 1: Five Thirty Eight Data
```{r}
#load the library
library(fivethirtyeight)
#load the data
five38 = data(package="fivethirtyeight")
#get 18th item
five38$results[18,"Item"]
data("college_recent_grads")
df = data.frame(college_recent_grads)
#find the URL of the related news story
vignette(package = "fivethirtyeight")
paste0("The URL for the package is: http://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/")
#give dimensions and column names of  the data
str(df)
```

# Question 2: Data Summary
```{r}
#2A
#get the column names
colnames(df)
#count the column names
length(colnames(df))
#2B find unique major categories, then count them, try it the elegant way
test = sapply(df$major_category,function(x) sum(df$major_category == x))
library(plyr)
major_count = count(df$major_category)

#2B - give up and brute force it... used this before finding plyr
uni_major = unique(df$major_category)
major_count2 = data.frame()
for (x in uni_major) {
    count = sum(df$major_category == x)
    new_row = data.frame(major = x, numDegree =  count)
    major_count = rbind(major_count, new_row)
}

#2C Plot the data
par(las=2)
barplot(major_count$freq, names = major_count$x, ylab = "Major Category", xlab = "County", main = "Number of College Majors by Category", col="blue", horiz = TRUE)

#2D Export data to csv
write.csv(df, "C:\\Users\\kthomas\\Documents\\SMU\\MSDS6306 - Doing Data Science\\Unit_4\\Download_homework")
```
