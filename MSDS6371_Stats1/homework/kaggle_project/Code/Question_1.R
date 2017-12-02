library(ggplot2)
library(readr)

#import data
all_home_data<- read_csv("C:/Users/student/Desktop/IntroToStats/13_14_Project/train (1) (1).csv")

#Only the three neighborhoods wanted
three_neighborhoods_data<-all_home_data[which(all_home_data$Neighborhood=="NAmes"|all_home_data$Neighborhood=="Edwards"|all_home_data$Neighborhood=="BrkSide"),]

#Only pick variables needed and add indicator variables
three_neighborhoods_clean<-data.frame(three_neighborhoods_data$Id,three_neighborhoods_data$Neighborhood,three_neighborhoods_data$GrLivArea,three_neighborhoods_data$SalePrice)
names(three_neighborhoods_clean)<-c("Id","Neighborhood","GrLivArea","SalePrice")
three_neighborhoods_clean$BrkSide<-ifelse(three_neighborhoods_clean$Neighborhood=="BrkSide",1,0)
three_neighborhoods_clean$NAmes<-ifelse(three_neighborhoods_clean$Neighborhood=="NAmes",1,0)
three_neighborhoods_clean$Edwards<-ifelse(three_neighborhoods_clean$Neighborhood=="Edwards",1,0)

#Scatter plot with regression lines and CIs
ggplot(three_neighborhoods_clean,aes(x=GrLivArea,y=SalePrice,shape=Neighborhood,color=Neighborhood))+geom_point()+geom_smooth(method='lm')
ggplot(subset(three_neighborhoods_clean,Neighborhood=="BrkSide"),aes(x=GrLivArea,y=SalePrice,shape=Neighborhood,color=Neighborhood))+geom_point()+geom_smooth(method='lm')
ggplot(subset(three_neighborhoods_clean,Neighborhood=="NAmes"),aes(x=GrLivArea,y=SalePrice,shape=Neighborhood,color=Neighborhood))+geom_point()+geom_smooth(method='lm')
ggplot(subset(three_neighborhoods_clean,Neighborhood=="Edwards"),aes(x=GrLivArea,y=SalePrice,shape=Neighborhood,color=Neighborhood))+geom_point()+geom_smooth(method='lm')

#Histogram for all data and for each neighborhood
attach(three_neighborhoods_clean)
par(mfrow=c(4,1))
hist(GrLivArea,main="All Data")
hist(three_neighborhoods_clean$GrLivArea[three_neighborhoods_clean$Neighborhood=="BrkSide"],main="BrkSide Only")
hist(three_neighborhoods_clean$GrLivArea[three_neighborhoods_clean$Neighborhood=="Edwards"],main="Edwards Only")
hist(three_neighborhoods_clean$GrLivArea[three_neighborhoods_clean$Neighborhood=="NAmes"],main="NAmes Only")

#Log of Square Feet
three_neighborhoods_clean$LogGrLivArea<-log(three_neighborhoods_clean$GrLivArea)
hist(three_neighborhoods_clean$LogGrLivArea)
ggplot(three_neighborhoods_clean,aes(x=LogGrLivArea,y=SalePrice,shape=Neighborhood,color=Neighborhood))+geom_point()+geom_smooth(method='lm')

#Create model. Uses NAmes as the referce neighborhood
three_neighborhood_model<-lm(SalePrice~LogGrLivArea+BrkSide+Edwards,data=three_neighborhoods_clean)
summary(three_neighborhood_model)
