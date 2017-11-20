#Stats homework 11 R code

library(dplyr)
library(ggplot2)

#basic setup
setwd("~/SMU/MSDS6371 - Stats/Unit11")
dfmeta = read.csv("Metabolism_Data_Prob_26.csv")
dfautism = read.csv("Autism_Data_Prob_29.csv")

##question 1
#first log transform the data metabolism and mass data
dfmeta["logmetab"] = log(dfmeta$Metab)
dfmeta["logmass"] = log(dfmeta$Mass)

meta_fit = lm(logmetab~logmass, data=dfmeta)

plot(dfmeta$logmass, dfmeta$logmetab, xlab = "Mass (log)", ylab="Metabolism (log)", 
main = "Metabolism vs Mass")
abline(meta_fit, col="red")

newx = dfmeta$logmass
newx = sort(newx)


pred_conf = predict(meta_fit, newdata = data.frame(logmass = newx), interval = c("confidence"), type = c("response"), level = 0.95) 
pred_p = predict(meta_fit, newdata = data.frame(logmass = newx), interval = c("predict"), type = c("response"), level = 0.95) 

lines(newx, pred_conf[,2], col="blue", lty =2, lwd =2)
lines(newx, pred_conf[,3], col="blue", lty = 2, lwd = 2)

lines(newx, pred_p[,2], col="green", lty =2, lwd =2)
lines(newx, pred_p[,3], col="green", lty = 2, lwd = 2)


summary(meta_fit)

## Question 2
#EDA of Autism data
#fit the model
aFit = lm(Prevalence ~ Year, dfautism)

#plot the model
plot(dfautism$Year, dfautism$Prevalence,  xlab = "Year", ylab = "Autism Prevalence", 
     main = "Autism Prevalence vs Year")

abline(aFit, col = "red", lwd = 2)

#make prediciton and confidence intervals
newx2 = dfautism$Year
newx2 = sort(newx2)


pred_p2 = predict(aFit, newdata = data.frame(Year = newx2), interval = c("predict"), type = c("response"), level = 0.95)
pred_c2 = predict(aFit, newdata =  data.frame(Year = newx2), interval = c("confidence"), type = c("response"), level = 0.95)

lines(newx2, pred_c2[,2], col="blue", lty =2, lwd =2)
lines(newx2, pred_c2[,3], col="blue", lty = 2, lwd = 2)

lines(newx2, pred_p2[,2], col="green", lty =2, lwd =2)
lines(newx2, pred_p2[,3], col="green", lty = 2, lwd = 2)
