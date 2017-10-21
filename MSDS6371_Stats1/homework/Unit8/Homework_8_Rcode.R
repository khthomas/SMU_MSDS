pathPrep <- function(path = "clipboard") {
  y <- if (path == "clipboard") {
    readClipboard()
  } else {
    cat("Please enter the path:\n\n")
    readline()
  }
  x <- chartr("\\", "/", y)
  writeClipboard(x)
  return(x)
}

library(ggplot2)

setwd("C:/Users/kthomas/Documents/SMU/MSDS6371 - Stats/Unit 8")

moneyball = read.csv("moneyball.csv")

#based on the scatter there appears to be some positive correlation. It may not be very strong though.
# I would guess 0.5 (why = there is a postive look, but the data appears to be scattered across my mental 
# line of best fit)
moneyScatter = ggplot(moneyball, aes(x=Payroll, y=Wins, group=Team)) + 
              geom_point(aes(colour=Team))


cor.test(moneyball$Payroll, moneyball$Wins) #corr.test also gives confidence intervals, p-value, t-stat, and df.... very good.

#Question 3 -- remove SD from dataset and redo analysis
noSD = moneyball[-29,]

nosdScatter = ggplot(noSD, aes(x=Payroll, y=Wins, group=Team)) + 
  geom_point(aes(colour=Team))

cor.test(noSD$Payroll, noSD$Wins)
