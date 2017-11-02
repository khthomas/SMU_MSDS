library(ggplot2)
library(reshape2)

files = "http://stat.columbia.edu/~rachel/datasets/nyt"
listofsets = data.frame(col1="test")

#This will grab all of the data and put it into a list of dataframes... it is really slow.
for (x in 1:31) {
  listDF = list()
  
  link = paste(files, x, ".csv", sep="")
  
  holding = read.csv(url(link))
  listDF[[x]] = holding
  }
 
### This will get you as far as needed for the live session. You may need to change which dataset is needed
fileLocation <- "http://stat.columbia.edu/~rachel/datasets/nyt2.csv"
data1 <- read.csv(url(fileLocation))

#Cut takes a variable and binds it. Above the first group is -Inf to 18, then 18 to 24 etc.
data1$Age_Group <- cut(data1$Age, c(-Inf, 18, 24, 34, 44, 54, 64, Inf))

#change the levels to be more meaningful when read (changed the factors)
levels(data1$Age_Group) <- c("<18", "18-24", "25-34", "35-44", "45-54", "55-64", "65+")

#Problem: Click Through Rate (CTR) is notoriously small -- very few people click at all
# Can I get click through rate for our website? That could be interesting. Where can you get that data?
d1 = subset(data1, Impressions > 0)
d1$CTR = d1$Clicks/d1$Impressions

#change gender variable to a factor for GGplot
d1$Gender = as.factor(d1$Gender)

#Impressions by Gender
ggplot(d1, aes(x=Impressions, fill=Age_Group)) + theme(plot.title =element_text(hjust = 0.5)) + 
    geom_histogram(binwidth = 1) + ggtitle("Impressions by Age Group")

#CTR by Gender
ggplot(subset(d1, CTR>0), aes(x=CTR, fill=Gender)) +
  geom_histogram(binwidth = 0.05) + 
  ggtitle("CTR by Gender") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Probability of Click Through Rate: Clicks per Impression") +
  ylab("Count") +
  scale_fill_brewer(palette = "Dark2", labels=c("Female", "Male"))











