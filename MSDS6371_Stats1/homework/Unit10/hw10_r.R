#Code for Stats homework 10
library(ggplot2)
install.packages("investr")
library(investr)

df = read.csv("Male_Display_Data_Set.csv")

birdModel = lm(Tcell ~ Mass, data=df)
predModel = data.frame(pred=predict(birdModel,df), Mass=df$Mass)


####Make some plots Question 1B - ii
plot(df$Mass, df$Tcell, xlab = "Mass", ylab="TCell Count", 
main = "TCell Count vs Mass", xlim=range(0:15), ylim=range(0:1))
abline(birdModel, col="red")

newx = df$Mass
newx = sort(newx)


pred_conf = predict(birdModel, newdata = data.frame(Mass = newx), interval = c("confidence"), type = c("response"), level = 0.95) 
pred_p = predict(birdModel, newdata = data.frame(Mass = newx), interval = c("predict"), type = c("response"), level = 0.95) 

lines(newx, pred_conf[,2], col="blue", lty =2, lwd =2)
lines(newx, pred_conf[,3], col="blue", lty = 2, lwd = 2)

lines(newx, pred_p[,2], col="green", lty =2, lwd =2)
lines(newx, pred_p[,3], col="green", lty = 2, lwd = 2)


#Fancy plots
p1 = ggplot(df, aes(x=Mass, y=Tcell)) +
  geom_point(color="blue") + 
  geom_line(color="red", data=predModel, aes(x=Mass,y=pred))

p2 = ggplot(df, aes(x=Mass, y=Tcell)) +
  geom_point(color="blue") + 
  geom_smooth(method="lm", se = FALSE, color="red")


#### t table for predicitons of B0 and B1 ####
summary(birdModel)

#### Find 95% CI for a bird of 4.5 (not in dataset)####
bird45 = data.frame(Mass = c(4.5))
bird_ci = predict(birdModel, interval = "confidence", newdata = 4.5)
bird_ci


#### Find 95% prediciton for a bird of 4.5 (not in dataset)####
bird45 = data.frame(Mass = c(4.5))
bird_ci = predict(birdModel, interval = "predict", newdata = 4.5)
bird_ci

####Calibration####
mean = calibrate(birdModel, y0=0.3, interval = "inversion", mean.response = TRUE, level=0.95)
pred = calibrate(birdModel, y0=0.3, interval = "inversion", level=0.95)

### make a residual plot
birdResid = resid(birdModel)
plot(birdResid, main = "Residual Plot", ylab = "Residuals", xlab="Mass")
abline(0,0)










