#install.packages("fpp")
#install.packages("tseries")
library(fpp)
library(tseries)

#Example of 11.5 with the S&P 500

#F#Financial Series
SNPdata = get.hist.quote('^gspc', quote="Close")

#the lag function shifts data back by a given number of observations.
SNPret = log(lag(SNPdata)) - log(SNPdata)
#sqrt 250 is the number of trading days in a year, times 100 to get a percent
SNPvol = sd(SNPret) * sqrt(250) * 100

## volatility get with contuous lookback window

vol = function(d, logrets) {
  #d is weight (10 would be 1/10)
  #var is variance
  #lam is lambda
  #multiplies lambda (exponential value weight) 
  var = 0
  lam = 0
  varlist = c()
  for (r in logrets) {
    lam = lam*(1-1/d) + 1
    var = (1-1/lam)*var + (1/lam)*r^2
    varlist = c(varlist,var)
  }
  sqrt(varlist)
}

# recreate Figure 6.12 in the text on page 155

volest = vol(10, SNPret) #weight is 0.9 (1 - 1/10)
volest2 = vol(30, SNPret)
volest3 = vol(100, SNPret) 

plot(volest,type = "l")
lines(volest2,type = "l", col = "red")
lines(volest3,type = "l", col="blue")

#Exponential smoothing example
air = window(ausair, start=1990, end = 2004)
plot(air, ylab = "Airline Passengers", xlab = "Year")
fit1 = ses(air, alpha= 0.2, initial = "simple", h=3)
fit2 = ses(air, alpha = 0.6, initial = "simple", h=3)
fit3 = ses(air, h = 3)

plot(fit1, plot.conf=FALSE, ylab = "Airline Passengers", xlab = "Year", main = "", fcol = "while", type = "o")
lines(fitted(fit1), col="blue", type="o")
lines(fitted(fit2), col="red", type = "o")
lines(fitted(fit3), col="green", type="o")
lines(fit1$mean, col="blue", type="o")
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
# legend("topleft", lty=1, col=c(1,"blue", "red", "green"), c("data", 

#Holts Linear Trend Method
air = window(ausair, start=1990, end = 2004)
plot(air, ylab = "Airline Passengers", xlab = "Year")
fit1 = holt(air, alpha= 0.8, beta=0.2, initial = "simple", h=5)
fit1 = holt(air, alpha= 0.8, beta=0.2, initial = "simple", exponential = TRUE, h=5)

plot(fit1, plot.conf=FALSE, ylab = "Airline Passengers", xlab = "Year", main = "", fcol = "while", type = "o")
lines(fitted(fit1), col="blue", type="o")
lines(fitted(fit2), col="red", type = "o")
lines(fit1$mean, col="blue", type="o")
lines(fit2$mean, col="red", type="o")

#Example with seasonality
data(austourists)
aust = window(austourists, start=2005)
fit1 = hw(aust, seasonal = "additive")
fit2 = hw(aust, seasonal = "multiplicative")

plot(fit1, type = "l")
lines(fit2)












