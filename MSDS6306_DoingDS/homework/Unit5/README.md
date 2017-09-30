# Documents for Unit 5 Homework

This directory contains everything needed to recreate Homework Number 5

## Codebook

### Raw Data
The raw data that are used in this analysis are 
* yob2015.txt (comma delimited)
* yob2016.txt (semicolon delimited)

These text files contain child naming data from 2015 and 2016 respectively. Each file contains Name, Genger, and Number of Children given the name

### Clean Data Set
The final clean data set contains the 10 most popular girls names from a combined dataset using yob2015 and yob2016. This is a CSV file called itsagirl.csv.

### Additional Files
Additonal files include
* kThomas_HW5.rmd - This is an RMD file that contains the code used to create the final cleaned data set (which is also outlined below), and some additonal analysis of the data.
* kThomas_HW5.html - Same as the RMD file but the final output report is in an HTML format.
* Assignment05.pdf - the actual homework assignment

### Process for Getting to the Clean Data Set (Using R)

1. Read in yob2016.txt and assign column names to the data (Name, Gender, Count)

```{r}
dfNames= read.table("yob2016.txt", sep = ";")#, col.names = c("First", "Gender", "Count"))
colnames(dfNames) = c("Name", "Gender", "Count")
```

2. Remove repeated data in 2016 dataset (one name of "Fionayyy")

```{r}
repeatNum = which(dfNames$Name == repeatName$Name[1])
y2016 = dfNames[-212,]
```

3. Read in the 2015 data and assign the same column names

```{r}
y2015= read.table("yob2015.txt", sep = ",", col.names = c("Name", "Gender", "Count"))
```

4. Merge the datasets by name
```{r}
final = merge(y2015, y2016, by="Name")
```

5. Identify the 10 most popular girl names and write to CSV
```{r}
girls = final[final$Gender.x == "F" & final$Gender.y == "F",]
girl = head(girls[order(girls$Total, decreasing = TRUE),],10)
write.csv(girl[c("Name", "Total")], "itsagirl.csv", row.names = FALSE)
```


If you have any questions regard this dataset please email me at khthomas@smu.edu